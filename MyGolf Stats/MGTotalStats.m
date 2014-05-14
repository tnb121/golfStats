//
//  MGTotalStats.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/1/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGTotalStats.h"
#import "ParseData.h"
#import "MGRound.h"
#import "MGHole.h"

@interface MGTotalStats()


@property (strong,nonatomic) ParseData * parseData;


@end

@implementation MGTotalStats

@synthesize parseData;
@synthesize coursePredicate;
@synthesize parPredicate;
@synthesize timePredicate;
@synthesize courseIndexValue;
@synthesize timeFrameIndexValue;
@synthesize parFilterSelection;
@synthesize courseFilterSelection;
@synthesize timeFilterSelection;
@synthesize allHolesArray;
@synthesize filteredHolesAfterPredicates;

NSInteger x;

-(NSMutableArray*) allHolesArray
{
	return [[[ParseData sharedParseData]holesFromParse]mutableCopy];
}

+ (id)sharedTotalStats
{
    static MGTotalStats *sharedTotalStats= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTotalStats= [[self alloc] init];
    });

    return sharedTotalStats;
}
+ (NSString *)parseClassName
{
	return @"MGHole";
}

- (id)init
{
	self = [super init];

	parseData = [ParseData sharedParseData];
	allHolesArray=[[NSMutableArray alloc]init];
	parPredicate = [[NSPredicate alloc]init];
	coursePredicate=[[NSPredicate alloc]init];
	timePredicate=[[NSPredicate alloc]init];
	courseIndexValue=[[NSNumber alloc]init];
	timeFrameIndexValue=[[NSNumber alloc]init];
	parFilterSelection=[[NSString alloc]init];
	courseFilterSelection=[[NSString alloc]init];
	timeFilterSelection=[[NSNumber alloc]init];
	filteredHolesAfterPredicates=[[NSArray alloc]init];

	return self;
}

-(NSPredicate*)coursePredicate
{
	if(!coursePredicate)
		coursePredicate = [NSPredicate predicateWithFormat:@"course != none"];
	return coursePredicate;
}
-(NSPredicate*)parPredicate
{
	if(!parPredicate)
		parPredicate= [NSPredicate predicateWithFormat:@"par >0"];
	return parPredicate;
}
-(NSPredicate*)timePredicate
{
	if(!timePredicate)
		timePredicate= [NSPredicate predicateWithFormat:@"holeDate < now()"];
	return timePredicate;
}

-(void)filterAllHolesArray;
{

	NSPredicate * combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:parPredicate,coursePredicate,nil]];

	NSArray * resultArray = [self.allHolesArray filteredArrayUsingPredicate:combinedPredicate];

	NSArray * sortedResultArray=[resultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"holeDate" ascending:NO]]];



	if([self.timeFilterSelection intValue]==0)
	{
		filteredHolesAfterPredicates = sortedResultArray;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"FilteredArrayComplete" object:nil];
		return;
	}


	else
	{
		NSMutableArray * finalFilteredArray = [[NSMutableArray alloc]init];

		NSInteger i = 0;

		for (i=0; i<=[self.timeFilterSelection intValue];i++)
		{
			[finalFilteredArray addObject:[sortedResultArray objectAtIndex:i]];
		}

		filteredHolesAfterPredicates = [finalFilteredArray copy];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"FilteredArrayComplete" object:nil];
	}
}


-(double)fairwaysHit:(NSArray*)array
{
	NSArray * holesArray = array;
	double fairways = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.fairway isEqualToString:@"fairwayHit"]) fairways ++;
	}
	return fairways;
}
-(double)fairwaysLeft:(NSArray*)array
{
	NSArray * holesArray = array;
	double fairways = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.fairway isEqualToString:@"fairwayLeft"]) fairways ++;
	}
	return fairways;
}
-(double)fairwaysRight:(NSArray*)array
{
	NSArray * holesArray = array;
	double fairways = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.fairway isEqualToString:@"fairwayRight"]) fairways ++;
	}
	return fairways;
}
-(double)fairwaysLong:(NSArray*)array
{
	NSArray * holesArray = array;
	double fairways = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.fairway isEqualToString:@"fairwayLong"]) fairways ++;
	}
	return fairways;
}
-(double)fairwaysShort:(NSArray*)array
{
	NSArray * holesArray = array;
	double fairways = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.fairway isEqualToString:@"fairwayShort"]) fairways ++;
	}
	return fairways;
}

