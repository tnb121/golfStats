//
//  MGHistoryTableTableViewController.m
//  MyGolf Stats
//
//  Created by Todd - Developer on 4/19/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGHistoryTableTableViewController.h"
#import "ParseData.h"
#import "MGRoundHistoryCellTableViewCell.h"
#import "MGRoundStats.h"
#import "MGRoundHistoryTableViewController.h"

@interface MGHistoryTableTableViewController ()

@property (strong,nonatomic) ParseData * parseData;
@property (strong,nonatomic) MGRoundStats *roundStats;
@property (strong,nonatomic) NSArray * roundsArray;

@end

@implementation MGHistoryTableTableViewController

@synthesize parseData;

-(ParseData*)parseData
{
	return [ParseData sharedParseData];
}

-(MGRoundStats*)roundStats
{
    return [MGRoundStats sharedRoundStats];
}

-(NSArray *)roundsArray
{
    return self.parseData.roundsFromParse;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.roundHistoryTableView.delegate = self;
    self.roundHistoryTableView.dataSource=self;
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveHolesArray) name:@"ParseRoundsUpdated"  object:nil];
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
    NSInteger count = self.roundsArray.count;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGRoundHistoryCellTableViewCell * cell  = [self.roundHistoryTableView dequeueReusableCellWithIdentifier:@"roundHistoryCell" forIndexPath:indexPath];

	if (cell == nil)
    {
        cell = [[MGRoundHistoryCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"roundHistoryCell"];
    }
    
    NSArray * roundArray =[[self.roundsArray objectAtIndex:indexPath.row] valueForKeyPath:@"roundHoles"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    NSString *dateString = [dateFormatter stringFromDate:[[self.roundsArray objectAtIndex:indexPath.row] valueForKeyPath:@"roundDate"]];
    if(roundArray.count==0)
    {
        cell.roundHistoryDate.text = dateString;
        cell.roundHistoryFairway.text = @"-";
        cell.roundHistoryGreens.text = @"-";
        cell.roundHistoryPutts.text = @"-";
        cell.roundHistoryScore.text = [NSString stringWithFormat:@"%@",[[self.roundsArray objectAtIndex:indexPath.row] valueForKeyPath:@"roundScore"]];
        return cell;
    }

    
    cell.roundHistoryDate.text = dateString;
    cell.roundHistoryFairway.text = [self.roundStats historyFairwaysHit:roundArray];
    cell.roundHistoryGreens.text = [self.roundStats historyGreensHit:roundArray];
    cell.roundHistoryPutts.text = [NSString stringWithFormat:@"%ld",(long)[self.roundStats puttsTotal:roundArray]];
    cell.roundHistoryScore.text = [NSString stringWithFormat:@"%ld",(long)[self.roundStats scoreTotal:roundArray]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
	if ([[segue identifier] isEqualToString:@"roundDetailSegue"])
	{
		NSIndexPath *indexPath = [self.roundHistoryTableView    indexPathForSelectedRow];
        MGRoundHistoryTableViewController*detailVC = segue.destinationViewController;
        NSArray * holesArray =[[self.roundsArray objectAtIndex:indexPath.row] valueForKeyPath:@"roundHoles"];
		detailVC.holesArrayForRound = holesArray;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        detailVC.roundDate= [dateFormatter stringFromDate:[[self.roundsArray objectAtIndex:indexPath.row] valueForKeyPath:@"roundDate"]];
        detailVC.roundScore= [NSString stringWithFormat:@"%ld",(long)[self.roundStats scoreTotal:holesArray]];
	}
    
	NSLog(@"Unknown segue: %@", [segue identifier]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
