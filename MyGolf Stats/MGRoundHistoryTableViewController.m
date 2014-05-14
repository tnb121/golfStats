//
//  MGRoundHistoryTableViewController.m
//  MyGolf Stats
//
//  Created by Todd - Developer on 5/1/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGRoundHistoryTableViewController.h"
#import "MGRoundDetailTableViewCell.h"
#import "MGHole.h"

@interface MGRoundHistoryTableViewController ()

@end

@implementation MGRoundHistoryTableViewController

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
    
    [self.navigationController setNavigationBarHidden:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    /*
    if(self.holesArrayForRound.count == 18)
        return 2;
    else
        return 1;
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.holesArrayForRound.count;
    /*
    switch (section)
    {
        case 0:
            if(self.holesArrayForRound.count >= 9)
                return 9;
            break;
            
        case 1:
            return self.holesArrayForRound.count - 9;
            break;
            
        default:
            return 0;
            break;
    }
     */
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 320, 35)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    
    UILabel * holeTitle      = [[UILabel alloc]initWithFrame:CGRectMake(6,   7, 36, 21)];
    UILabel * fairwayTitle   = [[UILabel alloc]initWithFrame:CGRectMake(45,  7, 60, 21)];
    UILabel * greenTitle     = [[UILabel alloc]initWithFrame:CGRectMake(106, 7, 47, 21)];
    UILabel * puttsTitle     = [[UILabel alloc]initWithFrame:CGRectMake(159, 7, 41, 21)];
    UILabel * penaltiesTitle = [[UILabel alloc]initWithFrame:CGRectMake(206, 7, 55, 21)];
    UILabel * scoreTitle     = [[UILabel alloc]initWithFrame:CGRectMake(269, 7, 41, 21)];
    
    holeTitle.text      = @"Hole";
    fairwayTitle.text   = @"Fairway";
    greenTitle.text     = @"Green";
    puttsTitle.text     = @"Putts";
    penaltiesTitle.text = @"Pen Str";
    scoreTitle.text     = @"Score";
    
    holeTitle.font      = [UIFont boldSystemFontOfSize:15.0];
    fairwayTitle.font   = [UIFont boldSystemFontOfSize:15.0];
    greenTitle.font     = [UIFont boldSystemFontOfSize:15.0];
    puttsTitle.font     = [UIFont boldSystemFontOfSize:15.0];
    penaltiesTitle.font = [UIFont boldSystemFontOfSize:15.0];
    scoreTitle.font     = [UIFont boldSystemFontOfSize:15.0];
    
    holeTitle.textColor      = [UIColor whiteColor];
    fairwayTitle.textColor   = [UIColor whiteColor];
    greenTitle.textColor     = [UIColor whiteColor];
    puttsTitle.textColor     = [UIColor whiteColor];
    penaltiesTitle.textColor = [UIColor whiteColor];
    scoreTitle.textColor     = [UIColor whiteColor];
    
    [headerView addSubview:holeTitle];
    [headerView addSubview:fairwayTitle];
    [headerView addSubview:greenTitle];
    [headerView addSubview:puttsTitle];
    [headerView addSubview:penaltiesTitle];
    [headerView addSubview:scoreTitle];
    
    return headerView;
}
/*
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray * holesForSectionArray = [[NSArray alloc]init];
    
    switch (section)
    {
        case 0:
            holesForSectionArray = [self.holesArrayForRound subarrayWithRange:NSMakeRange(0, 9)];
            break;
        case 1:
            holesForSectionArray = [self.holesArrayForRound subarrayWithRange:NSMakeRange(10, 9)];
            break;
        default:
            break;
    }
    
    
    UIView * footerView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 320, 35)];
    footerView .backgroundColor = [UIColor darkGrayColor];
    
    UILabel * holeTitle      = [[UILabel alloc]initWithFrame:CGRectMake(6,   7, 36, 21)];
    UILabel * fairwayTitle   = [[UILabel alloc]initWithFrame:CGRectMake(45,  7, 60, 21)];
    UILabel * greenTitle     = [[UILabel alloc]initWithFrame:CGRectMake(106, 7, 47, 21)];
    UILabel * puttsTitle     = [[UILabel alloc]initWithFrame:CGRectMake(159, 7, 41, 21)];
    UILabel * penaltiesTitle = [[UILabel alloc]initWithFrame:CGRectMake(206, 7, 55, 21)];
    UILabel * scoreTitle     = [[UILabel alloc]initWithFrame:CGRectMake(269, 7, 41, 21)];
    
    holeTitle.text      = @"Hole";
    fairwayTitle.text   = @"Fairway";
    greenTitle.text     = @"Green";
    puttsTitle.text     = @"Putts";
    penaltiesTitle.text = @"Pen Str";
    scoreTitle.text     = @"Score";
    
    holeTitle.font      = [UIFont boldSystemFontOfSize:15.0];
    fairwayTitle.font   = [UIFont boldSystemFontOfSize:15.0];
    greenTitle.font     = [UIFont boldSystemFontOfSize:15.0];
    puttsTitle.font     = [UIFont boldSystemFontOfSize:15.0];
    penaltiesTitle.font = [UIFont boldSystemFontOfSize:15.0];
    scoreTitle.font     = [UIFont boldSystemFontOfSize:15.0];
    
    holeTitle.textColor      = [UIColor whiteColor];
    fairwayTitle.textColor   = [UIColor whiteColor];
    greenTitle.textColor     = [UIColor whiteColor];
    puttsTitle.textColor     = [UIColor whiteColor];
    penaltiesTitle.textColor = [UIColor whiteColor];
    scoreTitle.textColor     = [UIColor whiteColor];
    
    [footerView  addSubview:holeTitle];
    [footerView  addSubview:fairwayTitle];
    [footerView  addSubview:greenTitle];
    [footerView  addSubview:puttsTitle];
    [footerView  addSubview:penaltiesTitle];
    [footerView  addSubview:scoreTitle];
    
    return headerView;
    
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGRoundDetailTableViewCell* cell  = [tableView dequeueReusableCellWithIdentifier:@"roundDetailCell" forIndexPath:indexPath];
    
	if (cell == nil)
    {
        cell = [[MGRoundDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"roundDetailCell"];
    }
    
    MGHole * currentHole =[self.holesArrayForRound objectAtIndex:indexPath.row];
    
    cell.holeLabel.text = [self stringFilter:[NSString stringWithFormat:@"%@",[currentHole valueForKey:@"holeNumber"]]];
    cell.fairwayLabel.text = [self stringFilter:[NSString stringWithFormat:@"%@",[currentHole valueForKey:@"fairway"]]];
    cell.greenLabel.text = [self stringFilter:[NSString stringWithFormat:@"%@",[currentHole valueForKey:@"green"]]];
    cell.puttsLabel.text = [self stringFilter:[NSString stringWithFormat:@"%@",[currentHole valueForKey:@"putts"]]];
    cell.penaltiesLabel.text = [self stringFilter:[NSString stringWithFormat:@"%@",[currentHole valueForKey:@"penaltyStrokes"]]];
    cell.scoreLabel.text = [self stringFilter:[NSString stringWithFormat:@"%@",[currentHole valueForKey:@"score"]]];
    
    return cell;
}
-(NSString*)stringFilter:(NSString *)string
{
    if ([string isEqualToString:@"(null)"])
        return @" - ";
    
    else if ([string isEqualToString:@"fairwayHit"]  || [string isEqualToString:@"greenHit"]  )
        return @"Hit";
    else if ([string isEqualToString:@"fairwayLeft"] || [string isEqualToString:@"greenLeft"])
        return @"Left";
    else if ([string isEqualToString:@"fairwayRight"]|| [string isEqualToString:@"greenRight"])
        return @"Right";
    else if ([string isEqualToString:@"fairwayShort"]|| [string isEqualToString:@"greenShort"])
        return @"Short";
    else if ([string isEqualToString:@"fairwayLong"] || [string isEqualToString:@"greenLong"])
        return @"Long";
    
    else return string;
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
