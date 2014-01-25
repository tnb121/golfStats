//
//  MGRound.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/10/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>
#import "MGGolfer.h"

@interface MGRound : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong,nonatomic) MGGolfer * golfer;
@property (strong,nonatomic) NSString * user;
@property (strong,nonatomic) NSString * roundID;
@property (strong,nonatomic) NSString * courseName;
@property (strong,nonatomic) NSString * tee;
@property (strong,nonatomic) NSMutableArray * holes;
@property (strong,nonatomic) NSNumber * currentHole;
@property (strong,nonatomic) NSDate * date;
@property (strong,nonatomic) NSNumber * rating;
@property (strong,nonatomic) NSNumber * slope;
@property (strong,nonatomic) NSNumber * score;
@property (strong,nonatomic) NSNumber * differential;
@property (strong,nonatomic) NSNumber * handicap;
@property (strong,nonatomic) PFGeoPoint * location;

@end