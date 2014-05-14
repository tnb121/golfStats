//
//  Handicap.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "MGRound.h"

@interface Handicap : NSObject

+ (id)sharedHandicap;

-(double)calculateCourseHandicap:(double)slope withPlayerHandicap:(double) playerHandicap;
-(double)handicapCalculation;
-(NSString*)handicapCalculationString;
-(NSNumber *) CalculateDifferentialWithRating:(double)rating withslope:(double)slope withscore:(double)score withNumberOfHoles:(double)holes;
-(PFObject*)combine9HoleRounds:(MGRound*)round1 withRound:(MGRound*)round2;
-(double)scoringAveragePer18WithArray:(NSArray*)array;
//-(double)mostRecentHandicap;
//-(NSArray*)handicapHistoryArray;



@end
