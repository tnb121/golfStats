//
//  MGGreenViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGGreenViewController.h"
#import "MGCurrentRound.h"
#import "MGApproachShotViewController.h"
#import "MGTeeShotViewController.h"
#import "ParseData.h"

@interface MGGreenViewController ()

@property (strong,nonatomic) MGRoundStats * stats;
@property (strong,nonatomic) MGCurrentRound * currentRound;

@property (strong,nonatomic) UILabel *activePuttLabel;
@property (strong,nonatomic) UILabel *activePenaltyLabel;
@property (strong,nonatomic) UILabel *activeScoreLabel;

@property (strong,nonatomic) ParseData * parseData;


@end

@implementation MGGreenViewController

NSInteger scoreCardViewYOffsetData = 0;
NSInteger sandSaveUpDownYOffsetData = 0;
NSInteger holeLabelsAndButtonsYOffsetDataShort = 0;


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
-(ParseData*)parseData
{
	return [ParseData sharedParseData];
}

-(UILabel*) activePuttLabel
{
    //Select Active Labels
    switch ([self.currentRound.currentHole integerValue])
    {
        case 1:
            return self.activePuttLabel = self.puttsHole1Label;
            break;
            
        case 2:
           return  self.activePuttLabel = self.puttsHole2Label;
            break;
            
        default:
            return self.activePuttLabel = self.puttsHole3Label;
            break;
    }
}

-(UILabel*) activePenaltyLabel
{
    //Select Active Labels
    switch ([self.currentRound.currentHole integerValue])
    {
        case 1:
            return self.activePenaltyLabel = self.penaltiesHole1Label;
            break;
            
        case 2:
            return  self.activePenaltyLabel = self.penaltiesHole2Label;
            break;
            
        default:
            return self.activePenaltyLabel  = self.penaltiesHole3Label;
            break;
    }
}

-(UILabel*) activeScoreLabel
{
    //Select Active Labels
    switch ([self.currentRound.currentHole integerValue])
    {
        case 1:
            return self.activeScoreLabel = self.scoreHole1Label;
            break;
            
        case 2:
            return  self.activeScoreLabel = self.scoreHole2Label;
            break;
            
        default:
            return self.activeScoreLabel  = self.scoreHole3Label;
            break;
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	//[self.navigationController setNavigationBarHidden:YES];
    
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        self.backgroundImageView.image= [UIImage imageNamed:@"Short Game Image (data collection)(3.5).png"];
    }
    
    else
    {
        self.backgroundImageView.image = [UIImage imageNamed:@"Short Game (data collection) scorecard.png"];
    }
    
    self.saveHoleButton.layer.cornerRadius = 5;
    self.saveHoleButton.layer.borderWidth = 1;
    self.saveHoleButton.layer.borderColor=[UIColor whiteColor].CGColor;
    
    self.puttsStepper.transform = CGAffineTransformMakeScale(.75, .80);
    self.penaltyStrokesStepper.transform = CGAffineTransformMakeScale(.75, .80);
    self.scoreStepper.transform = CGAffineTransformMakeScale(.75, .80);
    
    [self colorSteppers];
    
	//[_holeNumberStepper addTarget:self action:@selector(holeStepperChanged:) forControlEvents:UIControlEventValueChanged];
    

	[self singleSwipeViewSetup];
	[self doubleSwipeHoleSetup];
    
    [self setOtherHoleValues];
    [self highlightActiveLabels];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self setCurrentHoleValues];
}
-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self scoreSetup];
	//[self setStats];
	self.puttsStepper.value = [_activeHoleObject.putts intValue];
	self.penaltyStrokesStepper.value = [_activeHoleObject.penaltyStrokes intValue];
}

-(void)viewWillLayoutSubviews
{
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        scoreCardViewYOffsetData = -80 ;
        sandSaveUpDownYOffsetData = -80;
        holeLabelsAndButtonsYOffsetDataShort = -80;
        
        self.scoreCardView.frame            = CGRectMake(0, 160 + scoreCardViewYOffsetData, 320, 158);
        self.sandSaveUpDownView.frame = CGRectMake(0, 89  + sandSaveUpDownYOffsetData, 320, 69);
        self.saveAndHoleSelectionView.frame = CGRectMake(0, 320 + holeLabelsAndButtonsYOffsetDataShort, 320, 81);
    }
}

