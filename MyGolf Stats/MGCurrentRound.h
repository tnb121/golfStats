//
//  MGCurrentRound.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/22/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGRound.h"

@interface MGCurrentRound : MGRound

+ (id)sharedCurrentRound;
+ (NSString *)parseClassName;
-(void)createCurrentRound;
-(void)saveRound;

@end
