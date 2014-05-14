//
//  MGHomeViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#import "KeyboardController.h"

@interface MGHomeViewController : UIViewController<PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,UITextFieldDelegate,KeyboardControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

//Outlets for top view
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *facebookImage;

@property (weak, nonatomic) IBOutlet UILabel *handicapTitle;
@property (weak, nonatomic) IBOutlet UILabel *roundsTitle;
@property (weak, nonatomic) IBOutlet UILabel *averageScoreTitle;

@property (strong, nonatomic) IBOutlet UILabel *handicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *roundCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *roundScoringAverageLabel;

//Outlets for Filter Label View
@property (strong, nonatomic) IBOutlet UIView *filterBoxView;

//Outlets for Filter Selection View
@property (strong, nonatomic) IBOutlet UIView *filterSelectionBoxView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *parFilter;
@property (strong, nonatomic) IBOutlet UIButton *courseButton;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet UITextField *courseTextBoxDummy;
@property (strong, nonatomic) IBOutlet UITextField *timeTextBoxDummy;

//Outlets for Container View
@property (strong,nonatomic) IBOutlet UIView *homeContainerView;

@end
