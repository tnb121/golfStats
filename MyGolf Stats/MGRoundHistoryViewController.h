//
//  MGRoundHistoryViewController.h
//  MyGolf Stats
//
//  Created by Todd - Developer on 5/1/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRound.h"

@interface MGRoundHistoryViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSArray* holesArrayForRound;
@property (strong,nonatomic) NSString * roundDate;
@property (strong,nonatomic) NSString * roundScore;

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
