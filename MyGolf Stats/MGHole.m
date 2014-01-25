//
//  MGHole.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/10/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGHole.h"
#import <Parse/PFObject+Subclass.h>

@implementation MGHole

+ (NSString *)parseClassName {
	return @"MGHole";
}

@dynamic  roundID;
@dynamic  holeNumber;
@dynamic  par;
@dynamic  holeHandicap;
@dynamic  fairway;
@dynamic  green;
@dynamic  chips;
@dynamic  putts;
@dynamic  penaltyStrokes;
@dynamic  score;
@dynamic upAndDown;
@dynamic sandSave;

@end
