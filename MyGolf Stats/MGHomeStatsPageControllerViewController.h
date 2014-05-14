//
//  MGHomeStatsPageControllerViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/17/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGHomeStatsPageControllerViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (strong,nonatomic) UILabel* greenHitLabel;
@property (strong,nonatomic) UILabel* greenLeftLabel;
@property (strong,nonatomic) UILabel* greenRightLabel;
@property (strong,nonatomic) UILabel* greenLongLabel;
@property (strong,nonatomic) UILabel* greenShortLabel;

@property (strong,nonatomic) UILabel* fairwayHitLabel;
@property (strong,nonatomic) UILabel* fairwayLeftLabel;
@property (strong,nonatomic) UILabel* fairwayRightLabel;
@property (strong,nonatomic) UILabel* fairwayLongLabel;
@property (strong,nonatomic) UILabel* fairwayShortLabel;

@property (strong,nonatomic) UILabel* puttsPerHoleLabel;
@property (strong,nonatomic) UILabel* puttsPerRoundLabel;
@property (strong,nonatomic) UILabel* upAndDownLabel;
@property (strong,nonatomic) UILabel* sandSavesLabel;

@property (strong,nonatomic) UILabel* puttsPerHoleDataLabel;
@property (strong,nonatomic) UILabel* puttsPerRoundDataLabel;
@property (strong,nonatomic) UILabel* upAndDownDataLabel;
@property (strong,nonatomic) UILabel* sandSavesDataLabel;

@end
