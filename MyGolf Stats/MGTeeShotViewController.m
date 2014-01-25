//
//  MGTeeShotViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGTeeShotViewController.h"
#import "MGCurrentRound.h"
#import "MGApproachShotViewController.h"
#import "MGGreenViewController.h"


@interface MGTeeShotViewController ()

@end

@implementation MGTeeShotViewController

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

	[self.navigationController setNavigationBarHidden:YES];

	[_holePar addTarget:self
						 action:@selector(parChanged:)
			   forControlEvents:UIControlEventValueChanged];
	[_holeNumberStepper addTarget:self action:@selector(holeStepperChanged:) forControlEvents:UIControlEventValueChanged];

	_holeNumberStepper.minimumValue = 1;
	_holeNumberStepper.maximumValue=18;

	[self doubleSwipeHoleSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	int currentHoleNumber=[[[MGCurrentRound sharedCurrentRound]currentHole]intValue] ;
	_activeHoleObject = [[[MGCurrentRound sharedCurrentRound]holes] objectAtIndex:currentHoleNumber-1];
	[self setCurrentHoleValues];

	if([_activeHoleObject.par integerValue] ==3) [self disableSwitches];
	else [self enableSwitches];

	self.holeNumberLabel.text=[NSString stringWithFormat:@"%i",currentHoleNumber];
	self.holeNumberStepper.value=currentHoleNumber;

	[self singleSwipeViewSetup];
	[self doubleSwipeHoleSetup];
}

-(void) setCurrentHoleValues
{
	int currentHoleNumber=[[[MGCurrentRound sharedCurrentRound]currentHole]intValue] ;
	_activeHoleObject = [[[MGCurrentRound sharedCurrentRound]holes] objectAtIndex:currentHoleNumber-1];
	self.holePar.selectedSegmentIndex=[_activeHoleObject.par integerValue]-2;
	self.holeNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[_activeHoleObject.holeNumber integerValue]];
	if ([_activeHoleObject.fairway  isEqual: @"long"]) [self.fairwayLong setOn:YES];
	if ([_activeHoleObject.fairway  isEqual: @"short"]) [self.fairwayShort setOn:YES];
	if ([_activeHoleObject.fairway  isEqual: @"left"]) [self.fairwayLeft setOn:YES];
	if ([_activeHoleObject.fairway  isEqual: @"right"]) [self.fairwayRight setOn:YES];
	if ([_activeHoleObject.fairway  isEqual: @"hit"]) [self.fairwayHit setOn:YES];
	else
	{
		[self.fairwayHit setOn:NO];
		[self.fairwayLeft setOn:NO];
		[self.fairwayLong setOn:NO];
		[self.fairwayRight setOn:NO];
		[self.fairwayShort setOn:NO];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parChanged:(id)sender
{
	_activeHoleObject.par= [NSNumber numberWithInt:[[_holePar titleForSegmentAtIndex:_holePar.selectedSegmentIndex]integerValue]];
	if([_activeHoleObject.par integerValue] ==3) [self disableSwitches];
	else [self enableSwitches];
}

-(void)holeStepperChanged:(UIStepper*)holeStepper
{
	double value = _holeNumberStepper.value;

	[self.holeNumberLabel setText:[NSString stringWithFormat:@"%f", value]];
	[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithDouble:value] forKey:@"currentHole"];
	[self setCurrentHoleValues];
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
	_activeHoleObject.fairway = @"long";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:YES];
	[self.fairwayShort setOn:NO];
}

- (IBAction)fairwayLeftTouched:(id)sender
{
	_activeHoleObject.fairway = @"left";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:YES];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:NO];
}

- (IBAction)fairwayShortTouched:(id)sender
{
	_activeHoleObject.fairway = @"short";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:YES];
}
- (IBAction)fairwayRightTouched:(id)sender
{
	_activeHoleObject.fairway = @"right";
	[self.fairwayHit setOn:NO];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:YES];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:NO];
}
- (IBAction)fairwayHitTouched:(id)sender
{
	_activeHoleObject.fairway = @"hit";
	[self.fairwayHit setOn:YES];
	[self.fairwayLeft setOn:NO];
	[self.fairwayRight setOn:NO];
	[self.fairwayLong setOn:NO];
	[self.fairwayShort setOn:NO];
}

-(void)teeToApproach
{
[self performSegueWithIdentifier:@"teeToApproachSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender

{
	if ([[segue identifier] isEqualToString:@"teeToApproachSegue"])
	{
		MGApproachShotViewController* vc = (MGApproachShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;

	}
}

- (IBAction)teeSwipeRight:(id)sender
{
[self performSegueWithIdentifier:@"teeToApproachSegue" sender:self];
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
	if([self.navigationController.visibleViewController isKindOfClass:[MGTeeShotViewController class]])
		{
			return;
		}
	else if([self.navigationController.visibleViewController isKindOfClass:[MGApproachShotViewController class]])
		{
			[self performSegueWithIdentifier:@"approachToTeeSegue"sender:self];
		}
	else if([self.navigationController.visibleViewController isKindOfClass:[MGGreenViewController class]])
		{
			[self performSegueWithIdentifier:@"greenToApproachSegue" sender:self];
		}
	else return;
}

-(void) nextViewFromSwipe
{
	if([self.navigationController.visibleViewController isKindOfClass:[MGTeeShotViewController class]])
	{
		[self performSegueWithIdentifier:@"teeToApproachSegue"sender:self];
	}
	else if([self.navigationController.visibleViewController isKindOfClass:[MGApproachShotViewController class]])
	{
		[self performSegueWithIdentifier:@"approachToGreenSegue"sender:self];
	}
	else if([self.navigationController.visibleViewController isKindOfClass:[MGGreenViewController class]])
	{
		return;
	}
	else return;
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

	int hole=[[[MGCurrentRound sharedCurrentRound]currentHole]intValue];
	int nexthole=[[[MGCurrentRound sharedCurrentRound]currentHole]intValue]+1;

	[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithInt:[[[MGCurrentRound sharedCurrentRound]currentHole]intValue]+1]forKey:@"currentHole"];
	int test = [[[MGCurrentRound sharedCurrentRound]currentHole]intValue];

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
