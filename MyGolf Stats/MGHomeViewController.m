//
//  MGHomeViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGHomeViewController.h"
#import "MGParseSocialIntegration.h"
#import "ParseData.h"
#import "MGTotalStats.h"
#import "Handicap.h"
#import "CourseFromParse.h"
#import "MGHole.h"
#import <QuartzCore/QuartzCore.h>

@interface MGHomeViewController ()

@property (strong,nonatomic) MGTotalStats * stats;
@property (strong,nonatomic) Handicap * handicapClass;
@property (strong,nonatomic) ParseData * parseData;
@property (strong,nonatomic) NSArray * allHolesArray;
@property (strong,nonatomic) NSArray * preTimeFilterArray;
@property (strong,nonatomic) NSArray * filteredHolesAfterPredicates;
@property (strong,nonatomic) NSArray * uniqueDateArray;

@property (strong,nonatomic) NSMutableArray * courseFilterArray;
@property (strong,nonatomic) NSMutableArray * timeFilterArray;

@property (strong,nonatomic) NSString * parFilterSelection;
@property (strong,nonatomic) NSString * courseFilterSelection;
@property (strong,nonatomic) NSNumber * timeFilterSelection;

@property (strong,nonatomic) NSNumber *  courseIndexValue;
@property (strong,nonatomic) NSNumber * timeFrameIndexValue;

@property (strong,nonatomic) NSPredicate * parPredicate;
@property (strong,nonatomic) NSPredicate * coursePredicate;
@property (strong,nonatomic) NSPredicate * timePredicate;

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;

@property (strong,nonatomic) UIView* activityIndicator;


@end

NSInteger  courseIndexValue = 0;
NSInteger timeFrameIndexValue=0;

@implementation MGHomeViewController

bool facebookAccount;

@synthesize handicapClass=_handicapClass;
@synthesize courseFilterArray;
@synthesize activityIndicator;

NSInteger statsLabelYOffset = 0;

-(MGTotalStats*)stats
{
	return [MGTotalStats sharedTotalStats];
}
-(Handicap*)handicapClass
{
	return [Handicap sharedHandicap];
}
-(ParseData*)parseData
{
	return [ParseData sharedParseData];
}
-(NSArray*)allHolesArray
{
	NSArray * array = [[MGTotalStats sharedTotalStats]allHolesArray];
	return array;
}
-(NSMutableArray*)courseFilterArray
{
		NSArray * arrayFromParse = [[[ParseData sharedParseData]coursesFromParseWithHoles]mutableCopy];

		courseFilterArray = [[NSMutableArray alloc]init];
		[courseFilterArray addObject:@"All Courses"];

		NSInteger i;
		for (i=0; i<arrayFromParse.count; i++)
		{
			NSString * courseString =[arrayFromParse objectAtIndex:i];
			[courseFilterArray addObject:courseString];
		}
		return courseFilterArray;
}
-(NSMutableArray*)timeFilterArray
{
	if(!_timeFilterArray)
		_timeFilterArray= [[NSMutableArray alloc]init];
	[_timeFilterArray removeAllObjects];

	NSInteger roundCount = self.uniqueDateArray.count;

	[_timeFilterArray addObject:@"All Rounds"];

	if(roundCount >=5)
		[_timeFilterArray addObject:@"Last 5 Rounds"];
	if(roundCount >=10)
		[_timeFilterArray addObject:@"Last 10 Rounds"];
	if(roundCount >=15)
		[_timeFilterArray addObject:@"Last 15 Rounds"];
	if(roundCount >=20)
		[_timeFilterArray addObject:@"Last 20 Rounds"];

	return _timeFilterArray;
}

-(NSArray*)uniqueDateArray
{
    return [self uniqueDateArrayFromArray:self.parseData.holesFromParse];
}

