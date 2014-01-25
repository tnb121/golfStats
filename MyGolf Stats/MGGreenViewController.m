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

@interface MGGreenViewController ()

@end

@implementation MGGreenViewController

@synthesize upAndDown=_upAndDown;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	int currentHoleNumber=[[[MGCurrentRound sharedCurrentRound]currentHole]intValue] ;
	_activeHoleObject = [[[MGCurrentRound sharedCurrentRound]holes] objectAtIndex:currentHoleNumber];
	[self scoreChanged];

	_puttsLabel.text = [NSString stringWithFormat:@"%@",_activeHoleObject.putts];
	_penaltyStrokesLabel.text = [NSString stringWithFormat:@"%@",_activeHoleObject.penaltyStrokes];
	if([_activeHoleObject.upAndDown isEqualToString:@"no"])
			_upAndDown.selectedSegmentIndex = 0;
	if([_activeHoleObject.upAndDown isEqualToString:@"yes"])
			_upAndDown.selectedSegmentIndex = 1;
	_holeNumberLabel.text = [NSString stringWithFormat:@"%@",_activeHoleObject.holeNumber];
}

-(void)holeStepperChanged:(UIStepper*)holeStepper
{
	double value = _holeNumberStepper.value;

	[self.holeNumberLabel setText:[NSString stringWithFormat:@"%f", value]];
	[[MGCurrentRound sharedCurrentRound] setValue:[NSNumber numberWithDouble:value] forKey:@"currentHole"];
	_activeHoleObject=[[[MGCurrentRound sharedCurrentRound]holes]objectAtIndex:holeStepper.value-1];
}
-(void)puttsStepperChanged:(UIStepper*)puttsStepper
{
	double value = _puttsStepper.value;

	[self.puttsLabel setText:[NSString stringWithFormat:@"%f", value]];
	_activeHoleObject.putts = [NSNumber numberWithDouble:value];
	[self scoreChanged];
}

-(void)penaltyStrokesStepperChanged:(UIStepper*)penaltyStrokesStepper
{
	double value = _penaltyStrokesStepper.value;

	[self.penaltyStrokesLabel setText:[NSString stringWithFormat:@"%f", value]];
	_activeHoleObject.penaltyStrokes = [NSNumber numberWithDouble:value];
	[self scoreChanged];
}

-(void)scoreChanged
{
	if([_activeHoleObject.par intValue]==3)_activeHoleObject.score = [NSNumber numberWithInt:1];
	else _activeHoleObject.score = [NSNumber numberWithInt:2];

	_activeHoleObject.score	= [NSNumber numberWithDouble:[_activeHoleObject.score doubleValue] + _puttsStepper.value + _penaltyStrokesStepper.value + _scoreStepper.value];

	if(_upAndDown.selectedSegmentIndex)
		_activeHoleObject.score=[NSNumber numberWithInt:[_activeHoleObject.score intValue]+1];

	if(_sandSave.selectedSegmentIndex)
		_activeHoleObject.score=[NSNumber numberWithInt:[_activeHoleObject.score intValue]+1];
	_scoreLabel.text = [NSString stringWithFormat:@"%@",_activeHoleObject.score];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender

{
	if ([[segue identifier] isEqualToString:@"greenToApproachSegue"])
	{
		MGApproachShotViewController* vc = (MGApproachShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
	}
}
- (IBAction)saveRound:(id)sender
{
	PFQuery *query = [PFQuery queryWithClassName:@"Rounds"];
	[query getObjectInBackgroundWithId:[[MGCurrentRound sharedCurrentRound]roundID] block:^(PFObject * parseRound, NSError * error)
	 {
		 if(!error)
		 {
			 int hole = [_activeHoleObject.holeNumber intValue];

			 MGHole * holeInArray =   [[[MGCurrentRound sharedCurrentRound]holes]objectAtIndex:hole-1];
			 holeInArray.roundID=[[MGCurrentRound sharedCurrentRound]roundID];
			 holeInArray.holeNumber = _activeHoleObject.holeNumber;
			 holeInArray.par= _activeHoleObject.par;
			 holeInArray.holeHandicap = _activeHoleObject.holeHandicap;
			 holeInArray.fairway = _activeHoleObject.fairway;
			 holeInArray.green = _activeHoleObject.green;
			 holeInArray.chips = _activeHoleObject.chips;
			 holeInArray.putts = _activeHoleObject.putts;
			 holeInArray.penaltyStrokes = _activeHoleObject.penaltyStrokes;
			 holeInArray.score = _activeHoleObject.score;
			 holeInArray.upAndDown = _activeHoleObject.upAndDown;
			 holeInArray.sandSave= _activeHoleObject.sandSave;

			 parseRound[@"holes"] = [[MGCurrentRound sharedCurrentRound]holes];

			 [parseRound saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
			  {
				  if(!error)
				  {
					  NSLog(@"saved Round Data");
				  }
				  else NSLog(@"failed");
			  }];
		 }
	 }];
}

@end
