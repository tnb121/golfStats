//
//  MGTeeShotViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHole.h"
#import "MGRoundStats.h"
#import "MGShot.h"
#import "KeyboardController.h"

@interface MGTeeShotViewController : UIViewController<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,KeyboardControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *parFrameView;

@property (weak, nonatomic) IBOutlet UILabel *parLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *holePar;

@property (strong, nonatomic) IBOutlet UIStepper *holeNumberStepper;
@property (strong, nonatomic) IBOutlet UILabel *holeNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousHoleButton;
@property (weak, nonatomic) IBOutlet UIButton *nextHoleButton;

@property (strong,nonatomic) UIImageView * swipeView;
@property (strong,nonatomic) UIView * par3AlphaView;


@property (strong, nonatomic) IBOutlet UIButton *clubUsedButton;

@property (strong, nonatomic) IBOutlet UISwitch *fairwayLeft;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayShort;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayRight;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayLong;
@property (strong, nonatomic) IBOutlet UISwitch *fairwayHit;

@property (strong, nonatomic) IBOutlet UIButton *clubSelectionButton;
@property (strong, nonatomic) IBOutlet UITextField *clubSelectionTextBox;
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (weak, nonatomic) IBOutlet UIImageView *TeeShotControllerImage;

@property (weak, nonatomic) IBOutlet UIImageView *fairwayImageView;

@property (strong,nonatomic) MGHole * activeHoleObject;



@end
