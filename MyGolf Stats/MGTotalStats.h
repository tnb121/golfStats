//
//  MGTotalStats.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/1/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGHole.h"
#import "ParseData.h"

@interface MGTotalStats : NSObject
{
	NSArray * filteredHolesAfterPredicates;
	NSPredicate * parPredicate;
	NSPredicate * coursePredicate;
	NSPredicate * timePredicate;
}

+ (id)sharedTotalStats;
+ (NSString *)parseClassName;

-(void)filterAllHolesArray;

@property (strong,nonatomic) NSPredicate * parPredicate;
@property (strong,nonatomic) NSPredicate * coursePredicate;
@property (strong,nonatomic) NSPredicate * timePredicate;

@property (strong,nonatomic) NSNumber *  courseIndexValue;
@property (strong,nonatomic) NSNumber * timeFrameIndexValue;

@property (strong,nonatomic) NSString * parFilterSelection;
@property (strong,nonatomic) NSString * courseFilterSelection;
@property (strong,nonatomic) NSNumber * timeFilterSelection;

@property (strong,nonatomic) NSArray * filteredHolesAfterPredicates;


-(double)fairwaysHit:(NSArray*)array;
-(double)fairwaysLeft:(NSArray*)array;
-(double)fairwaysRight:(NSArray*)array;
-(double)fairwaysLong:(NSArray*)array;
-(double)fairwaysShort:(NSArray*)array;
-(double)fairwaysTotal:(NSArray*)array;

-(NSString*)fairwaysHitString:(NSArray*)array;
-(NSString*)fairwaysLeftString:(NSArray*)array;
-(NSString*)fairwaysRightString:(NSArray*)array;
-(NSString*)fairwaysLongString:(NSArray*)array;
-(NSString*)fairwaysShortString:(NSArray*)array;

-(double)greensHit:(NSArray*)array;
-(double)greensLeft:(NSArray*)array;
-(double)greensRight:(NSArray*)array;
-(double)greensLong:(NSArray*)array;
-(double)greensShort:(NSArray*)array;
-(double)greensTotal:(NSArray*)array;

-(NSString*)greensHitString:(NSArray*)array;
-(NSString*)greensLeftString:(NSArray*)array;
-(NSString*)greensRightString:(NSArray*)array;
-(NSString*)greensLongString:(NSArray*)array;
-(NSString*)greensShortString:(NSArray*)array;

-(NSInteger)scoreTotal:(NSArray*)array;
-(NSInteger)puttsTotal:(NSArray*)array;
-(NSInteger)parTotal:(NSArray*)array;
-(NSInteger)penaltyStrokesTotal:(NSArray*)array;
-(NSInteger)upAndDownMade:(NSArray*)array;
-(NSInteger)upAndDownTotal:(NSArray*)array;
-(NSInteger)sandSaveMade:(NSArray*)array;
-(NSInteger)sandSaveTotal:(NSArray*)array;

-(double)fairwaysPercentage:(NSArray *)array;
-(double)greensPercentage:(NSArray*)array;
-(double)scorePer18:(NSArray*)array;
-(double)puttsPer18:(NSArray*)array;
-(double)parPer18:(NSArray*)array;
-(double)penaltyStrokesPer18:(NSArray*)array;
-(double)upAndDownPercentage:(NSArray*)array;
-(double)sandSavePercentage:(NSArray*)array;

-(NSString*)scorePer18String:(NSArray*)array;
-(NSString*)scorePerHoleString:(NSArray*)array;
-(NSString*)puttsPer18String:(NSArray*)array;
-(NSString*)penaltyStrokesPer18String:(NSArray*)array;
-(NSString *)puttsPerHoleString:(NSArray*)array;
-(NSString*)upAndDownPercentageString:(NSArray*)array;
-(NSString*)sandSavePercentageString:(NSArray*)array;

@property (strong,nonatomic) NSMutableArray * allHolesArray;


@end