-(void)colorSteppers
{
    UIColor *lightBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1];
    
    for (UIView *view in self.scoreStepper.subviews)
    {
        
        if([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            button.backgroundColor = lightBlue;
        }
    }
    
    for (UIView *view in self.puttsStepper.subviews)
    {
        
        if([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            button.backgroundColor = lightBlue;
        }
    }
    
    for (UIView *view in self.penaltyStrokesStepper.subviews)
    {
        if([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            button.backgroundColor = lightBlue;
        }
    }
}

-(void) setCurrentHoleValues
{
    
    [self enableOrDisableHoleButtons];

	//Set values of UI Elements
	NSInteger currentHoleNumber=[self.currentRound.currentHole integerValue];
	_activeHoleObject = [self.currentRound.holes objectAtIndex:currentHoleNumber-1];
	self.holeNumberLabel.text = [@"Hole " stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)currentHoleNumber]];

	self.puttsStepper.value = [self.activeHoleObject.putts intValue];
	self.activePuttLabel.text = [self zeroToDash:[NSString stringWithFormat:@"%d",[self.activeHoleObject.putts intValue]]];
	self.penaltyStrokesStepper.value = [self.activeHoleObject.penaltyStrokes intValue];
	self.activePenaltyLabel.text = [self zeroToDash:[NSString stringWithFormat:@"%d",[self.activeHoleObject.penaltyStrokes intValue]]];

	if ([self.activeHoleObject.upAndDown isEqualToString:@"made"])
		self.upAndDown.selectedSegmentIndex=0;
	else if ([self.activeHoleObject.upAndDown isEqualToString:@"missed"])
		self.upAndDown.selectedSegmentIndex=1;

	if ([self.activeHoleObject.sandSave isEqualToString:@"made"])
		self.sandSave.selectedSegmentIndex=0;
	else if ([self.activeHoleObject.sandSave isEqualToString:@"missed"])
		self.sandSave.selectedSegmentIndex=1;

	[self scoreSetup];
}

-(void)setOtherHoleValues
{
    NSInteger holeOffset = 0;
    
    switch ([self.currentRound.currentHole integerValue])
    {
        case 1:
            holeOffset = 2;
            break;
            
        case 2:
            holeOffset = 1;
            break;
                                    
        default:
            holeOffset = 0;
            break;
    }
    
        //Set Hole Numbers
            self.hole1Label.text = [NSString stringWithFormat:@"%ld",(long)[self.currentRound.currentHole integerValue]-2 + holeOffset ];
            self.hole2Label.text = [NSString stringWithFormat:@"%ld",(long)[self.currentRound.currentHole integerValue]-1 + holeOffset];
            self.hole3Label.text = [NSString stringWithFormat:@"%ld",(long)[self.currentRound.currentHole integerValue] + holeOffset];
           
        // Set Par Values
            NSInteger par1 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-3 + holeOffset)] valueForKey:@"par"] integerValue];
            NSInteger par2 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-2 + holeOffset)] valueForKey:@"par"] integerValue];
            NSInteger par3 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-1 + holeOffset)] valueForKey:@"par"] integerValue];
            
            self.parHole1Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)par1]];
            self.parHole2Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)par2]];
            self.parHole3Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)par3]];
            
        // Set Putt Values
            NSInteger putts1 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-3 + holeOffset)] valueForKey:@"putts"] integerValue];
            NSInteger putts2 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-2 + holeOffset)] valueForKey:@"putts"] integerValue];
            NSInteger putts3 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-1 + holeOffset)] valueForKey:@"putts"] integerValue];
            
            self.puttsHole1Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)putts1]];
            self.puttsHole2Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)putts2]];
            self.puttsHole3Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)putts3]];
            
        // Set Penalty Values
            NSInteger penalties1 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-3 + holeOffset)] valueForKey:@"penaltyStrokes"] integerValue];
            NSInteger penalties2 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-2 + holeOffset)] valueForKey:@"penaltyStrokes"] integerValue];
            NSInteger penalties3 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-1 + holeOffset)] valueForKey:@"penaltyStrokes"] integerValue];
            
            self.penaltiesHole1Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)penalties1]];
            self.penaltiesHole2Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)penalties2]];
            self.penaltiesHole3Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)penalties3]];
            
        // Set Penalty Values
            NSInteger score1 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-3 + holeOffset)] valueForKey:@"score"] integerValue];
            NSInteger score2 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-2 + holeOffset)] valueForKey:@"score"] integerValue];
            NSInteger score3 = [[[self.currentRound.holes objectAtIndex:([self.currentRound.currentHole integerValue]-1 + holeOffset)] valueForKey:@"score"] integerValue];
            
            self.scoreHole1Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)score1]];
            self.scoreHole2Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)score2]];
            self.scoreHole3Label.text = [self zeroToDash:[NSString stringWithFormat:@"%ld",(long)score3]];
}

-(NSString*) zeroToDash:(NSString*)input
{
    if ([input  isEqual: @"0"])
    return @"-";
    else return input;
}

