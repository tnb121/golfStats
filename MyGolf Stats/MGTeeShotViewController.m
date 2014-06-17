//
//  MGTeeShotViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGAppDelegate.h"
#import "MGTeeShotViewController.h"
#import "MGCurrentRound.h"
#import "MGApproachShotViewController.h"
#import "MGGreenViewController.h"
#import "MGRound.h"
#import "MGCurrentRound.h"
#import "Clubs.h"


@interface MGTeeShotViewController ()

@property (strong,nonatomic) MGShot * activeShot;
@property (strong,nonatomic) NSString * shotTracking;
@property (strong,nonatomic) NSString * startingLocation;
@property (strong,nonatomic) NSString * endingLocation;

@property (strong,nonatomic) MGRoundStats * stats;
@property (strong,nonatomic) MGCurrentRound * currentRound;

@property (strong,nonatomic) NSString * locationTouched;

@property (strong,nonatomic) NSArray * clubArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic) UIPickerView * clubPicker;

@end

NSInteger clubArrayIndex;


@implementation MGTeeShotViewController

@synthesize activeShot=_activeShot;

NSInteger parLabelYOffsetData = 0;
NSInteger parSelectorYOffsetData = 0;
NSInteger parLabelsHeightOffset = 0;
NSInteger fairwayHitLabelYOffsetData = 0;
NSInteger fairwayLeftLabelYOffsetData = 0;
NSInteger fairwayRightLabelYOffsetData = 0;
NSInteger fairwayLongLabelYOffsetData = 0;
NSInteger fairwayShortLabelYOffsetData = 0;
NSInteger holeLabelsAndButtonsYOffsetData = 0;
float  switchHeightScale = 1.0;



-(NSString*)shotTracking
{
	return [[NSUserDefaults standardUserDefaults]objectForKey:@"shotTracking"];
}


-(MGRoundStats*)stats
{
	return [MGRoundStats sharedRoundStats];
}