-(NSPredicate*)coursePredicate
{
	if(!_coursePredicate)
		self.coursePredicate = [NSPredicate predicateWithFormat:@"course!= NULL"];
	return _coursePredicate;
}
-(NSPredicate*)parPredicate
{
	if(!_parPredicate)
		self.parPredicate= [NSPredicate predicateWithFormat:@"par >0"];
	return _parPredicate;
}
-(NSPredicate*)timePredicate
{
	if(!_timePredicate)
		_timePredicate= [NSPredicate predicateWithFormat:@"holeDate < now()"];
	return _timePredicate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES];
	[self.tabBarController.tabBar setHidden:NO];

    //Set up background view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"App Background"]];
    
    self.parFilterSelection=@"all";
	self.parFilter.selectedSegmentIndex=0;
    

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetPredicates) name:@"ParseHolesUpdated"  object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStats) name:@"ParseRoundsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMGProgressHUD) name: @"AllParseUpdatesComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFacebookPhoto) name: @"FacebookPhotoComplete" object:nil];
   
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCourseFilterArrayFromNotification) name:@"UniqueCourseArrayComplete" object:nil];

	[self.courseButton setTitle:[NSString stringWithFormat:@" %@",[self.courseFilterArray objectAtIndex:courseIndexValue]] forState:UIControlStateNormal];
	[self.timeButton setTitle:[NSString stringWithFormat:@" %@",[self.timeFilterArray objectAtIndex:timeFrameIndexValue]] forState:UIControlStateNormal];

	self.courseButton.layer.cornerRadius = 4;
	self.courseButton.layer.borderWidth = 1;
	self.courseButton.layer.borderColor = [UIColor whiteColor].CGColor;

	self.timeButton.layer.cornerRadius = 4;
	self.timeButton.layer.borderWidth = 1;
	self.timeButton.layer.borderColor = [UIColor whiteColor].CGColor;

	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;
    
    self.parseData.updatedDataNeeded=YES;
    
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        statsLabelYOffset = -15;
    }


}
-(void)setLabelPositions
{
    self.handicapTitle.frame = CGRectMake(115, 38+statsLabelYOffset, 120, 21);
    self.roundsTitle.frame = CGRectMake(115, 62+statsLabelYOffset, 120, 21);
    self.averageScoreTitle.frame = CGRectMake(115, 86+statsLabelYOffset, 120, 21);
    
    self.handicapLabel.frame = CGRectMake(240, 38+statsLabelYOffset, 40, 21);
    self.roundCountLabel.frame = CGRectMake(240, 62+statsLabelYOffset, 40, 21);
    self.roundScoringAverageLabel.frame = CGRectMake(236, 86+statsLabelYOffset, 48, 21);
}

-(void)setUp3_5View
{
    //Set up stats container view
    self.backgroundView.frame = CGRectMake(0, 0, 320, 92);
    
    //Set up Filter Box view
    self.filterBoxView.frame = CGRectMake(-2, 100, 324, 24);
    self.filterBoxView.layer.borderWidth = 1;
    self.filterBoxView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    //Set up Filter Selection view
    self.filterSelectionBoxView.frame = CGRectMake(-2, 123, 324, 98);
    self.filterSelectionBoxView.layer.borderWidth = 1;
    self.filterSelectionBoxView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.homeContainerView.frame = CGRectMake(0, 232, 320, 188);
 
}

-(void)viewWillLayoutSubviews
{
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        [self setUp3_5View];
    }
    else
    {
        [self setUp4_0View];
    }
    
    [self setLabelPositions];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeSubviewsComplete" object:nil];
}

-(void)setUp4_0View
{
    //Set up stats container view
    self.backgroundView.frame = CGRectMake(0, 0, 320, 129);
    
    //Set up Filter Box view
    self.filterBoxView.frame = CGRectMake(-2, 130, 324, 24);
    self.filterBoxView.layer.borderWidth = 1;
    self.filterBoxView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    //Set up Filter Selection view

    self.filterSelectionBoxView.frame = CGRectMake(-2, 154, 324, 98);
    self.filterSelectionBoxView.layer.borderWidth = 1;
    self.filterSelectionBoxView.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.homeContainerView.frame = CGRectMake(0, 253, 320, 266);
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)parFilterChanged:(id)sender
{
    //reset time predicate
    self.timeFilterSelection = [NSNumber numberWithInteger:0];
    self.timeFrameIndexValue = [NSNumber numberWithInteger:0];
    timeFrameIndexValue=0;
    [self.timeButton setTitle:@" All Rounds" forState:UIControlStateNormal];
    
	[self SetPredicates];
}

