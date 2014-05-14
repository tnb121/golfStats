//
//  Clubs.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/9/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Clubs : NSManagedObject

@property (nonatomic, retain) NSString * club;
@property (nonatomic, retain) NSNumber * inBag;
@property (nonatomic, retain) NSNumber * distanceRank;

@end