-(MGCurrentRound*)currentRound
{
    return [MGCurrentRound sharedCurrentRound];
}
-(MGHole*)activeHoleObject
{
    if (!_activeHoleObject)
            _activeHoleObject = [self.currentRound.holes objectAtIndex:[self.currentRound.currentHole integerValue]-1];
    return _activeHoleObject;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
      self.fairwayImageView.image= [UIImage imageNamed:@"Fairway Image (data collection)(3.5).png"];
    }
    
    else
    {
        self.fairwayImageView.image = [UIImage imageNamed:@"Fairway Image (data collection).png"];
    }
    
    
    UIFont *font = [UIFont boldSystemFontOfSize:20.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.holePar setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    self.holePar.layer.cornerRadius=5;
    
    self.parFrameView.layer.cornerRadius = 5;
    //self.parFrameView.layer.borderWidth = 1;
   // self.parFrameView.layer.borderColor=[UIColor whiteColor].CGColor;

	[_holePar addTarget:self action:@selector(parChanged:)forControlEvents:UIControlEventValueChanged];
	[_holeNumberStepper addTarget:self action:@selector(holeStepperChanged:) forControlEvents:UIControlEventValueChanged];

	[self.holePar setSelectedSegmentIndex:1];
    if(!self.activeHoleObject.par)
        self.activeHoleObject.par= [NSNumber numberWithInteger: self.holePar.selectedSegmentIndex + 3];

	_holeNumberStepper.minimumValue = 1;
	_holeNumberStepper.maximumValue=18;

	[self singleSwipeViewSetup];
	[self doubleSwipeHoleSetup];

	if(!self.managedObjectContext)
		self.managedObjectContext = [(MGAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];

	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;

	self.clubSelectionTextBox.delegate=self;
	self.clubPicker.delegate = self;
	self.clubPicker.dataSource=self;

	if ([self.shotTracking isEqualToString:@"shot"])
		{
			_activeShot = [MGShot object];
			_activeShot.parseID=[PFUser currentUser].username;
			_activeShot.roundID=[[MGCurrentRound sharedCurrentRound]roundID];
			_activeShot.holeNumber=[[MGCurrentRound sharedCurrentRound]currentHole];
			_activeShot.target = @"fairway";
			if (!self.startingLocation)
				_activeShot.startingLocation=@"teeBox";
			else
				_activeShot.startingLocation=self.startingLocation;
		}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	[self setCurrentHoleValues];

	//Enable or Disable based on Par
	if([_activeHoleObject.par integerValue] ==3)
        [self disableSwitches];
	else
        [self enableSwitches];
    [self parChanged:self];
	[self setClubButton];
    
}

-(void)viewWillLayoutSubviews
{
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
       parLabelYOffsetData          = -4;
       parSelectorYOffsetData       = -1;
       parLabelsHeightOffset        = -5;
       fairwayHitLabelYOffsetData   = -42;
       fairwayLeftLabelYOffsetData  = -42;
       fairwayRightLabelYOffsetData = -42;
       fairwayLongLabelYOffsetData  = -14;
       fairwayShortLabelYOffsetData = -71;
       switchHeightScale            = 0.85;
        
        holeLabelsAndButtonsYOffsetData = -75;
        
       self.parLabel.font = [UIFont boldSystemFontOfSize:19.0f];

    
    self.holePar.transform = CGAffineTransformMakeScale(switchHeightScale, switchHeightScale);
  
    self.parLabel.frame = CGRectMake(20,6 + parLabelYOffsetData , 66, 29);
    self.holePar.frame  = CGRectMake(70,7 + parSelectorYOffsetData , 150, 29 + parLabelsHeightOffset);
        
    self.fairwayLong.frame  = CGRectMake(138, 52 + fairwayLongLabelYOffsetData, 51, 31);
    self.fairwayLeft.frame  = CGRectMake(15 ,184 + fairwayLeftLabelYOffsetData, 51, 31);
    self.fairwayHit.frame   = CGRectMake(138,184 + fairwayHitLabelYOffsetData, 51, 31);
    self.fairwayRight.frame = CGRectMake(254,184 + fairwayRightLabelYOffsetData, 51, 31);
    self.fairwayShort.frame = CGRectMake(138,322 + fairwayShortLabelYOffsetData, 51, 31);
        
    self.previousHoleButton.frame = CGRectMake(46, 362 + holeLabelsAndButtonsYOffsetData, 60, 35);
    self.holeNumberLabel.frame    = CGRectMake(114, 366 + holeLabelsAndButtonsYOffsetData, 97, 28);
    self.nextHoleButton.frame     = CGRectMake(218, 362 + holeLabelsAndButtonsYOffsetData, 60, 35);
        
    
    self.fairwayLong.transform  = CGAffineTransformMakeScale(switchHeightScale, switchHeightScale);
    self.fairwayLeft.transform  = CGAffineTransformMakeScale(switchHeightScale, switchHeightScale);
    self.fairwayHit.transform  = CGAffineTransformMakeScale(switchHeightScale, switchHeightScale);
    self.fairwayRight.transform  = CGAffineTransformMakeScale(switchHeightScale, switchHeightScale);
    self.fairwayShort.transform  = CGAffineTransformMakeScale(switchHeightScale, switchHeightScale);
    
    }

}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
	[self.tabBarController.tabBar setHidden:YES];
    [self setCurrentHoleValues];
}

