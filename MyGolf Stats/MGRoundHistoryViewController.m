//
//  MGRoundHistoryViewController.m
//  MyGolf Stats
//
//  Created by Todd - Developer on 5/1/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGRoundHistoryViewController.h"
#import "MGRoundDetailTableViewCell.h"
#import "MGHole.h"

@interface MGRoundHistoryViewController ()

@end

@implementation MGRoundHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"App Background"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 320, 45)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    
    UILabel * holeTitle      = [[UILabel alloc]initWithFrame:CGRectMake(6,   12, 36, 21)];
    UILabel * fairwayTitle   = [[UILabel alloc]initWithFrame:CGRectMake(45,  12, 60, 21)];
    UILabel * greenTitle     = [[UILabel alloc]initWithFrame:CGRectMake(106, 12, 47, 21)];
    UILabel * puttsTitle     = [[UILabel alloc]initWithFrame:CGRectMake(159, 12, 41, 21)];
    UILabel * penaltiesTitle = [[UILabel alloc]initWithFrame:CGRectMake(206, 12, 55, 21)];
    UILabel * scoreTitle     = [[UILabel alloc]initWithFrame:CGRectMake(269, 12, 41, 21)];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.holesArrayForRound.count;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
