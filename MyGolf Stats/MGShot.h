//
//  MGShot.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/10/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>

@interface MGShot : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong,nonatomic) NSString * user;
@property (strong,nonatomic) NSString * roundID;
@property (strong,nonatomic) NSString * holeID;
@property (strong,nonatomic) NSString * club;
@property (strong,nonatomic) NSString * fairway;
@property (strong,nonatomic) NSString * green;

@end
