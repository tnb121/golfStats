//
//  MGCurrentRound.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/22/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGCurrentRound.h"
#import "MGHole.h"
#import <Parse/PFObject+Subclass.h>

int x;

@implementation MGCurrentRound

+ (id)sharedCurrentRound
{
    static MGRound *sharedCurrentRound= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCurrentRound= [[self alloc] init];
    });
    return sharedCurrentRound;
}
+ (NSString *)parseClassName {
	return @"MGRound";
}

- (id)init
{
	if (self = [super init])
	{
		self.golfer = [[MGGolfer alloc]init];
		self.user=[[NSString alloc]init];
		self.roundID = [[NSString alloc]init];
		self.courseName = [[NSString alloc]init];
		self.holes= [[NSMutableArray alloc]init];
		self.currentHole= [[NSNumber alloc]init];
		self.date= [[NSDate alloc]init];
		self.rating = [[NSNumber alloc]init];
		self.slope = [[NSNumber alloc]init];
		self.score = [[NSNumber alloc]init];
		self.differential = [[NSNumber alloc]init];
		self.handicap = [[NSNumber alloc]init];
		self.tee = [[NSString alloc]init];
		self.location = [[PFGeoPoint alloc]init];
		[self createHoleArray];
	}
	return self;
}

-(void)createCurrentRound
{
	PFObject *roundObject = [PFObject objectWithClassName:@"Rounds"];
	roundObject[@"roundUser"] = @"tnb121";
	
	[roundObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	 {
		 if(!error)
		 {
			 self.golfer = nil;
			 self.user=nil;
			 self.roundID=roundObject.objectId;
			 self.courseName = nil;
			 self.holes= nil;
			 self.currentHole= nil;
			 self.date= nil;
			 self.rating = nil;
			 self.slope = nil;
			 self.score = nil;
			 self.differential = nil;
			 self.handicap = nil;
			 self.tee = nil;
			 [self createHoleArray];
		 }
	 }];
}
-(void)saveRound
{
	if (self.roundID==(id)[NSNull null]) return;

	PFQuery * query = [PFQuery queryWithClassName:@"Rounds"];
	[query getObjectInBackgroundWithId:self.roundID block:^(PFObject * roundObject,NSError * error)
		{

			roundObject[@"roundUser"] =self.golfer;
			roundObject[@"roundUser"] = @"tnb121";
			//roundObject[@"roundUser"] = [PFUser currentUser].username;
			roundObject[@"roundCourse"] = self.courseName;
			roundObject[@"roundTee"] =self.tee;
			roundObject[@"holes"]=self.holes;
			roundObject[@"currentHole"]=self.currentHole;
			roundObject[@"roundDate"] = self.date;
			roundObject[@"roundRating"] = self.rating;
			roundObject[@"roundSlope"] = self.slope;
			roundObject[@"roundScore"]=self.score;
			roundObject[@"roundDifferential"]=self.differential;
			roundObject[@"roundLocation"]=self.location;

			[roundObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
			 {
				 if(!error)
					{
						NSLog (@"Saved");
					}
			 }];
	}];

}

-(void) createHoleArray
{
	self.holes = [[NSMutableArray alloc]init];

	for (x=1; x<19; x++)
	{
		MGHole * newhole = [MGHole object];
		[self.holes addObject:newhole];
		newhole.holeNumber=[NSNumber numberWithInt:x];
		newhole.roundID=self.roundID;
	}
}


@end
