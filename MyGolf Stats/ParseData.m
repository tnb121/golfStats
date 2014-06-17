//
//  ParseData.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "ParseData.h"
#import "CourseFromParse.h"
#import "Handicap.h"
#import "MGRound.h"
#import "MGCurrentRound.h"

@interface ParseData()
@property (strong,nonatomic) Handicap * handicapClass;
@end


@implementation ParseData

@synthesize slopeAverage;
@synthesize scoringAverage;
@synthesize roundCount;
@synthesize roundCountWithHoleData;
@synthesize roundsFromParse;
@synthesize roundsFromParseForHandicap;
@synthesize holesFromParse;
@synthesize shotsFromParse;
@synthesize roundsRecent20FromParse;
@synthesize coursesFromParse;
@synthesize coursesFromParseWithHoles;
@synthesize uniqueCourseArray;

@synthesize Last5RoundsDate;
@synthesize Last10RoundsDate;
@synthesize Last15RoundsDate;
@synthesize Last20RoundsDate;

@synthesize updatedDataNeeded;

@dynamic handicapClass;
NSInteger x;


-(Handicap*)handicapClass
{
    return [Handicap sharedHandicap];
}

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
        roundsFromParseForHandicap = [[NSArray alloc]init];
		roundsRecent20FromParse= [[NSArray alloc]init];
		coursesFromParse= [[NSArray alloc]init];
	}
	return self;
}