-(double)fairwaysTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	NSInteger fairways = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if(currentHole.fairway.length>0)
			fairways ++;
	}
	return fairways;
}

-(double)fairwaysPercentage:(NSArray *)array
{
	double fairwayHit = [self fairwaysHit:array];
	double fairwayTotal = [self fairwaysTotal:array];

	float percent= fairwayHit/fairwayTotal*100;

	return percent;
}

// String Percentages

-(NSString*)fairwaysHitString:(NSArray *)array
{
	if([self fairwaysTotal:array]==0)
		return @"No Data";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self fairwaysHit:array]/[self fairwaysTotal:array]*100];
	}
}
-(NSString*)fairwaysLeftString:(NSArray*)array
{
	if([self fairwaysTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self fairwaysLeft:array]/[self fairwaysTotal:array]*100];
	}
}
-(NSString*)fairwaysRightString:(NSArray*)array
{
	if([self fairwaysTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self fairwaysRight:array]/[self fairwaysTotal:array]*100];
	}
}
-(NSString*)fairwaysLongString:(NSArray*)array
{
	if([self fairwaysTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self fairwaysLong:array]/[self fairwaysTotal:array]*100];
	}
}
-(NSString*)fairwaysShortString:(NSArray*)array
{
	if([self fairwaysTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self fairwaysShort:array]/[self fairwaysTotal:array]*100];
	}
}


-(NSString*)greensHitString:(NSArray*)array
{
	if([self greensTotal:array]==0)
		return @"No Data";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self greensHit:array]/[self greensTotal:array]*100];
	}
}
-(NSString*)greensLeftString:(NSArray*)array
{
	if([self greensTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self greensLeft:array]/[self greensTotal:array]*100];
	}
}
-(NSString*)greensRightString:(NSArray*)array
{
	if([self greensTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self greensRight:array]/[self greensTotal:array]*100];
	}
}
-(NSString*)greensLongString:(NSArray *)array
{
	if([self greensTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self greensLong:array]/[self greensTotal:array]*100];
	}
}
-(NSString*)greensShortString:(NSArray *)array
{
	if([self greensTotal:array]==0)
		return @"-";
	else
	{
		return [NSString stringWithFormat:@"%.1f%%",[self greensShort:array]/[self greensTotal:array]*100];
	}
}

-(double)greensHit:(NSArray*)array
{
	NSArray * holesArray = array;
	double greens = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.green isEqualToString:@"greenHit"]) greens ++;
	}
	return greens;
}
-(double)greensLeft:(NSArray*)array
{
	NSArray * holesArray = array;
	double greens = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.green isEqualToString:@"greenLeft"]) greens ++;
	}
	return greens;
}
-(double)greensRight:(NSArray*)array
{
	NSArray * holesArray = array;
	double greens = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.green isEqualToString:@"greenRight"]) greens ++;
	}
	return greens;
}
-(double)greensLong:(NSArray*)array
{
	NSArray * holesArray = array;
	double greens = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.green isEqualToString:@"greenLong"]) greens ++;
	}
	return greens;
}
-(double)greensShort:(NSArray*)array
{
	NSArray * holesArray = array;
	double greens = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.green isEqualToString:@"greenShort"]) greens ++;
	}
	return greens;
}


-(double)greensTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	double greens = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if(currentHole.green.length>0)
			greens ++;
	}
	return greens;
}

-(double)greensPercentage:(NSArray*)array
{
	double greenHit = [self greensHit:array];
	double greenTotal = [self greensTotal:array];

	return greenHit / greenTotal*100;
}

-(NSInteger)scoreTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	double score = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		score = [currentHole.score doubleValue] + score;
	}
	return score;
}

-(double)scorePer18:(NSArray*)array
{
    double totalScore = [self scoreTotal:array];
    double count = array.count;
    
	return totalScore/count*18;
}

