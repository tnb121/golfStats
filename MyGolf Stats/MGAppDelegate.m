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
#import "MGGolfer.h"
#import "MGRound.h"
#import "MGHole.h"
#import "MGShot.h"
#import "MGCurrentRound.h"
#import "MGCurrentHole.h"

@implementation MGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    [tabController setSelectedIndex:0];


	[MGGolfer registerSubclass];
	[MGRound registerSubclass];
	[MGHole registerSubclass];
	[MGShot registerSubclass];
	[MGCurrentRound registerSubclass];
	[MGCurrentHole registerSubclass];

	[Parse setApplicationId:@"dOEY4AHocmPKtur5RU0oCyz1ygKkiG2MIG7F9tai"
				  clientKey:@"CH1nW38EnKKWZNdoOV6VnjhrLEn0egI6OLu6g7xX"];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	//[PFFacebookUtils initializeFacebook];
	//[PFTwitterUtils initializeWithConsumerKey:@"PnlxuwDRcgdmOggzeea0A" consumerSecret:@"VUSzqyrtDD4bwu840jFIIRXMDqd6fyUnrswy5EAiXws"];

	[application registerForRemoteNotificationTypes:
	 UIRemoteNotificationTypeBadge |
	 UIRemoteNotificationTypeAlert |
	 UIRemoteNotificationTypeSound];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
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
    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
	//[FBSettings setDefaultAppID:@"com.mygolfinsight.mygolfhandicap"];
	//[FBAppEvents activateApp];
}
 

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
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
}@end
