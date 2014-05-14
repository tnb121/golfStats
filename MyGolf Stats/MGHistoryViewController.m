//
//  MGHistoryViewController.m
//  MyGolf Stats
//
//  Created by Todd - Developer on 4/19/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGHistoryViewController.h"
#import "MGTotalStats.h"
#import "MGRoundHistoryTableViewController.h"

@interface MGHistoryViewController ()

@property (strong,nonatomic) MGTotalStats * stats;
@property (strong,nonatomic) NSArray * allHolesArray;

@end

@implementation MGHistoryViewController

-(MGTotalStats*)stats
{
	return [MGTotalStats sharedTotalStats];
}

-(NSArray*)allHolesArray
{
	NSArray * array = [[MGTotalStats sharedTotalStats]allHolesArray];
	return array;
}

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
    [self setNeedsStatusBarAppearanceUpdate];
    self.summaryView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"App Background"]];
    
    self.tableViewHeader.layer.borderWidth = 1;
    self.tableViewHeader.layer.borderColor=[UIColor whiteColor].CGColor;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    if ([self.stats fairwaysTotal:self.allHolesArray]==0)
        self.fairwaysPer18Label.text = @"-";
    else
        self.fairwaysPer18Label.text = [NSString stringWithFormat:@"%.1f",[self.stats fairwaysHit:self.allHolesArray]/[self.stats fairwaysTotal:self.allHolesArray]*18];
   
    if ([self.stats greensTotal:self.allHolesArray]==0)
        self.greensPer18Label.text = @"-";
    else
        self.greensPer18Label.text = [NSString stringWithFormat:@"%.1f",[self.stats greensHit:self.allHolesArray]/[self.stats greensTotal:self.allHolesArray]*18];
    
    self.puttsPer18Label.text = [self.stats puttsPer18String:self.allHolesArray];
    self.penaltiesPer18Holes.text = [self.stats penaltyStrokesPer18String:self.allHolesArray];
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
