//
//  MGGreenViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/26/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHole.h"

@interface MGGreenViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *puttsLabel;
@property (strong, nonatomic) IBOutlet UILabel *penaltyStrokesLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *holeNumberLabel;

@property (strong, nonatomic) IBOutlet UIStepper *puttsStepper;
@property (strong, nonatomic) IBOutlet UIStepper *penaltyStrokesStepper;
@property (strong, nonatomic) IBOutlet UIStepper *scoreStepper;

@property (strong, nonatomic) IBOutlet UISegmentedControl *upAndDown;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sandSave;
@property (strong, nonatomic) IBOutlet UIStepper *holeNumberStepper;

@property (strong,nonatomic) MGHole * activeHoleObject;

@end
