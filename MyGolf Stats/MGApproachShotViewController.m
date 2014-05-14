//
//  MGApproachShotViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGApproachShotViewController.h"
#import "MGAppDelegate.h"
#import "MGCurrentRound.h"
#import "MGGreenViewController.h"
#import "MGTeeShotViewController.h"
#import "Clubs.h"

@interface MGApproachShotViewController ()

@property (strong,nonatomic) NSString * locationTouched;

@property (strong,nonatomic) NSArray * clubArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) MGCurrentRound * currentRound;

@property (strong,nonatomic) UIPickerView * clubPicker;

@end

NSInteger clubArrayIndex;

@implementation MGApproachShotViewController

@synthesize activeShot=_activeShot;

NSInteger greenHitLabelYOffsetData = 0;
NSInteger greenLeftLabelYOffsetData = 0;
NSInteger greenRightLabelYOffsetData = 0;
NSInteger greenLongLabelYOffsetData = 0;
NSInteger greenShortLabelYOffsetData = 0;
NSInteger holeLabelsAndButtonsYOffsetDataApproach = 0;
float  switchHeightScaleApproach = 1.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];

	//[self.navigationController setNavigationBarHidden:YES];

	//[_holeNumberStepperApproach addTarget:self action:@selector(holeStepperChanged:) forControlEvents:UIControlEventValueChanged];
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        self.greenImageView.image= [UIImage imageNamed:@"Green Image (data collection)(3.5).png"];
    }
    
    else
    {
        self.greenImageView.image = [UIImage imageNamed:@"Green Image (data collection).png"];
    }

	//_holeNumberStepperApproach.minimumValue = 1;
	//_holeNumberStepperApproach.maximumValue=18;

	[self singleSwipeViewSetup];
	[self doubleSwipeHoleSetup];

	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;
	
	self.managedObjectContext = [(MGAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];

	self.activeShot = [MGShot object];
	self.activeShot.parseID=[PFUser currentUser].username;
	self.activeShot.roundID=[[MGCurrentRound sharedCurrentRound]roundID];
	self.activeShot.holeNumber=[[MGCurrentRound sharedCurrentRound]currentHole];
	self.activeShot.target=@"green";
	self.activeShot.startingLocation=self.startingLocation;

}

-(void)viewWillLayoutSubviews
{
    if ([UIScreen mainScreen].bounds.size.height<568)
    {

        greenHitLabelYOffsetData   = -40;
        greenLeftLabelYOffsetData  = -40;
        greenRightLabelYOffsetData = -40;
        greenLongLabelYOffsetData  = -13;
        greenShortLabelYOffsetData = -67;
        switchHeightScaleApproach  = 0.85;
        
        holeLabelsAndButtonsYOffsetDataApproach = -85;
        
        
        self.greenLong.frame  = CGRectMake(138, 46 + greenLongLabelYOffsetData, 51, 31);
        self.greenLeft.frame  = CGRectMake(18 ,171 + greenLeftLabelYOffsetData, 51, 31);
        self.greenHit.frame   = CGRectMake(138,171 + greenHitLabelYOffsetData, 51, 31);
        self.greenRight.frame = CGRectMake(253,171 + greenRightLabelYOffsetData, 51, 31);
        self.greenShort.frame = CGRectMake(138,303 + greenShortLabelYOffsetData, 51, 31);
        
        self.previousHoleButton.frame = CGRectMake(46, 362 + holeLabelsAndButtonsYOffsetDataApproach, 60, 35);
        self.holeNumberLabel.frame    = CGRectMake(114, 366 + holeLabelsAndButtonsYOffsetDataApproach, 97, 28);
        self.nextHoleButton.frame     = CGRectMake(218, 362 + holeLabelsAndButtonsYOffsetDataApproach, 60, 35);
        
        
        self.greenLong.transform  = CGAffineTransformMakeScale(switchHeightScaleApproach, switchHeightScaleApproach);
        self.greenLeft.transform  = CGAffineTransformMakeScale(switchHeightScaleApproach, switchHeightScaleApproach);
        self.greenHit.transform  = CGAffineTransformMakeScale(switchHeightScaleApproach, switchHeightScaleApproach);
        self.greenRight.transform  = CGAffineTransformMakeScale(switchHeightScaleApproach, switchHeightScaleApproach);
        self.greenShort.transform  = CGAffineTransformMakeScale(switchHeightScaleApproach, switchHeightScaleApproach);
        
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setCurrentHoleValues];
	[self setClubButton];
}
-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [self setCurrentHoleValues];

}

-(void) setCurrentHoleValues
{
	NSInteger currentHoleNumber=[self.currentRound.currentHole integerValue];
	_activeHoleObject = [self.currentRound.holes objectAtIndex:currentHoleNumber-1];
	self.holeNumberStepperApproach.value =currentHoleNumber;
	self.holeNumberLabel.text = [@"Hole " stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)currentHoleNumber]];
    
    [self enableOrDisableHoleButtons];

	if ([self.shotTracking isEqualToString:@"shot"])
	{
		[self.greenHit setOn:NO];
		[self.greenLeft setOn:NO];
		[self.greenLong setOn:NO];
		[self.greenRight setOn:NO];
		[self.greenShort setOn:NO];
	}

	else if ([_activeHoleObject.green isEqual: @"greenLong"])
    {
        [self.greenLong setOn:YES];
        self.locationTouched = @"greenLong";
    }
	else if ([_activeHoleObject.green  isEqual: @"greenShort"])
    {
        [self.greenShort setOn:YES];
        self.locationTouched = @"greenShort";
    }
	else if ([_activeHoleObject.green isEqual: @"greenLeft"])
    {
        [self.greenLeft setOn:YES];
        self.locationTouched = @"greenLeft";
    }
	else if ([_activeHoleObject.green  isEqual: @"greenRight"])
    {
        [self.greenRight setOn:YES];
        self.locationTouched = @"greenRight";
    }
	else if ([_activeHoleObject.green  isEqual: @"greenHit"])
    {
        [self.greenHit setOn:YES];
        self.locationTouched = @"greenHit";
    }

	else
	{
		[self.greenHit setOn:NO];
		[self.greenLeft setOn:NO];
		[self.greenLong setOn:NO];
		[self.greenRight setOn:NO];
		[self.greenShort setOn:NO];
        self.locationTouched = nil;
	}
}