-(void)SetPredicates;
{
	// Set Par Predicate in MGTotalStats
	switch (self.parFilter.selectedSegmentIndex)
	{
		case 0:
		{
			self.parPredicate = [NSPredicate predicateWithFormat:@"par > 0"];
			self.parFilterSelection=@"all";
			break;
		}

		case 1:
		{
			self.parPredicate = [NSPredicate predicateWithFormat:@"par = 3"];
			self.parFilterSelection=@"3";
			break;
		}
		case 2:
		{
			self.parPredicate = [NSPredicate predicateWithFormat:@"par = 4"];
			self.parFilterSelection=@"4";
			break;
		}
		case 3:
		{
			self.parPredicate = [NSPredicate predicateWithFormat:@"par = 5"];
			self.parFilterSelection=@"5";
			break;
		}
	}
    
    self.stats.parFilterSelection = self.parFilterSelection;

	// Set Course Predicate in MGTotalStats
	if (courseIndexValue==0)
		self.coursePredicate = [NSPredicate predicateWithFormat:@"course <> 'none'"];
	else
		self.coursePredicate = [NSPredicate predicateWithFormat:@"course = %@",[courseFilterArray objectAtIndex:courseIndexValue]];
  
    self.preTimeFilterArray = [self preTimeFilterArray];
   
    
    // Set Time Filter Predicate
    if([self.timeFilterSelection intValue]==0)
	{
		self.filteredHolesAfterPredicates = self.preTimeFilterArray;
	}
    
	else
	{
		//NSArray* finalFilteredArray = [[NSMutableArray alloc]init];
        
        NSArray * dateArray = [self uniqueDateArrayFromArray:self.preTimeFilterArray];
        NSDate * predicateDate = [dateArray objectAtIndex:[self.timeFilterSelection integerValue]-1];
        
        self.timePredicate = [NSPredicate predicateWithFormat:@"holeDate >= %@",predicateDate];
        
        self.filteredHolesAfterPredicates  = [self.preTimeFilterArray filteredArrayUsingPredicate:self.timePredicate];
        
        NSInteger count = self.filteredHolesAfterPredicates.count;
        NSLog(@"%ld",(long)count);
        
        /*
		NSInteger i = 0;
        
		for (i=0; i<[self.timeFilterSelection intValue];i++)
		{
			[finalFilteredArray addObject:[self.preTimeFilterArray objectAtIndex:i]];
		}
         */
	}
    
    self.stats.filteredHolesAfterPredicates = self.filteredHolesAfterPredicates;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FilteredArrayComplete" object:nil];
    
    [self setStats];

		NSLog(@"Current Predicates:");
		NSLog(@"%@",self.parPredicate);
		NSLog(@"%@",self.coursePredicate);
		NSLog(@"%@",self.timeFilterSelection);
		NSLog(@"____________________");

}

-(NSArray*)preTimeFilterArray
{
    
    NSPredicate * combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:self.parPredicate,self.coursePredicate,nil]];
    
	NSArray * resultArray = [self.allHolesArray filteredArrayUsingPredicate:combinedPredicate];
    
	NSArray * sortedResultArray=[resultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"holeDate" ascending:NO]]];
    return sortedResultArray;
}

-(NSArray*)uniqueDateArrayFromArray:(NSArray*)array
{
    NSInteger y;
    NSMutableArray * dateArray = [[NSMutableArray alloc]init];
    
    for (y=0; y< self.preTimeFilterArray.count; y++)
    {
        NSDate * subjectDate = [[array objectAtIndex:y]valueForKey:@"holeDate"];
        
        if (![dateArray containsObject:subjectDate])
        {
            [dateArray addObject:subjectDate];
        }
    }
    NSLog(@"%@",dateArray);
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray * returnArray=[dateArray sortedArrayUsingDescriptors:descriptors];
    
    NSLog(@"%@",returnArray);
    
    return returnArray;
}


