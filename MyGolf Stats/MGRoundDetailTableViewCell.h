//
//  MGRoundDetailTableViewCell.h
//  MyGolf Stats
//
//  Created by Todd - Developer on 5/1/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRoundDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *holeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fairwayLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *puttsLabel;
@property (weak, nonatomic) IBOutlet UILabel *penaltiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
