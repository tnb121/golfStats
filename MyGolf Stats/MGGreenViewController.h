//
//  MGGreenViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHole.h"
#import "MGShot.h"
#import "MGRoundStats.h"

@interface MGGreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *sandSaveUpDownView;
@property (weak, nonatomic) IBOutlet UIView *saveAndHoleSelectionView;


@property (strong, nonatomic) IBOutlet UISegmentedControl *upAndDown;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sandSave;

@property (weak, nonatomic) IBOutlet UIView *scoreCardView;

@property (weak, nonatomic) IBOutlet UILabel *holeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hole1Label;
@property (weak, nonatomic) IBOutlet UILabel *hole2Label;
@property (weak, nonatomic) IBOutlet UILabel *hole3Label;

@property (weak, nonatomic) IBOutlet UILabel *parTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *parHole1Label;
@property (weak, nonatomic) IBOutlet UILabel *parHole2Label;
@property (weak, nonatomic) IBOutlet UILabel *parHole3Label;

@property (weak, nonatomic) IBOutlet UILabel *puttsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *puttsHole1Label;
@property (weak, nonatomic) IBOutlet UILabel *puttsHole2Label;
@property (weak, nonatomic) IBOutlet UILabel *puttsHole3Label;

@property (weak, nonatomic) IBOutlet UILabel *penaltiesTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *penaltiesHole1Label;
@property (weak, nonatomic) IBOutlet UILabel *penaltiesHole2Label;
@property (weak, nonatomic) IBOutlet UILabel *penaltiesHole3Label;

@property (weak, nonatomic) IBOutlet UILabel *scoreTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreHole1Label;
@property (weak, nonatomic) IBOutlet UILabel *scoreHole2Label;
@property (weak, nonatomic) IBOutlet UILabel *scoreHole3Label;

@property (strong, nonatomic) IBOutlet UIStepper *puttsStepper;
@property (strong, nonatomic) IBOutlet UIStepper *penaltyStrokesStepper;
@property (strong, nonatomic) IBOutlet UIStepper *scoreStepper;

@property (strong, nonatomic) IBOutlet UIStepper *holeNumberStepper;
@property (weak, nonatomic) IBOutlet UIButton *saveHoleButton;

@property (weak, nonatomic) IBOutlet UILabel *holeNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *previousHoleButton;
@property (weak, nonatomic) IBOutlet UIButton *nextHoleButton;

@property (strong,nonatomic) MGHole * activeHoleObject;
@property (strong,nonatomic) MGShot * activeShot;
@property (strong,nonatomic) NSString * shotTracking;
@property (strong,nonatomic) NSString * startingLocation;

@end
