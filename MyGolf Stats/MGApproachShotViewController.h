//
//  MGApproachShotViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHole.h"

@interface MGApproachShotViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIStepper *holeNumberStepper;
@property (strong, nonatomic) IBOutlet UILabel *holeNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *clubUsedButton;

@property (strong, nonatomic) IBOutlet UISwitch *greenLeft;
@property (strong, nonatomic) IBOutlet UISwitch *greenShort;
@property (strong, nonatomic) IBOutlet UISwitch *greenRight;
@property (strong, nonatomic) IBOutlet UISwitch *greenLong;
@property (strong, nonatomic) IBOutlet UISwitch *greenHit;

@property (strong,nonatomic) MGHole * activeHoleObject;

@end