-(void)highlightActiveLabels
{
    UIColor *lightBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1];
    
    switch ([self.currentRound.currentHole integerValue])
    {
        case 1:
            self.parHole1Label.backgroundColor = lightBlue ;
            self.parHole1Label.textColor = [UIColor whiteColor];
            
            self.puttsHole1Label.backgroundColor = lightBlue ;
            self.puttsHole1Label.textColor = [UIColor whiteColor];
            
            self.penaltiesHole1Label.backgroundColor = lightBlue ;
            self.penaltiesHole1Label.textColor = [UIColor whiteColor];
            
            self.scoreHole1Label.backgroundColor = lightBlue ;
            self.scoreHole1Label.textColor = [UIColor whiteColor];
            break;
            
        case 2:
            self.parHole2Label.backgroundColor = lightBlue ;
            self.parHole2Label.textColor = [UIColor whiteColor];
            
            self.puttsHole2Label.backgroundColor = lightBlue ;
            self.puttsHole2Label.textColor = [UIColor whiteColor];
            
            self.penaltiesHole2Label.backgroundColor = lightBlue ;
            self.penaltiesHole2Label.textColor = [UIColor whiteColor];
            
            self.scoreHole2Label.backgroundColor = lightBlue ;
            self.scoreHole2Label.textColor = [UIColor whiteColor];
            break;
            
        default:
            self.parHole3Label.backgroundColor = lightBlue ;
            self.parHole3Label.textColor = [UIColor whiteColor];
            
            self.puttsHole3Label.backgroundColor = lightBlue ;
            self.puttsHole3Label.textColor = [UIColor whiteColor];
            
            self.penaltiesHole3Label.backgroundColor = lightBlue ;
            self.penaltiesHole3Label.textColor = [UIColor whiteColor];
            
            self.scoreHole3Label.backgroundColor = lightBlue ;
            self.scoreHole3Label.textColor = [UIColor whiteColor];
            break;
    }

    
}

- (IBAction)previousHoleButtonPressed:(id)sender
{
    NSInteger currentHoleNumber=[self.currentRound.currentHole integerValue];
    self.currentRound.currentHole= [NSNumber numberWithInteger:(currentHoleNumber - 1)];
    _activeHoleObject = [self.currentRound.holes objectAtIndex:currentHoleNumber-1];
    [self performSegueWithIdentifier:@"greenToTeeSegueNonSave"sender:self];
}

- (IBAction)nextHoleButtonPressed:(id)sender
{
    NSInteger currentHoleNumber=[self.currentRound.currentHole integerValue];
    self.currentRound.currentHole= [NSNumber numberWithInteger:(currentHoleNumber + 1)];
    _activeHoleObject = [self.currentRound.holes objectAtIndex:currentHoleNumber-1];
    [self performSegueWithIdentifier:@"greenToTeeSegueNonSave"sender:self];
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

- (IBAction)holeStepperChanged:(id)sender
{
	double value = _holeNumberStepper.value;

	[self.holeNumberLabel setText:[NSString stringWithFormat:@"%f", value]];
	[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithDouble:value] forKey:@"currentHole"];
	self.activeHoleObject=[[[MGCurrentRound sharedCurrentRound]holes]objectAtIndex:self.holeNumberStepper.value-1];
}
- (IBAction)puttsStepperChanged:(id)sender
{
	double value = _puttsStepper.value;
	double lastValue = [self.activePuttLabel.text doubleValue];
	double change = value - lastValue;

	self.scoreStepper.value = self.scoreStepper.value + change;
	self.activeScoreLabel.text = [NSString stringWithFormat:@"%.0f",self.scoreStepper.value];
	self.activeHoleObject.score = [NSNumber numberWithDouble:self.scoreStepper.value];

	[self.activePuttLabel setText:[NSString stringWithFormat:@"%.0f", value]];
	self.activeHoleObject.putts = [NSNumber numberWithDouble:value];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];

}

- (IBAction)penaltyStrokesStepperChanged:(id)sender
{
	double value = _penaltyStrokesStepper.value;
	double lastValue = [self.activePenaltyLabel.text doubleValue];
	double change = value - lastValue;

	self.scoreStepper.value = self.scoreStepper.value + change;
	self.activeScoreLabel.text = [NSString stringWithFormat:@"%.0f",self.scoreStepper.value];
	self.activeHoleObject.score = [NSNumber numberWithDouble:self.scoreStepper.value];

	[self.activePenaltyLabel setText:[NSString stringWithFormat:@"%.0f", value]];
	self.activeHoleObject.penaltyStrokes = [NSNumber numberWithDouble:value];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
}

