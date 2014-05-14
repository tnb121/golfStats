//
//  ParseData.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <StoreKit/StoreKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ParseData : NSObject<SKProductsRequestDelegate>
{
	NSNumber * slopeAverage;
	NSNumber * scoringAverage;
	NSNumber * roundCount;
	NSArray  * roundsFromParse;
    NSArray  * roundsFromParseForHandicap;
	NSArray  * holesFromParse;
	NSArray  * shotsFromParse;
	NSArray  * roundsRecent20FromParse;
	NSArray  * coursesFromParse;
	NSArray  * coursesFromParseWithHoles;
	NSArray  * uniqueCourseArray;

	NSDate * Last5RoundsDate;
	NSDate* Last10RoundsDate;
	NSDate* Last15RoundsDate;
	NSDate* Last20RoundsDate;
}

+ (id)sharedParseData;

-(NSArray *) uniqueCourseArray;
-(void)updateParseRounds;
-(void)updateParseHoles;
-(void)updateParseShots;
-(void)updateParseRoundsRecent20;
-(void)updateParseCourses;
-(void)updateParseCoursesWithHoles;
-(void)updateAppVersion;
-(void)upgradeToFullVersion;
-(void)incrementRoundCount;

@property (retain,nonatomic) NSNumber * slopeAverage;
@property (nonatomic,retain) NSNumber * scoringAverage;
@property (retain,nonatomic) NSNumber * roundCount;
@property (strong,nonatomic) NSArray * roundsFromParse;
@property (strong,nonatomic) NSArray * roundsFromParseForHandicap;
@property (strong,nonatomic) NSArray * holesFromParse;
@property (strong,nonatomic) NSArray * shotsFromParse;
@property (copy,nonatomic)   NSArray * roundsRecent20FromParse;
@property (strong,nonatomic) NSArray * coursesFromParse;
@property (strong,nonatomic) NSArray * coursesFromParseWithHoles;
@property (strong,nonatomic) NSArray * uniqueCourseArray;
@property (strong,nonatomic) SKProduct * product;

@property (strong,nonatomic) NSDate * Last5RoundsDate;
@property (strong,nonatomic) NSDate* Last10RoundsDate;
@property (strong,nonatomic) NSDate * Last15RoundsDate;
@property (strong,nonatomic) NSDate* Last20RoundsDate;

@property (nonatomic) BOOL updatedDataNeeded;

@end
