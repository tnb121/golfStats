//
//  MGCurrentHole.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/22/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGHole.h"

@interface MGCurrentHole : MGHole<PFSubclassing>

+ (NSString *)parseClassName;

+ (id)sharedCurrentHole;


@end
