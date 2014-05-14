//
//  MGClubCell.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/15/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGClubCell.h"

@implementation MGClubCell

@synthesize clubLabel=_clubLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
