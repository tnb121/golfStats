//
//  MGParseSocialIntegration.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 1/16/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGParseSocialIntegration : NSObject
{
	UIImage * facebookImage;
}

+(void) syncFacebookData;
+(void) syncTwitterData;

@end
