//
//  MGRoundStats.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/30/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGCurrentRound.h"

@interface MGRoundStats : NSObject
{
	MGCurrentRound * currentRound;
}

+ (id)sharedRoundStats;

@property (strong,nonatomic) MGCurrentRound * currentRound;

-(NSInteger)fairwaysHit:(NSArray*)array;
-(NSInteger)fairwaysTotal:(NSArray*)array;
-(NSInteger)greensHit:(NSArray*)array;
-(NSInteger)greensTotal:(NSArray*)array;
-(NSInteger)scoreTotal:(NSArray*)array;
-(NSInteger)puttsTotal:(NSArray*)array;
-(NSInteger)parTotal:(NSArray*)array;
-(NSInteger)penaltyStrokesTotal:(NSArray*)array;
-(NSInteger)upAndDownMade:(NSArray*)array;
-(NSInteger)upAndDownTotal:(NSArray*)array;
-(NSInteger)sandSaveMade:(NSArray*)array;
-(NSInteger)sandSaveTotal:(NSArray*)array;

-(NSString*)historyFairwaysHit:(NSArray*)array;
-(NSString *)historyGreensHit:(NSArray*)array;

@end
