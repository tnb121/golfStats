//
//  ParseData.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "ParseData.h"
#import "CourseFromParse.h"

@implementation ParseData

@synthesize slopeAverage;
@synthesize scoringAverage;
@synthesize roundCount;
@synthesize roundsFromParse;
@synthesize roundsRecent20FromParse;
@synthesize handicapHistoryFromParse;
@synthesize coursesFromParse;

+ (id)sharedParseData
{
    static ParseData *sharedParseDataManager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParseDataManager = [[self alloc] init];
    });
    return sharedParseDataManager;
}

- (id)init
{
	if (self = [super init])
	{
		slopeAverage = [[NSNumber alloc]init];
		scoringAverage=[[NSNumber alloc]init];
		roundCount = [[NSNumber alloc]init];
		roundsFromParse = [[NSArray alloc]init];
		roundsRecent20FromParse= [[NSArray alloc]init];
		handicapHistoryFromParse= [[NSArray alloc]init];
		coursesFromParse= [[NSArray alloc]init];
	}
	return self;
}

-(void)updateParseRounds
{
	PFQuery *roundQuery = [PFQuery queryWithClassName:@"Rounds"];
	[roundQuery setLimit:(200)];
	[roundQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[roundQuery findObjectsInBackgroundWithBlock:^(NSArray *roundObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");

			roundsFromParse= [roundObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDate" ascending:NO]]];

			roundCount = [NSNumber numberWithInteger:roundObjects.count];
			scoringAverage = [NSNumber numberWithDouble:[[roundObjects valueForKeyPath:@"@avg.roundScore"]doubleValue]];
			slopeAverage= [NSNumber numberWithInteger:[[roundObjects valueForKeyPath:@"@avg.roundSlope"]integerValue]];

			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseRoundsCommunicationComplete" object:nil];
		}
		else NSLog(@"failed");
	}

	 ];
}
-(void)updateParseHandicapHistory
{
	PFQuery *historyQuery = [PFQuery queryWithClassName:@"HandicapHistory"];
	[historyQuery setLimit:(200)];
	[historyQuery whereKey:@"historyUser" equalTo:[PFUser currentUser].username];
	[historyQuery findObjectsInBackgroundWithBlock:^(NSArray *historyObjects,NSError *error)
	 {
		 if(!error)
		 {
			 NSLog(@"Success");
			 NSArray *unsortedArray = historyObjects;


			 NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"historyRoundCount"
														  ascending:NO];
			 NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			 handicapHistoryFromParse= [unsortedArray sortedArrayUsingDescriptors:sortDescriptors];

			 [[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];
		 }
		 else NSLog(@"failed");
	 }];
}




-(void)updateParseRoundsRecent20
{
	PFQuery *round20Query = [PFQuery queryWithClassName:@"Rounds"];
	[round20Query orderByDescending:@"roundDate"];
	[round20Query setLimit:(20)];
	[round20Query whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[round20Query findObjectsInBackgroundWithBlock:^(NSArray *round20Objects,NSError *error)
	 {
		 if(!error)
		 {
			 NSLog(@"Success");
			 roundsRecent20FromParse=[round20Objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDifferential" ascending:NO]]];
			 [[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];

		 }
		 else NSLog(@"failed");
	 }];
}

-(void)updateParseCourses
{
	PFQuery *courseQuery = [PFQuery queryWithClassName:@"Rounds"];
	[courseQuery selectKeys:@[@"roundUser",@"roundCourse",@"roundTee", @"roundRating",@"roundSlope",]];
	[courseQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[courseQuery findObjectsInBackgroundWithBlock:^(NSArray *courseObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");
			NSMutableArray* coursesFromParseNonUnique=[courseObjects mutableCopy];
			NSMutableArray *coursesFromParseUnique=[[NSMutableArray alloc]init];

			int x;
			for (x=1;x<=courseObjects.count;x++)
			{
				NSObject *currentObject = [coursesFromParseNonUnique lastObject];
				if (![coursesFromParseUnique containsObject:currentObject])
				{
					[coursesFromParseUnique addObject:currentObject];
				}
				[coursesFromParseNonUnique removeLastObject];
			}

			coursesFromParse=coursesFromParseUnique;
			//

			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];

		}
		else NSLog(@"failed");
	}];
}



-(NSArray *) uniqueCourseArray
{
	int x;


	NSMutableArray* rawArray = [[self coursesFromParse]mutableCopy];
	NSMutableArray* resultArray = [[NSMutableArray alloc]init];
	NSMutableArray* hashArray = [[NSMutableArray alloc]init];

	for (x=0; x<rawArray.count; x++)
	{
		CourseFromParse *addCourse = [[CourseFromParse alloc]init];

		NSString *courseName = [[rawArray objectAtIndex:x]objectForKey:@"roundCourse"];
		NSString *courseTee = [[rawArray objectAtIndex:x]objectForKey:@"roundTee"];
		NSNumber *slopeValue = [[rawArray objectAtIndex:x]objectForKey:@"roundSlope"];
		NSNumber *ratingValue= [[rawArray objectAtIndex:x]objectForKey:@"roundRating"];

		addCourse.name = courseName;
		addCourse.tee= courseTee;
		addCourse.slope = slopeValue;
		addCourse.rating=ratingValue;

		NSUInteger courseNameHash =[addCourse.name hash];
		NSUInteger teeHash = [addCourse.tee hash];
		NSUInteger ratingHash = [addCourse.rating hash];
		NSUInteger slopeHash = [addCourse.slope hash];

		NSUInteger courseHash = courseNameHash + teeHash + ratingHash + slopeHash;

		NSNumber * courseHashObject = [NSNumber numberWithInteger:courseHash];

		if(![hashArray containsObject:courseHashObject])
		{
			[hashArray addObject:courseHashObject];
			[resultArray addObject:addCourse];
		}
	}

	NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
																	ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSArray * sortedResultArray= [resultArray sortedArrayUsingDescriptors:sortDescriptors];

	return sortedResultArray;
}

-(void) incrementRoundCount
{
	roundCount = [NSNumber numberWithInt: [roundCount intValue]+1];
	NSLog (@"%ld",(long)roundCount.integerValue);
}

-(void)updateAppVersion
{

	PFQuery *query = [PFUser query];
	[query whereKey:@"username" equalTo:[PFUser currentUser].username];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
	 {
		 if(!error)
		 {
			int fullVersion = [[user valueForKey:@"HandicapCalculatorFullVersion"]intValue];

			if (fullVersion ==0)
			{
				[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fullVersion"];
			}
			else if (fullVersion == 1)
			{
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fullVersion"];
			}
			else
			{
				[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fullVersion"];
			}
		 }
	 }];
}


-(void)upgradeToFullVersion
{
	PFQuery *query = [PFUser query];
	[query whereKey:@"username" equalTo:[PFUser currentUser].username];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
	 {
		 if(!error)
		 {
			 PFObject * currentUserObject = [PFQuery getUserObjectWithId:user.objectId];
			 [currentUserObject setObject:[NSNumber numberWithBool:YES] forKey:@"HandicapCalculatorFullVersion"];
			 [currentUserObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
			   {
				   if(!error) [self updateAppVersion];
				   [FBAppEvents logPurchase:[_product.price doubleValue] currency:@"USD"];
			   }];

		 }
	 }];
}
// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
										  initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.product =[response.products objectAtIndex:0];
	NSLog(@"%@",self.product.price);
	[self UpgradePrice];
}

-(NSString *)UpgradePrice
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:_product.priceLocale];
	NSString *formattedPrice = [numberFormatter stringFromNumber:_product.price];
	return formattedPrice;
}





@end