-(NSString*)scorePer18String:(NSArray*)array
{
	if(array.count==0)
		return @"-";
	else return [NSString stringWithFormat:@"%.1f",[self scorePer18:array]];
}

-(double)scorePerHole:(NSArray*)array
{
	return [self scoreTotal:array]/array.count;
}
-(NSString*)scorePerHoleString:(NSArray*)array
{
	if(array.count==0)
		return @"-";
	else return [NSString stringWithFormat:@"%.2f",[self scorePerHole:array]];
}

-(NSInteger)puttsTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	double putts = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		putts = [currentHole.putts doubleValue] + putts;
	}
	return putts;
}

-(double)puttsPer18:(NSArray*)array
{
	double putts = [self puttsTotal:array];

	return putts/array.count*18;
}

-(double)puttsPerHole:(NSArray*)array
{
	return [self puttsPer18:array]/18;
}
-(NSString*)puttsPer18String:(NSArray*)array
{
	if([self puttsTotal:array]==0)
		return @"-";
	else return [NSString stringWithFormat:@"%.1f",[self puttsPer18:array]];
}

-(NSString *)puttsPerHoleString:(NSArray*)array
{
	if([self puttsTotal:array]==0)
		return @"-";
	else return [NSString stringWithFormat:@"%.2f",[self puttsPerHole:array]];
}

-(NSInteger)parTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	double par = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		par = [currentHole.par doubleValue] + par;
	}
	return par;
}
-(double)parPer18:(NSArray*)array
{
	return [self parTotal:array]/array.count*18;
}

-(NSInteger)penaltyStrokesTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	double penaltyStrokes = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		penaltyStrokes = [currentHole.penaltyStrokes doubleValue] +penaltyStrokes;
	}
	return penaltyStrokes;
}

-(double)penaltyStrokesPer18:(NSArray*)array
{
	return [self penaltyStrokesTotal:array]/array.count*18;
}

-(NSString*)penaltyStrokesPer18String:(NSArray*)array
{
	if(array.count==0)
		return @"-";
	else return [NSString stringWithFormat:@"%.1f",[self penaltyStrokesTotal:array]/(double)array.count*18];
}

-(NSInteger)upAndDownMade:(NSArray*)array
{
	NSArray * holesArray = array;
	double upAndDown = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.upAndDown isEqualToString:@"made"]) upAndDown ++;
	}
	return upAndDown;
}

-(NSInteger)upAndDownTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	double upAndDown = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if([currentHole.upAndDown isEqualToString:@"made"]||[currentHole.upAndDown isEqualToString:@"missed"])
			upAndDown ++;
	}

	return upAndDown;
}
-(double)upAndDownPercentage:(NSArray*)array
{
	double upAndDownHit = [self upAndDownMade:array];
	double upAndDownTotal = [self upAndDownTotal:array];

	return upAndDownHit/upAndDownTotal*100;
}

-(NSString*)upAndDownPercentageString:(NSArray*)array
{
	if([self upAndDownTotal:array]==0)
		return @"-";
	else

		return [NSString stringWithFormat:@"%.1f%%",[self upAndDownPercentage:array]];
}

-(NSInteger)sandSaveMade:(NSArray*)array
{
	NSArray * holesArray = array;
	double sandSave = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if ([currentHole.sandSave isEqualToString:@"made"]) sandSave ++;
	}
	return sandSave;
}

-(NSInteger)sandSaveTotal:(NSArray*)array
{
	NSArray * holesArray = array;
	double sandSave = 0;

	for (x=0; x<array.count; x++)
	{
		MGHole * currentHole = [holesArray objectAtIndex:x];
		if(currentHole.sandSave.length>0)
			sandSave++;
	}

	return sandSave;
}
-(double)sandSavePercentage:(NSArray*)array
{
	double sandSaveMade = [self sandSaveMade:array];
	double sandSaveTotal = [self sandSaveTotal:array];

	return sandSaveMade/sandSaveTotal*100;
}

-(NSString*)sandSavePercentageString:(NSArray*)array
{
	if([self sandSaveTotal:array]==0)
		return @"-";
	else

		return [NSString stringWithFormat:@"%.1f%%",[self sandSavePercentage:array]];
}

@end