-(void) setCurrentHoleValues
{
	//Set values of UI Elements
	NSInteger currentHoleNumber=[self.currentRound.currentHole integerValue];
	self.activeHoleObject = [self.currentRound.holes objectAtIndex:currentHoleNumber-1];
    
	_holeNumberStepper.value =currentHoleNumber;
    
    if(!self.activeHoleObject.par)
        self.activeHoleObject.par = [NSNumber numberWithInt:4];
    self.holePar.selectedSegmentIndex = [self.activeHoleObject.par integerValue]-3;
    
    if(self.holePar.selectedSegmentIndex ==0)
        [self disableSwitches];
    else
        [self enableSwitches];
    
	self.holeNumberLabel.text = [@"Hole " stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[self.activeHoleObject.holeNumber integerValue]]];
    NSString * testString =[@"Hole " stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)currentHoleNumber]];
    self.holeNumberLabel.text = testString;
    [self enableOrDisableHoleButtons];

	if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shotTracking"]isEqualToString:@"shot"])
	{
		[self.fairwayHit setOn:NO];
		[self.fairwayLeft setOn:NO];
		[self.fairwayLong setOn:NO];
		[self.fairwayRight setOn:NO];
		[self.fairwayShort setOn:NO];
	}
	else if ([_activeHoleObject.fairway  isEqual: @"fairwayLong"])
    {
        [self.fairwayLong setOn:YES];
        self.locationTouched = @"fairwayLong";
    }
	else if ([_activeHoleObject.fairway  isEqual: @"fairwayShort"])
    {
        [self.fairwayShort setOn:YES];
        self.locationTouched = @"fairwayShort";
    }
	else if ([_activeHoleObject.fairway  isEqual: @"fairwayLeft"])
    {
        [self.fairwayLeft setOn:YES];
        self.locationTouched = @"fairwayLeft";
    }
	else if ([_activeHoleObject.fairway  isEqual: @"fairwayRight"])
    {
        [self.fairwayRight setOn:YES];
        self.locationTouched = @"fairwayRight";
    }
	else if ([_activeHoleObject.fairway  isEqual: @"fairwayHit"])
    {
        [self.fairwayHit setOn:YES];
        self.locationTouched = @"fairwayHit";
    }
	else
	{
		[self.fairwayHit setOn:NO];
		[self.fairwayLeft setOn:NO];
		[self.fairwayLong setOn:NO];
		[self.fairwayRight setOn:NO];
		[self.fairwayShort setOn:NO];
        self.locationTouched = nil;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parChanged:(id)sender
{
	self.activeHoleObject.par= [NSNumber numberWithInteger: self.holePar.selectedSegmentIndex + 3];
	if([_activeHoleObject.par integerValue] ==3)
	{
        [self resetFairwayValues];
		[self disableSwitches];
        [self presentFairwayForPar3View];
        [self.view bringSubviewToFront:self.holePar];
        [self.view bringSubviewToFront:self.parLabel];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
	}
	else
    {
        [self removeFairwayForPar3View];
        [self enableSwitches];
    }
}

-(void)holeStepperChanged:(UIStepper*)holeStepper
{
	double value = _holeNumberStepper.value;

	[self.holeNumberLabel setText:[@"Hole " stringByAppendingString:[NSString stringWithFormat:@"%f", value]]];
	[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithDouble:value] forKey:@"currentHole"];

	if([self.navigationController.visibleViewController isKindOfClass:[MGTeeShotViewController class]])
	{
		[self setCurrentHoleValues];
	}
	else
	{
		[[MGCurrentRound sharedCurrentRound] setValue: [NSNumber numberWithDouble:value] forKey:@"currentHole"];

		MGTeeShotViewController *viewController = [[MGTeeShotViewController alloc] init];
		[self.navigationController pushViewController:viewController animated:YES];
	}
}
- (IBAction)previousHoleButtonPressed:(id)sender
{
    self.currentRound.currentHole= [NSNumber numberWithInteger:([self.currentRound.currentHole integerValue] - 1)];
    [self setCurrentHoleValues];
}

- (IBAction)nextHoleButtonPressed:(id)sender
{
    self.currentRound.currentHole= [NSNumber numberWithInteger:([self.currentRound.currentHole integerValue] + 1)];
    [self setCurrentHoleValues];
}

-(void)enableOrDisableHoleButtons
{
     switch ([self.currentRound.currentHole integerValue])
    {
        case 1:
            self.previousHoleButton.enabled = NO;
            self.nextHoleButton.enabled = YES;
            break;
        case 18:
            self.previousHoleButton.enabled = YES;
            self.nextHoleButton.enabled = NO;
            break;
        default:
            self.previousHoleButton.enabled = YES;
            self.nextHoleButton.enabled = YES;
            break;
    }
}

