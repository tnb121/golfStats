//
//  MGClubTableViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/9/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MGClubCell.h"

@interface MGClubTableViewController : UITableViewController<UITabBarControllerDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)NSArray * clubArray;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