-(void)setStats
{
    if ([self.parseData.roundCount integerValue]==0)
    {
        self.handicapLabel.text = @"-";
        self.roundCountLabel.text = @"-";
        self.roundScoringAverageLabel.text = @"-";
    }
    else
    {
        self.handicapLabel.text = [self.handicapClass handicapCalculationString];
        self.roundCountLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.parseData.roundCount integerValue]];
        self.roundScoringAverageLabel.text=[NSString stringWithFormat:@"%.1f",[self.handicapClass scoringAveragePer18WithArray:self.parseData.roundsFromParse]];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:animated];
    [self setFacebookPhoto];
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    [self setFacebookPhoto];
    
	if ([PFUser currentUser] != nil)
	{
        if(self.parseData.updatedDataNeeded==YES)
            [self UpdateParseDataFromNetwork];
        [self setStats];
	}
    
   // else if ([self useNativeFacebookLogin] == YES)
    //{
        
  //  }
    
	else
	{

		PFLogInViewController *login = [[PFLogInViewController alloc]init];
		login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook | PFLogInFieldsTwitter|PFLogInFieldsPasswordForgotten ;
		login.delegate =self;
		login.logInView.logo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];

		// Instantiate our custom sign up view controller
		PFSignUpViewController *signUp = [[PFSignUpViewController alloc] init];
		signUp.fields = PFSignUpFieldsDefault;
		signUp.signUpView.logo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoMyGolf.png"]];
		signUp.delegate=self;

        // Link the sign up view controller
        [login setSignUpController:signUp];

		[self presentViewController:login animated:YES completion:Nil];
	}

	[PFAnalytics trackEvent:@"Home Page"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark Picker View Methods
- (IBAction)courseButtonTouched:(id)sender
{
	[self.courseTextBoxDummy becomeFirstResponder];
}

- (IBAction)timeButtonTouched:(id)sender
{
	[self.timeTextBoxDummy becomeFirstResponder];
}


- (IBAction)showFilterPicker:(id)sender
{
	if([self.courseTextBoxDummy isFirstResponder]==YES)
	{
		UIPickerView *courseFilterPicker = [[UIPickerView alloc] init];
		courseFilterPicker .delegate =self;
		courseFilterPicker .showsSelectionIndicator = YES;
		courseFilterPicker.tag = 1;
		[courseFilterPicker selectRow:courseIndexValue inComponent:0 animated:NO];
		//[courseFilterPicker setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Clouds.png"]]];
		[courseFilterPicker setBackgroundColor:[UIColor whiteColor]];


		[self.courseTextBoxDummy setInputView:courseFilterPicker];
		[self.courseButton setTitle:[NSString stringWithFormat:@" %@",[self.courseFilterArray objectAtIndex:courseIndexValue]] forState:UIControlStateNormal];
	}
	else

	{
		UIPickerView *timeFilterPicker = [[UIPickerView alloc] init];
		timeFilterPicker .delegate =self;
		timeFilterPicker.showsSelectionIndicator = YES;
		timeFilterPicker.tag = 2;
		[timeFilterPicker selectRow:timeFrameIndexValue inComponent:0 animated:NO];
		[timeFilterPicker setBackgroundColor:[UIColor whiteColor]];

		[self.timeTextBoxDummy setInputView:timeFilterPicker];
		[self.timeButton setTitle:[NSString stringWithFormat:@" %@",[self.timeFilterArray objectAtIndex:timeFrameIndexValue]] forState:UIControlStateNormal];
	}
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//One column
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if(pickerView.tag == 1)
    {
       NSArray * countArray = [self courseFilterArray];
        return countArray.count;
    }
    
	if(pickerView.tag == 2)
    {
        NSInteger setsOf5 = self.uniqueDateArray.count/5;
       
        if(setsOf5 <= 5)
               return setsOf5+1;
        else
            return 5;
    }
    
	else return 0;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if(pickerView.tag == 1) return [self.courseFilterArray objectAtIndex:row];
	if(pickerView.tag == 2) return [self.timeFilterArray objectAtIndex:row];
	else return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if(pickerView.tag == 1) //Course Filter
	{
		self.stats.courseFilterSelection = [self.courseFilterArray objectAtIndex:row];
		self.stats.courseIndexValue = [NSNumber numberWithInteger:row];
		courseIndexValue=row;
		[self.courseButton setTitle:[NSString stringWithFormat:@" %@",[self.courseFilterArray objectAtIndex:row]] forState:UIControlStateNormal];
       
        //reset time predicate
        self.timeFilterSelection = [NSNumber numberWithInteger:0];
		self.timeFrameIndexValue = [NSNumber numberWithInteger:0];
		timeFrameIndexValue=0;
		[self.timeButton setTitle:@" All Rounds" forState:UIControlStateNormal];
	}

	else if(pickerView.tag == 2) // Time Filter
	{
		self.stats.timeFilterSelection = [NSNumber numberWithInteger:row*5];
		self.stats.timeFrameIndexValue = [NSNumber numberWithInteger:row];
        
        self.timeFilterSelection = [NSNumber numberWithInteger:row*5];
		self.timeFrameIndexValue = [NSNumber numberWithInteger:row];
		
        timeFrameIndexValue=row;
		[self.timeButton setTitle:[NSString stringWithFormat:@" %@",[self.timeFilterArray objectAtIndex:row]] forState:UIControlStateNormal];
	}

	else return ;

	[self SetPredicates];
}
- (IBAction)toolbarSetup:(id)sender
{

    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];
}

