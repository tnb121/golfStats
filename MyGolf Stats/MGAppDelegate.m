//
//  MGAppDelegate.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 12/10/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "MGAppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <StoreKit/StoreKit.h>
#import "MGGolfer.h"
#import "MGRound.h"
#import "MGHole.h"
#import "MGShot.h"
#import "MGCurrentRound.h"
#import "MGCurrentHole.h"
#import "Clubs.h"

@implementation MGAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	[MGGolfer registerSubclass];
  //  [MGRound registerSubclass];
	[MGHole registerSubclass];
	[MGShot registerSubclass];
	[MGCurrentRound registerSubclass];

	
	
	[Parse setApplicationId:@"dOEY4AHocmPKtur5RU0oCyz1ygKkiG2MIG7F9tai"
				  clientKey:@"CH1nW38EnKKWZNdoOV6VnjhrLEn0egI6OLu6g7xX"];
    [FBSettings setDefaultAppID:@"687443174650965"];
	[PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"PnlxuwDRcgdmOggzeea0A" consumerSecret:@"VUSzqyrtDD4bwu840jFIIRXMDqd6fyUnrswy5EAiXws"];

	//[self setUpGolfBag];

	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

	[application registerForRemoteNotificationTypes:
	 UIRemoteNotificationTypeBadge |
	 UIRemoteNotificationTypeAlert |
	 UIRemoteNotificationTypeSound];

	UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    [tabController setSelectedIndex:0];

	if(![[NSUserDefaults standardUserDefaults] objectForKey:@"shotTracking"])

		[[NSUserDefaults standardUserDefaults]setObject:@"hole" forKey:@"shotTracking"];

	return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}


- (BOOL)aapplication:(UIApplication *)application
			 openURL:(NSURL *)url
   sourceApplication:(NSString *)sourceApplication
		  annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
	[FBSettings setDefaultAppID:@"687443174650965"];
	[FBAppEvents activateApp];
}
 

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

- (NSManagedObjectContext *) managedObjectContext {
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		_managedObjectContext = [[NSManagedObjectContext alloc] init];
		[_managedObjectContext setPersistentStoreCoordinator: coordinator];
	}

	return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

	return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
											   stringByAppendingPathComponent: @"PhoneBook.sqlite"]];
	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								   initWithManagedObjectModel:[self managedObjectModel]];
	if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												  configuration:nil URL:storeUrl options:nil error:&error]) {
		/*Error for store creation should be handled in here*/
	}

	return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(void)setUpGolfBag
{
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Clubs" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"distanceRank" ascending:YES];
	[request setSortDescriptors:@[sortDescriptor]];

	NSError *error;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	NSArray * clubsArray =@[@"Driver",@"3-Wood",@"5-Wood",@"7-Wood",@"2-Iron",@"3-Iron",@"4-Iron",@"5-Iron",@"6-Iron",@"7-Iron",@"8-Iron",@"9-Iron",@"Pitching Wedge",@"Gap Wedge",@"Approach Wedge",@"Sand Wedge",@"Lob Wedge",@"Other Wedge"];

	NSInteger x = 1;
	if(array.count ==0)
	{
		for (x=1; x<= clubsArray.count; x++)
		{
			{
				NSManagedObject *failedBankInfo = [NSEntityDescription
												   insertNewObjectForEntityForName:@"Clubs"
												   inManagedObjectContext:moc];
				[failedBankInfo setValue:[clubsArray objectAtIndex:x-1] forKey:@"club"];
				[failedBankInfo setValue:[NSNumber numberWithBool:YES] forKey:@"inBag"];
				[failedBankInfo setValue:[NSNumber numberWithInteger:x] forKey:@"distanceRank"];

				NSError *error;
				[moc save:&error];
			}
		}
	}

}







@end
