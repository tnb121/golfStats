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


@dynamic  user;
@dynamic roundID;
@dynamic  holeID;
@dynamic  club;
@dynamic  fairway;
@dynamic  green;


@end