- (IBAction)scoreStepperChanged:(id)sender
{
	double value = _scoreStepper.value;

	[self.activeScoreLabel setText:[NSString stringWithFormat:@"%.0f", value]];
	_activeHoleObject.score = [NSNumber numberWithDouble:value];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
}

-(void)scoreSetup
{
	if ([self.shotTracking isEqualToString:@"shot"])
	{
		self.scoreStepper.value = self.activeHoleObject.shots.count;
	}
	
    else if (self.activeHoleObject.score !=0)
    {
        self.scoreStepper.value = [self.activeHoleObject.score integerValue];
    }
    
    else
    {
        self.scoreStepper.value = [self.activeHoleObject.par integerValue]-2;
        self.activeHoleObject.score = [NSNumber numberWithInteger:[self.activeHoleObject.par intValue]-2];
    }
    
    [self.activeScoreLabel setText:[NSString stringWithFormat:@"%.0f", self.scoreStepper.value]];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
}

- (IBAction)upAndDownChanged:(id)sender
{
	if (![self.activeHoleObject.upAndDown isEqualToString:@"made"]&&![self.activeHoleObject.upAndDown isEqualToString:@"missed"])
		{
			//self.scoreStepper.value = self.scoreStepper.value +1;
			//self.scoreLabel.text = [NSString stringWithFormat:@"%.f",self.scoreStepper.value];
		}

	switch (self.upAndDown.selectedSegmentIndex)
	{
		case 0:
			self.activeHoleObject.upAndDown=@"made";
			break;
		case 1:
			self.activeHoleObject.upAndDown=@"missed";
			break;
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
}

- (IBAction)sandSaveChanged:(id)sender
{
	if (![self.activeHoleObject.sandSave isEqualToString:@"made"]&&![self.activeHoleObject.sandSave isEqualToString:@"missed"])
	{
		//self.scoreStepper.value = self.scoreStepper.value +1;
		//self.scoreLabel.text = [NSString stringWithFormat:@"%.f",self.scoreStepper.value];
	}

	switch (self.sandSave.selectedSegmentIndex)
	{
		case 0:
			self.activeHoleObject.sandSave=@"made";
			break;
		case 1:
			self.activeHoleObject.sandSave=@"missed";
			break;
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChanged" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender

{
	if ([[segue identifier] isEqualToString:@"greenToApproachSegue"])
	{
		MGApproachShotViewController* vc = (MGApproachShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
	}
	else if ([[segue identifier] isEqualToString:@"greenToTeeSegue"])
	{
		MGTeeShotViewController* vc = (MGTeeShotViewController*)segue.destinationViewController;
		MGRound * currentRound = [MGCurrentRound sharedCurrentRound];
		currentRound.currentHole=[NSNumber numberWithInteger:[currentRound.currentHole intValue]+1];
		MGHole * currentHole = [currentRound.holes objectAtIndex:[currentRound.currentHole intValue] - 1];
		vc.activeHoleObject = currentHole;
	}
    else if ([[segue identifier] isEqualToString:@"greenToTeeSegueNonSave"])
	{
		MGTeeShotViewController* vc = (MGTeeShotViewController*)segue.destinationViewController;
		self.currentRound.currentHole=[NSNumber numberWithInteger:[self.currentRound.currentHole intValue]];
		MGHole * currentHole = [self.currentRound.holes objectAtIndex:[self.currentRound.currentHole intValue] - 1];
		vc.activeHoleObject = currentHole;
	}
}
- (IBAction)saveRound:(id)sender
{
	if([self.currentRound.currentHole integerValue]<[self.currentRound.length integerValue])
	{
		[self performSegueWithIdentifier:@"greenToTeeSegue"sender:self];
	}
	else
	{
		[[MGCurrentRound sharedCurrentRound]saveRound];
		//[self performSegueWithIdentifier:@"greenToHomeSegue"sender:self];
        [self saveRoundManualSegue];
	}
}
-(void)saveRoundManualSegue
{
    PFQuery *roundQuery = [PFQuery queryWithClassName:@"Rounds"];
    [roundQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
    [roundQuery includeKey:@"roundHoles"];
    [roundQuery findObjectsInBackgroundWithBlock:^(NSArray*roundObjects,NSError *error){
        if(!error)
        {
            self.parseData.roundsFromParse = [roundObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDate" ascending:NO]]];
        }
    }];
    
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
	[self performSegueWithIdentifier:@"greenToApproachSegue" sender:self];
}

-(void) nextViewFromSwipe
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


	if([self.navigationController.visibleViewController isKindOfClass:[MGTeeShotViewController class]])
	{
		[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithInt:[[[MGCurrentRound sharedCurrentRound]currentHole]intValue]-1] forKey:@"currentHole"];
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
