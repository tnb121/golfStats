//
//  MGRoundStats.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/30/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGRoundStats.h"
#import "MGHole.h"

@implementation MGRoundStats

@synthesize currentRound;

+ (id)sharedRoundStats
{
    static MGRoundStats *sharedRoundStats= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRoundStats= [[self alloc] init];
    });
    return sharedRoundStats;
}

- (id)init
{
	self = [super init];
	currentRound = [MGCurrentRound sharedCurrentRound];
	return self;
}

-(NSInteger)fairwaysHit:(NSArray*)array
{
	NSArray * holesArray = array;
    NSInteger x=1;
	NSInteger fairways = 0;

	for (x=0; x<holesArray.count; x++)
		{
			MGHole * currentHole = [holesArray objectAtIndex:x];
			if ([currentHole.fairway isEqualToString:@"fairwayHit"]) fairways ++;
		}
	return fairways;
}

-(NSInteger)fairwaysTotal:(NSArray*)array
{
	NSArray * holesArray = array;
    NSInteger x=1;
	NSInteger fairways = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if(currentHole.fairway.length>0)
			fairways ++;
	}
	return fairways;
}
-(NSInteger)greensHit:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger greens = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.green isEqualToString:@"greenHit"]) greens ++;
	}
	return greens;
}

-(NSInteger)greensTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger greens = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if(currentHole.green.length>0)
			greens ++;
	}
	return greens;
}

-(NSInteger)scoreTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger score = 0;

	for (x=0; x<holesArray.count; x++)
		{
			MGHole * currentHole = [holesArray objectAtIndex:x];
			score = [currentHole.score intValue] + score;
		}
	return score;
}

-(NSInteger)puttsTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger putts = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		putts = [currentHole.putts intValue] + putts;
	}
	return putts;
}

-(NSInteger)parTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger par = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		par = [currentHole.par intValue] + par;
	}
	return par;
}

-(NSInteger)penaltyStrokesTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger penaltyStrokes = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		penaltyStrokes = [currentHole.penaltyStrokes intValue] +penaltyStrokes;
	}
	return penaltyStrokes;
}

-(NSInteger)upAndDownMade:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger upAndDown = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.upAndDown isEqualToString:@"made"]) upAndDown ++;
	}
	return upAndDown;
}

-(NSInteger)upAndDownTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger upAndDown = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if(currentHole.upAndDown.length>0)
			upAndDown ++;
	}

	return upAndDown;
}

-(NSInteger)sandSaveMade:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger sandSave = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.sandSave isEqualToString:@"made"]) sandSave ++;
	}
	return sandSave;
}

-(NSInteger)sandSaveTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger x=1;
	NSInteger sandSave = 0;

	for (x=0; x<holesArray.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if(currentHole.sandSave.length>0)
			sandSave++;
	}

	return sandSave;
}

-(NSString*)historyFairwaysHit:(NSArray*)array
{
    NSInteger fairwaysHit = [self fairwaysHit:array];
    NSInteger fairwaysTotal = [self fairwaysTotal:array];
    
    NSString *resultString = [[[NSString stringWithFormat:@"%ld",(long)fairwaysHit]stringByAppendingString:@"/" ]stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)fairwaysTotal]];
    return resultString;
    
}

-(NSString *)historyGreensHit:(NSArray*)array
{
    NSInteger greensHit = [self greensHit:array];
    NSInteger greensTotal = [self greensTotal:array];
    
    NSString *resultString = [[[NSString stringWithFormat:@"%ld",(long)greensHit]stringByAppendingString:@"/" ]stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)greensTotal]];
    return resultString;
    
}

@end
