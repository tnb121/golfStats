//
//  MGParseSocialIntegration.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 1/16/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGParseSocialIntegration.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation MGParseSocialIntegration

static NSMutableData *imageData = nil;
static NSString * facebookID = nil;

+(void) syncFacebookData
{
    NSString * facebookSyncString = [@"MyGolf Stats Facebook Sync " stringByAppendingString:[PFUser currentUser].username];
    
	if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] && [[NSUserDefaults standardUserDefaults]boolForKey:facebookSyncString] != YES)
	{
		[PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error)
		 {
			 if(error)return;
			 [self getFacebookData];
			 [self getFacebookFriends];
			 [self getFacebookPhoto];

		 }];
	}
	else if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
	{
		[self getFacebookData];
		[self getFacebookFriends];
		[self getFacebookPhoto];
	}
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:facebookSyncString];
}

+(void)syncTwitterData
{
    NSString * twitterSyncString = [@"MyGolf Stats Twitter Sync " stringByAppendingString:[PFUser currentUser].username];
    
	if (![PFTwitterUtils isLinkedWithUser:[PFUser currentUser]] && [[NSUserDefaults standardUserDefaults]boolForKey:twitterSyncString] != YES)
		{
			[PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL succeeded, NSError *error)
				{
					if(error)return;
                      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:twitterSyncString];
            }];
		}
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:twitterSyncString];
}

+(void) getFacebookData
{
	// ...
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];

    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;

			NSLog(@"%@",userData);

            facebookID = userData[@"id"];
				if(facebookID == nil)facebookID = @"(unkown)";
            NSString *name = userData[@"name"];
				if(name == nil)name = @"(unkown)";
            NSString *location = userData[@"location"][@"name"];
				if(location == nil)location = @"(unkown)";
            NSString *gender = userData[@"gender"];
				if(gender == nil)gender = @"(unkown)";
            NSString *birthday = userData[@"birthday"];
				if(birthday == nil)birthday = @"(unkown)";
            NSString *relationship = userData[@"relationship_status"];
			if(relationship == nil)relationship = @"(unkown)";


			PFQuery *query = [PFUser query];
			[query whereKey:@"username" equalTo:[PFUser currentUser].username];
			[query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
			 {
				 if(!error)
				 {
					 PFObject * currentUserObject = [PFQuery getUserObjectWithId:user.objectId];
					 currentUserObject[@"userFacebookID"] = facebookID;
					 currentUserObject[@"userFacebookName"] = name;
					 currentUserObject[@"userFacebookLocation"] = location;
					 currentUserObject[@"userFacebookGender"] = gender;
					 currentUserObject[@"userFacebookBirthday"] = birthday;
					 currentUserObject[@"userFacebookRelationship"] = relationship;
					 [currentUserObject saveInBackground];
				 }
			 }];
        }
		if(error)
		{
			NSLog(@"Error");
			return;
		}
    }];

}

+(void)getFacebookPhoto
{
	if(facebookID==nil)
	{
		FBRequest *request = [FBRequest requestForMe];
		[request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
		{
			if (!error)
			{
				// result is a dictionary with the user's Facebook data
				NSDictionary *userData = (NSDictionary *)result;
				facebookID = userData[@"id"];
				[self facebookURLRequest];
			}
		}];
	}

	else [self facebookURLRequest];
}

+(void)getFacebookFriends
{

	FBRequest* friendsRequest = [FBRequest requestForMyFriends];
	[friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
											  NSDictionary* result,
											  NSError *error)
	{
		if(!error)
		{
		NSArray* friends = [result objectForKey:@"data"];

		PFQuery *query = [PFUser query];
		[query whereKey:@"username" equalTo:[PFUser currentUser].username];
		[query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
			{
				if(!error)
					{
						PFObject * currentUserObject = [PFQuery getUserObjectWithId:user.objectId];
						currentUserObject[@"userFacebookFriends"] = friends;
						[currentUserObject saveInBackground];
					}

				if(error)
					{
						NSLog(@"Error");
					}
			}];
		}
		else return;

	}];
}

//Called to set up URL request to Facebook Graph
+(void)facebookURLRequest
{
	NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

	imageData = [[NSMutableData alloc] init]; // the data will be loaded in here

	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:2.0f];
	(void) [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}


// Called every time a chunk of the data is received
+(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
+(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookPhotoComplete" object:nil];
    
    PFFile *file = [PFFile fileWithName:@"facebookImage.jpg" data:imageData];
	[file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error)
	 {
		 if(!error)
		 {
			 PFQuery *query = [PFUser query];
			 [query whereKey:@"username" equalTo:[PFUser currentUser].username];
			 [query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
			  {
				  if(!error)
				  {
					  PFObject * currentUserObject = [PFQuery getUserObjectWithId:user.objectId];
					  currentUserObject[@"userFacebookPicture"] = file;
					  [currentUserObject saveInBackgroundWithBlock:^(BOOL succeeded,NSError * error)
					   {
						   if(!error)
						   {
							   [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookImageComplete" object:nil];
						   }
					   }];
				  }

				  if(error)
				  {
					  NSLog(@"Error");
					  return;
				  }
			  }];

		 }
	 }];

}

@end
