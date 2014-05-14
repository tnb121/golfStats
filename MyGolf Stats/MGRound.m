//
//  MGRound.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/10/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGRound.h"
#import <Parse/PFObject+Subclass.h>

@implementation MGRound

+ (NSString *)parseClassName
    {
        return @"MGRound";
    }

@dynamic    golfer;
@dynamic    user;
@dynamic    roundID;
@dynamic    courseName;
@dynamic    tee;
@dynamic    length;
@dynamic    holes;
@dynamic    currentHole;
@dynamic    date;
@dynamic    rating;
@dynamic    slope;
@dynamic    score;
@dynamic    differential;
@dynamic    handicap;
@dynamic    combined;
@dynamic    location;

@end