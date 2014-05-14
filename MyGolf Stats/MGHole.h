//
//  MGHole.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/10/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>

@interface MGHole : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong,nonatomic) NSString * parseID;
@property (strong,nonatomic) NSString * roundID;
@property (strong,nonatomic) NSString * course;
@property (strong,nonatomic) NSString * teeColor;
@property (strong,nonatomic) NSDate	  *	holeDate;
@property (strong,nonatomic) NSNumber * holeNumber;
@property (strong,nonatomic) NSNumber * par;
@property (strong,nonatomic) NSNumber * holeHandicap;
@property (strong,nonatomic) NSString * fairway;
@property (strong,nonatomic) NSString * green;
@property (strong,nonatomic) NSNumber * chips;
@property (strong,nonatomic) NSNumber * putts;
@property (strong,nonatomic) NSNumber * penaltyStrokes;
@property (strong,nonatomic) NSNumber * score;
@property (strong,nonatomic) NSString * upAndDown;
@property (strong,nonatomic) NSString * sandSave;
@property (strong,nonatomic) NSMutableArray * shots;
@property (strong,nonatomic) NSNumber * currentShotNumber;
@end