-(void)disableSwitches
{
	self.fairwayHit.enabled = NO;
	self.fairwayLeft.enabled = NO;
	self.fairwayRight.enabled = NO;
	self.fairwayLong.enabled = NO;
	self.fairwayShort.enabled = NO;
}
-(void)enableSwitches
{
	self.fairwayHit.enabled = YES;
	self.fairwayLeft.enabled =YES;
	self.fairwayRight.enabled = YES;
	self.fairwayLong.enabled = YES;
	self.fairwayShort.enabled = YES;
}

- (IBAction)fairwayLongTouched:(id)sender
{
	self.locationTouched = @"fairwayLong";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:YES];
	[self.fairwayShort setOn:NO];
	[self setFairwayValue];
    [self presentSwipeToNextViewImage];
}

- (IBAction)fairwayLeftTouched:(id)sender
{
	self.locationTouched  = @"fairwayLeft";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:YES];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:NO];
	[self setFairwayValue];
    [self presentSwipeToNextViewImage];
}

- (IBAction)fairwayShortTouched:(id)sender
{
	self.locationTouched  = @"fairwayShort";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:YES];
	[self setFairwayValue];
    [self presentSwipeToNextViewImage];
}
- (IBAction)fairwayRightTouched:(id)sender
{
	self.locationTouched  = @"fairwayRight";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:YES];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:NO];
	[self setFairwayValue];
    [self presentSwipeToNextViewImage];
}
- (IBAction)fairwayHitTouched:(id)sender
{
	self.locationTouched  = @"fairwayHit";
	[self.fairwayHit setOn:YES];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:NO];
	[self setFairwayValue];
    [self presentSwipeToNextViewImage];
}
- (void)resetFairwayValues
{
	self.locationTouched  = nil;
	self.activeShot.endingLocation=nil;
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:NO];
    self.activeHoleObject.fairway=nil;
    [self enableSwitches];
}

-(void)setFairwayValue
{
	if (self.holePar.selectedSegmentIndex==0)
	{
		self.activeHoleObject.fairway=nil;
		return;
	}

	if ([self.shotTracking isEqualToString:@"shot"])
	{
		self.activeShot.endingLocation=self.locationTouched;

		if (!self.holePar.selectedSegmentIndex==0)
			{
				if (self.activeHoleObject.shots.count>0)
					return;
				else
					{
						self.activeHoleObject.fairway=self.locationTouched;
					}
			}
	}

	else self.activeHoleObject.fairway=self.locationTouched;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];

}

-(void)presentSwipeToNextViewImage
{
    if ([self.currentRound.currentHole integerValue] == 1 || [self.activeHoleObject.par integerValue] == 3)
    {
        self.swipeView = [[UIImageView alloc]initWithFrame:CGRectMake(55, 104, 211, 59)];
        self.swipeView.image = [UIImage imageNamed:@"swipe to next screen.png"];
        [self.view addSubview:self.swipeView];
    }
    
}

-(void)removeSwipeToNextViewImage
{
    [self.swipeView removeFromSuperview];
}

-(void)presentFairwayForPar3View
{
    
    self.par3AlphaView = [[UIView alloc]initWithFrame:self.view.frame];
    self.par3AlphaView.opaque = NO;
    self.par3AlphaView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    self.par3AlphaView.center = self.view.center;
    [self.view addSubview: self.par3AlphaView];
    
    [self presentSwipeToNextViewImage];
    
}

-(void)removeFairwayForPar3View
{
    [self.swipeView removeFromSuperview];
    [self.par3AlphaView removeFromSuperview];
}

