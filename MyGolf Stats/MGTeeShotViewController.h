//
//  MGTeeShotViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHole.h"

@interface MGTeeShotViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *holePar;

@property (strong, nonatomic) IBOutlet UIStepper *holeNumberStepper;
@property (strong, nonatomic) IBOutlet UILabel *holeNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *clubUsedButton;

@property (strong, nonatomic) IBOutlet UISwitch *fairwayLeft;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayShort;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayRight;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayLong;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayHit;

@property (strong,nonatomic) MGHole * activeHoleObject;

@end
