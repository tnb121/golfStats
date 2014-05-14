//
//  MGApproachShotViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHole.h"
#import "MGShot.h"
#import "MGRoundStats.h"
#import "KeyboardController.h"

@interface MGApproachShotViewController : UIViewController<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,KeyboardControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIStepper *holeNumberStepperApproach;
@property (strong, nonatomic) IBOutlet UIButton *clubUsedButton;

@property (strong, nonatomic) IBOutlet UILabel *holeNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousHoleButton;
@property (weak, nonatomic) IBOutlet UIButton *nextHoleButton;

@property (strong,nonatomic) UIImageView * swipeView;
@property (strong,nonatomic) UIView * par3AlphaView;

@property (strong, nonatomic) IBOutlet UISwitch *greenLeft;
@property (strong, nonatomic) IBOutlet UISwitch *greenShort;
@property (strong, nonatomic) IBOutlet UISwitch *greenRight;
@property (strong, nonatomic) IBOutlet UISwitch *greenLong;
@property (strong, nonatomic) IBOutlet UISwitch *greenHit;

@property (strong,nonatomic) MGHole * activeHoleObject;
@property (strong,nonatomic) MGShot * activeShot;
@property (strong,nonatomic) NSString * shotTracking;
@property (strong,nonatomic) NSString * startingLocation;
@property (strong,nonatomic) NSString * endingLocation;
@property (strong,nonatomic) MGRoundStats * stats;

@property (strong, nonatomic) IBOutlet UIButton *clubSelectionButton;
@property (strong, nonatomic) IBOutlet UITextField *clubSelectionTextBox;
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;

@end
