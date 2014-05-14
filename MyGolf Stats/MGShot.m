//
//  MGShot.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/10/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGShot.h"
#import <Parse/PFObject+Subclass.h>

@implementation MGShot

+ (NSString *)parseClassName {
	return @"MGShot";
}


@dynamic  parseID;
@dynamic  roundID;
@dynamic  holeNumber;
@dynamic  club;
@dynamic  startingLocation;
@dynamic  endingLocation;
@dynamic  target;
@dynamic  effort;

@end
