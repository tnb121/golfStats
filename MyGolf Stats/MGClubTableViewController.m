//
//  MGClubTableViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/9/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGClubTableViewController.h"
#import "MGAppDelegate.h"
#import "Clubs.h"

@interface MGClubTableViewController ()

@end

@implementation MGClubTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize clubArray=_clubArray;
@synthesize fetchedResultsController=_fetchedResultsController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
    
    [self.navigationController setNavigationBarHidden:NO];

	self.managedObjectContext = [(MGAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];

	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id  sectionInfo =
	[[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"clubCell";
	MGClubCell *cell = (MGClubCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	Clubs *club = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.clubLabel.text = club.club;

	BOOL inBag = [club.inBag boolValue];

	if (inBag == YES)
	{
		cell.accessoryType=UITableViewCellAccessoryCheckmark;
	}
	else cell.accessoryType=UITableViewCellAccessoryNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Clubs *club = [_fetchedResultsController objectAtIndexPath:indexPath];
	BOOL inBag = [club.inBag boolValue];
	if (inBag == YES)
	{
		club.inBag = [NSNumber numberWithBool:NO];
		NSError *error = nil;
		[self.managedObjectContext save:&error];
		[self.tableView reloadData];
	}
	else
	{
		club.inBag = [NSNumber numberWithBool:YES];
		NSError *error = nil;
		[self.managedObjectContext save:&error];
		[self.tableView reloadData];
	}
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



-(NSArray*)fetchClubs
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
if (array == nil)
{
    // Deal with error...
}
	return array;
}
  */

- (NSFetchedResultsController *)fetchedResultsController {

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
								   entityForName:@"Clubs" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
							  initWithKey:@"distanceRank" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    NSFetchedResultsController *theFetchedResultsController =
	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
										managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
												   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;

    return _fetchedResultsController;

}

















@end