-(void)setClubButton
{

	if ([self.shotTracking isEqualToString:@"shot"])
	{
		[self.clubSelectionButton setHidden:NO];

		if(!self.activeShot.club)
		{
			[self.clubSelectionButton setTitle:@"Select a Club" forState:UIControlStateNormal];
			[self.clubSelectionButton setTitle:@"Select a Club" forState:UIControlStateHighlighted];
			[self.clubSelectionButton setTitle:@"Select a Club" forState:UIControlStateDisabled];
			[self.clubSelectionButton setTitle:@"Select a Club" forState:UIControlStateSelected];
		}
		else
		{
			NSString * clubString = [@"Club: " stringByAppendingString:self.activeShot.club];
			[self.clubSelectionButton setTitle:clubString forState:UIControlStateNormal];
			[self.clubSelectionButton setTitle:clubString forState:UIControlStateHighlighted];
			[self.clubSelectionButton setTitle:clubString forState:UIControlStateDisabled];
			[self.clubSelectionButton setTitle:clubString forState:UIControlStateSelected];
		}
	}

	else
	{
		[self.clubSelectionButton setHidden:YES];
	}
}
- (IBAction)setTextBoxToFirstResponder:(id)sender
{
	[self.clubSelectionTextBox becomeFirstResponder];
}

- (IBAction)clubSelection:(id)sender
{
	self.clubPicker= [[UIPickerView alloc] init];
	self.clubPicker.delegate =self;
	self.clubPicker.showsSelectionIndicator = YES;
	self.clubPicker.tag = 1;
	[self.clubSelectionTextBox setInputView:self.clubPicker];


	//Get selected clubs from Core Data

	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Clubs" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"distanceRank" ascending:YES];
	[request setSortDescriptors:@[sortDescriptor]];

	NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"inBag == 1"];
	[request setPredicate:testForTrue];

	NSError *error;
	self.clubArray = [moc executeFetchRequest:request error:&error];


	if (!clubArrayIndex)clubArrayIndex=0;
	Clubs *club = [self.clubArray objectAtIndex:clubArrayIndex];
	self.activeShot.club= club.club;
	[self.clubPicker selectRow:clubArrayIndex inComponent:0 animated:YES];

}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//One column
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

	NSInteger count =  self.clubArray.count;
	return count;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	Clubs *club = [self.clubArray objectAtIndex:row];
	return club.club;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	Clubs *club = [self.clubArray objectAtIndex:row];
	NSString* clubString = club.club;
	self.activeShot.club = clubString;
	NSLog(@"%@",self.activeShot.club);
	clubArrayIndex = row;
	[self setClubButton];
}


- (IBAction)toolbarSetup:(id)sender
{
    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];
}


- (void)nextDidTouchDown
{}

- (void)previousDidTouchDown
{}

- (void)doneDidTouchDown
{
	[self.clubSelectionTextBox endEditing:YES];
	[self setClubButton];
}


- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender

