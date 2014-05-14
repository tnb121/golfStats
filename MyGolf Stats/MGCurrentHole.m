//
//  MGCurrentHole.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/22/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGCurrentHole.h"
#import <Parse/PFObject+Subclass.h>

@implementation MGCurrentHole

+ (id)sharedCurrentHole
{
    static MGCurrentHole *sharedCurrentHole= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCurrentHole= [[self alloc] init];
    });
    return sharedCurrentHole;
}

- (id)init
{
	self = [super init];
	return self;
}

@end