- (void)doneDidTouchDown
{
	[self.courseTextBoxDummy resignFirstResponder];
	[self.timeTextBoxDummy resignFirstResponder];
}

- (void)nextDidTouchDown
{/**/}

- (void)previousDidTouchDown
{/**/}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }

    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
	[self viewDidAppear:YES];
    [self setStats];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FilteredArrayComplete" object:nil];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }

    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }

    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:NULL];


	PFQuery *query = [PFUser query];
	[query whereKey:@"username" equalTo:user.username];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
	 {
		 if(!error)
		 {
			 PFObject * currentUserObject = [PFQuery getUserObjectWithId:user.objectId];
			 [currentUserObject setObject:[NSNumber numberWithBool:NO] forKey:@"MyGolfStatsFullVersion"];
             [currentUserObject setObject:[NSNumber numberWithBool:NO] forKey:@"HandicapCalculatorFullVersion"];
			 [currentUserObject saveInBackground];
		 }
	 }];
    
	[self UpdateParseDataFromNetwork];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - PFSignUpViewControllerDelegate

-(void)setFacebookPhoto
{
	if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
	{
		PFQuery *query = [PFUser query];
		[query whereKey:@"username" equalTo:[PFUser currentUser].username];
		[query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
		 {
			 if(!error)
			 {
				 PFFile *facebookPhoto = user[@"userFacebookPicture"];
				 [facebookPhoto getDataInBackgroundWithBlock:^(NSData * photo,NSError * error)
				  {
					  if(!error)
					  {
						  self.facebookImage.image =[UIImage imageWithData:photo];
                          
                          if ([UIScreen mainScreen].bounds.size.height<568)
                              [self setRoundedView:_facebookImage toDiameter:75.0];
                          else
                           [self setRoundedView:_facebookImage toDiameter:90.0];
					  }
				  }];
			 }
		 }];
	}
	else
	{
		self.facebookImage.image=[UIImage imageNamed:@"Avatar.png"];
		[self setRoundedView:_facebookImage toDiameter:80.0];
	}

}

-(void) UpdateParseDataFromNetwork
{
    activityIndicator = [[UIView alloc]initWithFrame:self.view.frame];
    activityIndicator.opaque = NO;
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    
   [MBProgressHUD showHUDAddedTo:self.view animated:NO];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        NSLog(@"Updating Parse Data From Network");
        [[ParseData sharedParseData] updateParseRounds];
        [[ParseData sharedParseData] updateParseRoundsRecent20];
        [[ParseData sharedParseData] updateParseCourses];
     //	[[ParseData sharedParseData] updateParseCoursesWithHoles];
        [[ParseData sharedParseData] updateParseHoles];
     // [[ParseData sharedParseData] updateParseShots];
        [[ParseData sharedParseData] updateAppVersion];
    });
    
}
-(void)stopMGProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [self.activityIndicator removeFromSuperview];
    self.parseData.updatedDataNeeded=NO;
    
    [MGParseSocialIntegration syncFacebookData];
	[MGParseSocialIntegration syncTwitterData];
}


-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
	roundedView.clipsToBounds = YES;
    roundedView.center = saveCenter;
	if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
	{
		roundedView.layer.borderColor = [UIColor whiteColor].CGColor;
		roundedView.layer.borderWidth = 3.0f;
	}
}
  /*
-(BOOL)useNativeFacebookLogin
{
    
 ACAccountStore *store = [[ACAccountStore alloc] init];
 ACAccountType *accountType  = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
 NSArray *accounts = [[store accountsWithAccountType:accountType];

    
    switch (accounts.count)
    {
        case 1:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
  
}
  */

@end
