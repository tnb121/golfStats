//
//  Handicap.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "Handicap.h"
#import "ParseData.h"
#import "MGRound.h"
#import "MGCurrentRound.h"

@interface Handicap()

@end

@implementation Handicap

NSMutableArray * roundsCumulativeArray;
NSMutableArray * handicapHistoryArray;

+ (id)sharedHandicap
{
    static Handicap *sharedHandicap= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandicap= [[self alloc] init];
    });

    return sharedHandicap;
}

-(double)handicapCalculation
{
    NSArray * arrayForHandicap = [[[ParseData sharedParseData]roundsFromParseForHandicap] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDifferential" ascending:NO]]];
    
    double diff ;
    NSInteger y = 0;
    for (y=0; y<arrayForHandicap.count; y++)
    {
        
        MGRound * subjectRound = [arrayForHandicap objectAtIndex:y];
        
        diff = [[subjectRound valueForKey:@"roundDifferential"] doubleValue];
        NSLog(@"%f",diff);
    }
    
	NSInteger   roundCountParse = arrayForHandicap.count;
	NSInteger	roundCountForHandicap=[self CalculateHCapRounds:(double) roundCountParse];
    
	if(roundCountForHandicap == 0) return 0;
    
	double differentialSum = 0;
	NSInteger x = 1;
	
	NSMutableArray* roundCalculationArray = [arrayForHandicap mutableCopy];
    
	for (x=1;x<=roundCountForHandicap;x++)
	{
        MGRound * lastRound = [roundCalculationArray objectAtIndex:roundCalculationArray.count-1];
        
        double score  = [[lastRound valueForKey:@"roundScore"]doubleValue];
        double slope  = [[lastRound valueForKey:@"roundSlope"] doubleValue];
        double rating = [[lastRound valueForKey:@"roundRating"] doubleValue];
        double differential = [[self CalculateDifferentialWithRating:rating withslope:slope withscore:score withNumberOfHoles:18]doubleValue];
        
		differentialSum=differentialSum + differential;
		[roundCalculationArray removeLastObject];
	}
    
	NSInteger handicapValueInt =(differentialSum / roundCountForHandicap * 0.96*10);
	double handicapValueDouble = handicapValueInt;
	return handicapValueDouble /10;
    
}

-(NSString*)handicapCalculationString
{
	NSString* handicapString = [NSString stringWithFormat:@"%.1f",[self handicapCalculation]];
	NSString* handicapStringNegative = [NSString stringWithFormat:@"%.1f",-(self.handicapCalculation)];
	if([[[ParseData sharedParseData]roundCount]integerValue]<5)
		return @"-";
	else if (self.handicapCalculation <0)
		return [@"+"stringByAppendingString:handicapStringNegative];
	else
		return handicapString;
}

-(double) CalculateHCapRounds:(double) rounds
{
	if(rounds <=4)
	{
		return 0;
	}
	else if (rounds <=6)
	{
		return 1;
	}
	else if (rounds <=16)
	{
		float roundcountx  = (rounds - 3)/2;
		NSInteger roundcount = roundcountx;
		return roundcount;
	}
	else if (rounds <=19)
	{
		float roundcountx = (rounds-10);
		NSInteger roundcount = roundcountx;
		return roundcount;
	}
	else if (rounds >= 20)
	{
		return 10;
	}

	return 0;
}

-(double)calculateCourseHandicap:(double)slope withPlayerHandicap:(double) playerHandicap
{
	return slope / 113 * playerHandicap;
}

-(PFObject*)combine9HoleRounds:(MGRound*)round1 withRound:(MGRound*)round2
{
    PFObject * newRound =[PFObject objectWithClassName:@"PFObect"];
    
    NSNumber * score = [NSNumber numberWithInteger:[[round1 valueForKey:@"roundScore"]integerValue] + [[round2 valueForKey:@"roundScore"]integerValue]];
    NSNumber * slope = [NSNumber numberWithInteger:([[round1 valueForKey:@"roundSlope"]integerValue] + [[round2 valueForKey:@"roundSlope"]integerValue])/2];
    NSNumber * rating = [NSNumber numberWithInteger:([[round1 valueForKey:@"roundRating"]doubleValue] + [[round2 valueForKey:@"roundRating"]doubleValue])/2];
    double holes = 18;
    NSNumber * differential = [self CalculateDifferentialWithRating:[rating doubleValue] withslope:[slope doubleValue] withscore:[score doubleValue] withNumberOfHoles:holes];
    
    newRound[@"roundScore"]        = score;
    newRound[@"roundSlope"]        = slope;
    newRound[@"roundRating"]       = rating;
    newRound[@"roundDifferential"] = differential;
    newRound[@"roundUser"]         = [PFUser currentUser].username;
    newRound[@"roundCourse"]       = [round2 valueForKey:@"roundCourse"];
    newRound[@"roundTee"]          = [round2 valueForKey:@"roundTee"];
    newRound[@"roundCombined"]     = @"yes";
    newRound[@"roundHoles"]        = [NSNumber numberWithDouble:holes];
    newRound[@"roundDate"]         = [round2 valueForKey:@"roundDate"];
    
    return newRound;
}

-(NSNumber *) CalculateDifferentialWithRating:(double)rating withslope:(double)slope withscore:(double)score withNumberOfHoles:(double)holes
{
    NSNumberFormatter *differentialFormatter = [[NSNumberFormatter alloc] init];
	[differentialFormatter setMaximumFractionDigits:1];
    
    double slopeConstant= 113.00;
    
	double differential =  (score - (rating * holes / 18)) * slopeConstant / slope;
    
    NSString * differentialString = [NSString stringWithFormat:@"%.1f",differential];
	return  [differentialFormatter numberFromString:differentialString];
}

-(double)scoringAveragePer18WithArray:(NSArray*)array
{
    NSArray * roundArray = array;
    
    double scoreTotal = 0;
    double holeTotal = 0;
    
    NSInteger x = 0;
    
    for (x=0; x<roundArray.count; x++)
    {
        PFObject * currentRound = [roundArray objectAtIndex:x];
        
        scoreTotal = scoreTotal + [[currentRound valueForKey:@"roundScore"]doubleValue];
        
        double currentRoundHoles = [[currentRound valueForKey:@"roundLength"]doubleValue];
        
        if(currentRoundHoles != 9)
            currentRoundHoles =18;
        
        holeTotal = holeTotal + currentRoundHoles;
        
    }
    
    return scoreTotal / holeTotal * 18;
    
}



/*
-(double) mostRecentHandicap
{
	NSMutableArray *array= [[[ParseData sharedParseData]handicapHistoryFromParse]mutableCopy];

	if (array == nil)
	{
		return 0;
	}

	double lastHandicap =[[[array firstObject]	valueForKey:@"historyHandicap"] doubleValue];

	return lastHandicap;
}

-(NSArray*) handicapHistoryArray
{
	NSArray * roundsArray = [[[ParseData sharedParseData]roundsFromParse] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc]initWithKey:@"roundDate" ascending:YES]]];
	roundsCumulativeArray=[[NSMutableArray alloc]init];
	handicapHistoryArray = [[NSMutableArray alloc]init];

	NSInteger roundCount = roundsArray.count;
	NSInteger x;

	for (x=1; x<=roundCount; x++)
	{

		[roundsCumulativeArray addObject:[roundsArray objectAtIndex:x-1]];

				MGHandicapHistoryObject * historyObject = [[MGHandicapHistoryObject alloc]init];

				if(x<5)historyObject.handicap = @"-";
					else historyObject.handicap=[NSString stringWithFormat:@"%.1f",([self handicapCalculation2:[roundsCumulativeArray copy]])];
				historyObject.scoringAverage=[roundsCumulativeArray valueForKeyPath:@"@avg.roundScore"];
				historyObject.roundCount=[NSNumber numberWithInt:(roundsCumulativeArray.count)];
				historyObject.date =[[roundsCumulativeArray objectAtIndex:x-1] valueForKeyPath:@"roundDate"];
				[handicapHistoryArray addObject:historyObject];
		
	}
	return [handicapHistoryArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc]initWithKey:@"roundCount" ascending:NO]]];
 }
 */


@end
