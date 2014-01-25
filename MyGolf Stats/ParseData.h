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
	NSArray * roundsFromParse;
	NSArray * roundsRecent20FromParse;
	NSArray * handicapHistoryFromParse;
	NSArray * coursesFromParse;
}

+ (id)sharedParseData;

-(NSArray *) uniqueCourseArray;
-(void)updateParseRounds;
-(void)updateParseHandicapHistory;
-(void)updateParseRoundsRecent20;
-(void)updateParseCourses;
-(void)updateAppVersion;
-(void)upgradeToFullVersion;
-(void)incrementRoundCount;

@property (retain,nonatomic) NSNumber * slopeAverage;
@property (nonatomic,retain) NSNumber * scoringAverage;
@property (retain,nonatomic) NSNumber * roundCount;
@property (strong,nonatomic) NSArray * roundsFromParse;
@property (copy,nonatomic) NSArray * roundsRecent20FromParse;
@property (strong,nonatomic) NSArray * handicapHistoryFromParse;
@property (strong,nonatomic) NSArray * coursesFromParse;
@property (strong,nonatomic)SKProduct * product;

@end
