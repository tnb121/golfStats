//
//  MGRoundHistoryCellTableViewCell.h
//  MyGolf Stats
//
//  Created by Todd - Developer on 4/19/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRoundHistoryCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roundHistoryDate;
@property (weak, nonatomic) IBOutlet UILabel *roundHistoryFairway;
@property (weak, nonatomic) IBOutlet UILabel *roundHistoryGreens;
@property (weak, nonatomic) IBOutlet UILabel *roundHistoryPutts;
@property (weak, nonatomic) IBOutlet UILabel *roundHistoryScore;

@end