-(void)updateParseRounds
{
	PFQuery *roundQuery = [PFQuery queryWithClassName:@"Rounds"];
	[roundQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[roundQuery includeKey:@"roundHoles"];
	[roundQuery findObjectsInBackgroundWithBlock:^(NSArray*roundObjects,NSError *error){
		if(!error)
		{
			NSLog(@"ParseRounds");
            
            // Divide 9 Hole Rounds and 18 Hole Rounds
            NSPredicate * nineHoleRoundPredicate = [NSPredicate predicateWithFormat:@"roundLength = 9"];
            NSPredicate * eighteenHoleRoundPredicate = [NSPredicate predicateWithFormat:@"roundLength != 9"];
            
            NSMutableArray * nineHoleArray = [[roundObjects filteredArrayUsingPredicate:nineHoleRoundPredicate]mutableCopy];
            
            NSMutableArray * nineHoleArray2 = [[[nineHoleArray filteredArrayUsingPredicate:nineHoleRoundPredicate] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDate" ascending:NO]]]mutableCopy];
            
            NSMutableArray * eighteenHoleArray = [[roundObjects filteredArrayUsingPredicate:eighteenHoleRoundPredicate]mutableCopy];
            
            // Add combined 9 holes rounds to array for handicap calculation
            NSInteger nineHoleArrayCount = nineHoleArray2.count;
            NSInteger count = 0;
            
            for (count = nineHoleArrayCount; count >=2; count=count)
            {
                count = nineHoleArray2.count;
                
                MGRound * round1 = [nineHoleArray2 objectAtIndex:count - 2];
                MGRound * round2 = [nineHoleArray2 objectAtIndex:count - 1];
                
                PFObject *  new18HoleRound= [self.handicapClass combine9HoleRounds:round1 withRound:round2];
                [eighteenHoleArray addObject:new18HoleRound];
                [nineHoleArray2 removeObjectAtIndex:count-1];
                [nineHoleArray2 removeObjectAtIndex:count-2];
                count = nineHoleArray2.count;
            }
            
            NSArray * eighteenHoleArray2 = [eighteenHoleArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDate" ascending:NO]]];
            
        // determine if there are 20 rounds
            NSInteger length;
            if (eighteenHoleArray2.count <20)
                length = eighteenHoleArray2.count;
            else
                length = 20;
            
        // Create predicate for round count of MyGolf Stats rounds
            NSPredicate *roundsWithHoleData = [NSPredicate predicateWithFormat:@"roundHoles != nil"];
            
        // Set singleton values
            roundsFromParseForHandicap  = [eighteenHoleArray2 subarrayWithRange:NSMakeRange(0, length)];
			roundsFromParse             = [roundObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDate" ascending:NO]]];
			roundCount                  = [NSNumber numberWithDouble:roundObjects.count];
			scoringAverage              = [NSNumber numberWithDouble:[[roundObjects valueForKeyPath:@"@avg.roundScore"]doubleValue]];
			slopeAverage                = [NSNumber numberWithInteger:[[roundObjects valueForKeyPath:@"@avg.roundSlope"]integerValue]];
            
            NSArray * roundsWithHoles = [roundsFromParse filteredArrayUsingPredicate:roundsWithHoleData];
            
            roundCountWithHoleData = [NSNumber numberWithInteger:roundsWithHoles.count];
            
            

        // Post notifications for data updates
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseRoundsUpdated" object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];

        // Determine cutoffs for date ranges
			if(roundsFromParse.count >=5)
				self.Last5RoundsDate =[[roundsFromParse objectAtIndex:4]valueForKey:@"roundDate"];
			NSLog(@"%@",self.Last5RoundsDate);
			NSLog(@"%@",[NSDate date]);
			if(roundsFromParse.count >=10)
				self.Last10RoundsDate =[[roundsFromParse objectAtIndex:9]valueForKey:@"roundDate"];
			if(roundsFromParse.count >=15)
				self.Last15RoundsDate =[[roundsFromParse objectAtIndex:14]valueForKey:@"roundDate"];
			if(roundsFromParse.count >=20)
				self.Last20RoundsDate =[[roundsFromParse objectAtIndex:19]valueForKey:@"roundDate"];
		}
		else NSLog(@"failed");
	}

	 ];
}

-(NSNumber*)roundCountMethod
{
	return [NSNumber numberWithInteger:self.roundsFromParse.count];
}

-(void)updateParseHoles
{
	PFQuery *holeQuery = [PFQuery queryWithClassName:@"MGHole"];
	[holeQuery whereKey:@"parseID" equalTo:[PFUser currentUser].username];
	[holeQuery whereKey:@"par" greaterThan:[NSNumber numberWithInt:0]];
	[holeQuery setLimit:10000];
	[holeQuery findObjectsInBackgroundWithBlock:^(NSArray*holeObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Parse Holes Updated");
			holesFromParse= holeObjects;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseHolesUpdated" object:nil];

			NSInteger count = holesFromParse.count;
			NSInteger i = 0;

			NSMutableArray * parseCoursesWithHolesMutableArray = [[NSMutableArray alloc]init];

			for (i=0;i<count;i++)
			{
				NSString * course = [[holesFromParse objectAtIndex:i]valueForKey:@"course"];
				if(![parseCoursesWithHolesMutableArray containsObject:course] && course !=nil)
					[parseCoursesWithHolesMutableArray addObject:course];
			}
			coursesFromParseWithHoles=[[parseCoursesWithHolesMutableArray copy] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
		}
		else NSLog(@"failed");
	}
	 ];
}

-(void)updateParseShots
{
	PFQuery *holeQuery = [PFQuery queryWithClassName:@"MGShot"];
	[holeQuery whereKey:@"parseID" equalTo:[PFUser currentUser].username];
	[holeQuery setLimit:10000];
	[holeQuery findObjectsInBackgroundWithBlock:^(NSArray*shotObjects,NSError *error){
		if(!error)
		{
			NSLog(@"ParseShots");
			shotsFromParse= shotObjects;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseShotsUpdated" object:nil];

		}
		else NSLog(@"failed");
	}
	 ];
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
			 NSLog(@"ParseRecent20");
			 roundsRecent20FromParse=[round20Objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDifferential" ascending:NO]]];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];

		 }
		 else NSLog(@"failed");
	 }];
}

-(void)updateParseCourses
{
	PFQuery *courseQuery = [PFQuery queryWithClassName:@"Rounds"];
	[courseQuery selectKeys:@[@"roundUser",@"roundCourse",@"roundTee", @"roundRating",@"roundSlope",@"roundHoles"]];

	[courseQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[courseQuery findObjectsInBackgroundWithBlock:^(NSArray *courseObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");
			NSMutableArray* coursesFromParseNonUnique=[courseObjects mutableCopy];
			NSMutableArray *coursesFromParseUnique=[[NSMutableArray alloc]init];

			NSInteger x;
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
/*
			NSInteger count = coursesFromParse.count;
			NSInteger i = 0;
			NSMutableArray * parseCoursesWithHolesMutableArray = [[NSMutableArray alloc]init];

			for (i=0;i<count;i++)
			{
				NSString * holeArray = [[courseObjects objectAtIndex:i]valueForKey:@"roundHoles"];
				if(holeArray)
					[parseCoursesWithHolesMutableArray addObject:[coursesFromParse objectAtIndex:i]];
			}
			//

			//[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];
*/
		}
		else NSLog(@"failed");
	}];
}

-(void)updateParseCoursesWithHoles
{
	PFQuery *courseQuery = [PFQuery queryWithClassName:@"Rounds"];
	[courseQuery selectKeys:@[@"roundUser",@"roundCourse",@"roundTee", @"roundRating",@"roundSlope",@"roundHoles"]];
	[courseQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[courseQuery whereKey:@"roundHoles" greaterThan:NULL];
	[courseQuery findObjectsInBackgroundWithBlock:^(NSArray *courseObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Courses From Parse With Holes Updated");
			coursesFromParse=courseObjects;
		}
		else NSLog(@"failed");
	}];
}




-(NSArray *) uniqueCourseArray
{
	NSInteger x;


	NSMutableArray* rawArray = [self.coursesFromParse mutableCopy];
	NSMutableArray* resultArray = [[NSMutableArray alloc]init];
	NSMutableArray* hashArray = [[NSMutableArray alloc]init];

	NSInteger test = rawArray.count;
	if(test > 0)


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

	//[[NSNotificationCenter defaultCenter] postNotificationName:@"UniqueCourseArrayComplete" object:nil];

	return sortedResultArray;
}

-(NSArray *) uniqueCourseArrayWithHoles
{
	NSInteger x;


	NSMutableArray* rawArray = [self.coursesFromParseWithHoles mutableCopy];
	NSMutableArray* resultArray = [[NSMutableArray alloc]init];
	NSMutableArray* hashArray = [[NSMutableArray alloc]init];

	NSInteger test = rawArray.count;
	if(test > 0)


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

	//[[NSNotificationCenter defaultCenter] postNotificationName:@"UniqueCourseArrayComplete" object:nil];

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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllParseUpdatesComplete" object:nil];
			
            NSInteger fullVersion = [[user valueForKey:@"MyGolfStatsFullVersion"]intValue];

			if (fullVersion ==0)
			{
				[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MyGolfStatsFullVersion"];
			}
			else if (fullVersion == 1)
			{
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MyGolfStatsFullVersion"];
                if(!error)
                {
                    PFObject * currentUserObject = [PFQuery getUserObjectWithId:user.objectId];
                    [currentUserObject setObject:[NSNumber numberWithBool:YES] forKey:@"HandicapCalculatorFullVersion"];
                    [currentUserObject setObject:[NSNumber numberWithBool:YES] forKey:@"MyGolfStatsFullVersion"];
                    [currentUserObject saveInBackground];
                }

            }
			else
			{
				[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MyGolfStatsFullVersion"];
			}
		 }
         if(error)
         {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"AllParseUpdatesComplete" object:nil];
             return;
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
             [currentUserObject setObject:[NSNumber numberWithBool:YES] forKey:@"MyGolfStatsFullVersion"];
			 [currentUserObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
			   {
				   if(!error) [self updateAppVersion];
				   [FBAppEvents logPurchase:[_product.price doubleValue] currency:@"USD"];
                    if(error)return;
			   }];

		 }
         if(error)return;
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
