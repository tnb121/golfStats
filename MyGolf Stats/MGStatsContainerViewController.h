//
//  MGStatsContainerViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 3/8/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRoundStats.h"
#import "MGHole.h"
#import "MGCurrentRound.h"

@interface MGStatsContainerViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong,nonatomic) MGRoundStats * stats;
@property (strong,nonatomic) MGCurrentRound * currentRound;

@property (strong,nonatomic) MGHole * activeHoleObject;
@property (weak, nonatomic) IBOutlet UILabel *courseName;

@property (strong, nonatomic) IBOutlet UILabel *fairwaysHit;
@property (strong, nonatomic) IBOutlet UILabel *greensHit;
@property (strong, nonatomic) IBOutlet UILabel *upAndDownMade;
@property (strong, nonatomic) IBOutlet UILabel *sandSaveMade;

@property (strong, nonatomic) IBOutlet UILabel *fairwayTotal;
@property (strong, nonatomic) IBOutlet UILabel *greenTotal;
@property (strong, nonatomic) IBOutlet UILabel *upAndDownTotal;
@property (strong, nonatomic) IBOutlet UILabel *SandSaveTotal;

@property (strong, nonatomic) IBOutlet UILabel *scoreTotal;
@property (strong, nonatomic) IBOutlet UILabel *puttsTotal;
@property (strong, nonatomic) IBOutlet UILabel *penaltyStrokesTotal;
@property (strong, nonatomic) IBOutlet UILabel *scoreToPar;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *courseLabelView;

@end
