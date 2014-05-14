//
//  MGRoundHistoryTableViewController.h
//  MyGolf Stats
//
//  Created by Todd - Developer on 5/1/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRoundHistoryTableViewController : UITableViewController

@property (strong,nonatomic) NSArray* holesArrayForRound;
@property (strong,nonatomic) NSString * roundDate;
@property (strong,nonatomic) NSString * roundScore;


@end
