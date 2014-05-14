//
//  MGHistoryViewController.h
//  MyGolf Stats
//
//  Created by Todd - Developer on 4/19/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGHistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *summaryView;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeader;
@property (weak, nonatomic) IBOutlet UILabel *fairwaysPer18Label;
@property (weak, nonatomic) IBOutlet UILabel *greensPer18Label;
@property (weak, nonatomic) IBOutlet UILabel *puttsPer18Label;
@property (weak, nonatomic) IBOutlet UILabel *penaltiesPer18Holes;

@end