{
	if ([[segue identifier] isEqualToString:@"teeToApproachSegue"])

	{
		if ([self.shotTracking isEqualToString:@"shot"])
			if(!self.holePar.selectedSegmentIndex==0)
				[_activeHoleObject.shots addObject:_activeShot];

		MGApproachShotViewController* vc = (MGApproachShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
		vc.startingLocation=self.activeShot.endingLocation;
	}

	else if ([[segue identifier] isEqualToString:@"teeToTeeSegue"])

	{
		if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shotTracking"]isEqualToString:@"shot"])
			[self.activeHoleObject.shots addObject:self.activeShot];

		MGTeeShotViewController* vc = (MGTeeShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
		vc.startingLocation=self.activeShot.endingLocation;
	}

}

-(void) nextViewFromSwipe
{
	[self chooseSegue];
}


-(void)chooseSegue
{
	if ([self.shotTracking isEqualToString:@"shot"])
	{
		switch(self.holePar.selectedSegmentIndex)
		{
			case 0:
					[self performSegueWithIdentifier:@"teeToApproachSegue" sender:self];
				break;
			case 1:
				if([self.activeShot.endingLocation isEqualToString:@"fairwayHit"])
					[self performSegueWithIdentifier:@"teeToApproachSegue" sender:self];
				else
					[self fairwayGreenAlertSelector];
				break;
			case 2:
				if(self.activeHoleObject.shots.count == 0)
					[self fairwayGreenAlertSelector];
				else
				{
					if([self.activeShot.endingLocation isEqualToString:@"fairwayHit"])
						[self performSegueWithIdentifier:@"teeToApproachSegue" sender:self];
					else
						[self fairwayGreenAlertSelector];
				}
				break;
		}
	}

	else
	{
        if(!self.locationTouched && [self.activeHoleObject.par integerValue]>3)
        {
            UIAlertView *noDataAlert= [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Please select ending location of shot"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            [noDataAlert show];
            return;
        }
        
		[self performSegueWithIdentifier:@"teeToApproachSegue" sender:self];
	}

}
-(void)fairwayGreenAlertSelector
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:@"What is the target of your next shot?"
												   delegate:self
										  cancelButtonTitle:nil
										  otherButtonTitles: @"Green",@"Fairway", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];

    if ([buttonTitle isEqualToString:@"Green"])
	{
		[self performSegueWithIdentifier:@"teeToApproachSegue" sender:self];
	}

	if ([buttonTitle isEqualToString:@"Fairway"])
	{
		[self performSegueWithIdentifier:@"teeToTeeSegue" sender:self];
	}
}



#pragma mark Swipes

-(void)singleSwipeViewSetup
{
	UISwipeGestureRecognizer * viewSingleSwipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextViewFromSwipe)];
	viewSingleSwipeLeft.numberOfTouchesRequired=1;
	viewSingleSwipeLeft.direction= UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:viewSingleSwipeLeft];

	UISwipeGestureRecognizer * viewSingleSwipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(previousViewFromSwipe)];
	viewSingleSwipeRight.numberOfTouchesRequired=1;
	viewSingleSwipeRight.direction= UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:viewSingleSwipeRight];

}

-(void) previousViewFromSwipe
{
    return;
}


-(void)doubleSwipeHoleSetup
{
	UISwipeGestureRecognizer * holeDoubleSwipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(holeDoubleSwipeLeft)];
	holeDoubleSwipeLeft.numberOfTouchesRequired=2;
	holeDoubleSwipeLeft.direction= UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:holeDoubleSwipeLeft];

	UISwipeGestureRecognizer * holeDoubleSwipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(holeDoubleSwipeRight)];
	holeDoubleSwipeRight.numberOfTouchesRequired=2;
	holeDoubleSwipeRight.direction= UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:holeDoubleSwipeRight];
}


-(void)holeDoubleSwipeLeft
{
	[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithInt:[[[MGCurrentRound sharedCurrentRound]currentHole]intValue]+1]forKey:@"currentHole"];

	if([self.navigationController.visibleViewController isKindOfClass:[MGTeeShotViewController class]])
	{
		[self setCurrentHoleValues];
	}
	else
	{
		[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithInt:[[[MGCurrentRound sharedCurrentRound]currentHole]intValue]+1] forKey:@"currentHole"];

		MGTeeShotViewController *viewController = [[MGTeeShotViewController alloc] init];
		[self.navigationController pushViewController:viewController animated:YES];
	}
}
-(void)holeDoubleSwipeRight
{
	[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithInt:[[[MGCurrentRound sharedCurrentRound]currentHole]intValue]-1] forKey:@"currentHole"];
	[self setCurrentHoleValues];

	if([self.navigationController.visibleViewController isKindOfClass:[MGTeeShotViewController class]])
		{
			[self setCurrentHoleValues];
		}

	else
		{
			[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithInt:[[[MGCurrentRound sharedCurrentRound]currentHole]intValue]-1]	forKey:@"currentHole"];

			MGTeeShotViewController *viewController = [[MGTeeShotViewController alloc] init];
		[self.navigationController pushViewController:viewController animated:YES];
		}
}

@end
