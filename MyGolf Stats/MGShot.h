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

@property (strong,nonatomic) NSString * parseID;
@property (strong,nonatomic) NSString * roundID;
@property (strong,nonatomic) NSNumber * holeNumber;
@property (strong,nonatomic) NSString * club;
@property (strong,nonatomic) NSString * startingLocation;
@property (strong,nonatomic) NSString * endingLocation;
@property (strong,nonatomic) NSString * target;
@property (strong,nonatomic) NSString * effort;

@end