- (IBAction)previousHoleButtonPressed:(id)sender
{
    NSInteger currentHoleNumber=[self.currentRound.currentHole integerValue];
    self.currentRound.currentHole= [NSNumber numberWithInteger:(currentHoleNumber - 1)];
    _activeHoleObject = [self.currentRound.holes objectAtIndex:currentHoleNumber-1];
    [self performSegueWithIdentifier:@"approachToTeeSegue"sender:self];
}

- (IBAction)nextHoleButtonPressed:(id)sender
{
    NSInteger currentHoleNumber=[self.currentRound.currentHole integerValue];
    self.currentRound.currentHole= [NSNumber numberWithInteger:(currentHoleNumber + 1)];
    _activeHoleObject = [self.currentRound.holes objectAtIndex:currentHoleNumber-1];
    [self performSegueWithIdentifier:@"approachToTeeSegue"sender:self];
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


/*
-(void)holeStepperChanged:(UIStepper*)holeStepper
{
	double value = _holeNumberStepperApproach.value;

	[self.holeNumberLabelApproach setText:[NSString stringWithFormat:@"%f", value]];
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
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)greenLongTouched:(id)sender
{
	self.locationTouched = @"greenLong";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:YES];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:NO];
	[self setGreenValue];
    [self presentSwipeToNextViewImage];
}

- (IBAction)greenLeftTouched:(id)sender
{
	self.locationTouched = @"greenLeft";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:YES];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:NO];
	[self setGreenValue];
    [self presentSwipeToNextViewImage];
}

- (IBAction)greenShortTouched:(id)sender
{
	self.locationTouched = @"greenShort";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:YES];
	[self setGreenValue];
    [self presentSwipeToNextViewImage];
}
- (IBAction)greenRightTouched:(id)sender
{
	self.locationTouched = @"greenRight";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:YES];
	[self.greenShort setOn:NO];
	[self setGreenValue];
    [self presentSwipeToNextViewImage];
}
- (IBAction)greenHitTouched:(id)sender
{
	self.locationTouched = @"greenHit";
	[self.greenHit setOn:YES];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:NO];
	[self setGreenValue];
    [self presentSwipeToNextViewImage];
}

-(void)setGreenValue
{

	if ([self.shotTracking isEqualToString:@"shot"])
	{
		self.activeShot.endingLocation=self.locationTouched;

		switch ([self.activeHoleObject.par intValue])
		{
			case 3:
				if(self.activeHoleObject.shots.count==0)
					self.activeHoleObject.green=self.locationTouched;
					break;
			case 4:
				if(self.activeHoleObject.shots.count==1)
					self.activeHoleObject.green=self.locationTouched;
					break;
			case 5:
				if(self.activeHoleObject.shots.count<=2 && [self.locationTouched isEqualToString:@"greenHit"])
					self.activeHoleObject.green=self.locationTouched;
				else if (self.activeHoleObject.shots.count == 3 && [self.activeHoleObject.green isEqual:[NSNull null]])
					self.activeHoleObject.green=self.locationTouched;
					break;
		}
	}

	else self.activeHoleObject.green=self.locationTouched;

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
}

-(void)presentSwipeToNextViewImage
{
    if ([self.currentRound.currentHole integerValue] == 1)
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
	if ([[segue identifier] isEqualToString:@"approachToGreenSegue"])
	{
		if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shotTracking"]isEqualToString:@"shot"])
		[self.activeHoleObject.shots addObject:self.activeShot];

			MGGreenViewController* vc = (MGGreenViewController*)segue.destinationViewController;
			vc.activeHoleObject = self.activeHoleObject;
			vc.startingLocation=self.activeShot.endingLocation;
	}
	if ([[segue identifier] isEqualToString:@"approachToApproachSegue"])
	{
		if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shotTracking"]isEqualToString:@"shot"])
			[self.activeHoleObject.shots addObject:self.activeShot];

		MGApproachShotViewController* vc = (MGApproachShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
		vc.startingLocation=self.activeShot.endingLocation;
	}

	else if ([[segue identifier] isEqualToString:@"approachToTeeSegue"])
	{
		if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shotTracking"]isEqualToString:@"shot"])
			[self.activeHoleObject.shots addObject:self.activeShot];

		MGTeeShotViewController* vc = (MGTeeShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
	}

	else if ([[segue identifier] isEqualToString:@"goToGreenSegue"])
	{
		MGGreenViewController* vc = (MGGreenViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
		vc.startingLocation=self.activeShot.endingLocation;
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
	[self performSegueWithIdentifier:@"approachToTeeSegue"sender:self];
}

-(void) nextViewFromSwipe
{
	[self chooseSegue];
}


-(void)chooseSegue
{
	if ([self.shotTracking isEqualToString:@"shot"])
	{
		if ([self.activeShot.endingLocation isEqualToString:@"greenHit"])
				[self performSegueWithIdentifier:@"approachToGreenSegue" sender:self];
		else [self performSegueWithIdentifier:@"approachToApproachSegue" sender:self];
	}

	else
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

        
		[self performSegueWithIdentifier:@"approachToGreenSegue" sender:self];

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
