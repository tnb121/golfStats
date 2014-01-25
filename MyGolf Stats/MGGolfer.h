//
//  MGGolfer.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/15/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>

@interface MGGolfer : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong,nonatomic) NSString * parseID;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * email;
@property (strong,nonatomic) NSString * phoneNumber;
@property (strong,nonatomic) NSNumber * handicap;
@property (strong,nonatomic) NSString * currentRoundID;
@property (strong,nonatomic) PFObject * currentRound;
@end
