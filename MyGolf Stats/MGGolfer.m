//
//  MGGolfer.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/15/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGGolfer.h"
#import <Parse/PFObject+Subclass.h>

@implementation MGGolfer

+ (NSString *)parseClassName {
	return @"MGGolfer";
}

@dynamic parseID;
@dynamic name;
@dynamic email;
@dynamic phoneNumber;
@dynamic handicap;
@dynamic currentRoundID;
@dynamic currentRound;

@end
