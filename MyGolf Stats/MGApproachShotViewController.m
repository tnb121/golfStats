//
//  MGApproachShotViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGApproachShotViewController.h"
#import "MGCurrentRound.h"
#import "MGGreenViewController.h"
#import "MGTeeShotViewController.h"

@interface MGApproachShotViewController ()

@end

@implementation MGApproachShotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	int currentHoleNumber=[[[MGCurrentRound sharedCurrentRound]currentHole]intValue] ;
	_activeHoleObject = [[[MGCurrentRound sharedCurrentRound]holes] objectAtIndex:currentHoleNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)greenLongTouched:(id)sender
{
	_activeHoleObject.green = @"long";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:YES];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:NO];

}

- (IBAction)greenLeftTouched:(id)sender
{
	_activeHoleObject.green = @"left";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:YES];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:NO];
}

- (IBAction)greenShortTouched:(id)sender
{
	_activeHoleObject.green = @"short";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:YES];
}
- (IBAction)greenRightTouched:(id)sender
{
	_activeHoleObject.green = @"right";
	[self.greenHit setOn:NO];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:YES];
	[self.greenShort setOn:NO];
}
- (IBAction)greenHitTouched:(id)sender
{
	_activeHoleObject.green = @"hit";
	[self.greenHit setOn:YES];
	[self.greenLeft setOn:NO];
	[self.greenLong setOn:NO];
	[self.greenRight setOn:NO];
	[self.greenShort setOn:NO];
}
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender

{
	if ([[segue identifier] isEqualToString:@"approachToGreenSegue"])
	{
		MGGreenViewController* vc = (MGGreenViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
	}
	if ([[segue identifier] isEqualToString:@"approachToTeeSegue"])
	{
		MGTeeShotViewController* vc = (MGTeeShotViewController*)segue.destinationViewController;
		vc.activeHoleObject = self.activeHoleObject;
	}
}


@end
