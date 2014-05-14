//
//  MGStatsContainerViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 3/8/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGStatsContainerViewController.h"
#import "MGCurrentRound.h"
#import "MGHomeViewController.h"

@interface MGStatsContainerViewController ()

@end

@implementation MGStatsContainerViewController

-(MGRoundStats*)stats
{
	return [MGRoundStats sharedRoundStats];
}

-(MGCurrentRound*)currentRound
{
    if(!_currentRound)
        return [MGCurrentRound sharedCurrentRound];
    else return _currentRound;
}


-(void)setStats
{
	self.fairwaysHit.text = [NSString stringWithFormat:@"%ld",(long)[self.stats fairwaysHit:self.currentRound.holes]];
	self.fairwayTotal.text = [NSString stringWithFormat:@"%ld",(long)[self.stats fairwaysTotal:self.currentRound.holes]];

	self.greensHit.text = [NSString stringWithFormat:@"%ld",(long)[self.stats greensHit:self.currentRound.holes]];
	self.greenTotal.text = [NSString stringWithFormat:@"%ld",(long)[self.stats greensTotal:self.currentRound.holes]];

	self.upAndDownMade.text = [NSString stringWithFormat:@"%ld",(long)[self.stats upAndDownMade:self.currentRound.holes]];
	self.upAndDownTotal.text = [NSString stringWithFormat:@"%ld",(long)[self.stats upAndDownTotal:self.currentRound.holes]];

	self.sandSaveMade.text = [NSString stringWithFormat:@"%ld",(long)[self.stats sandSaveMade:self.currentRound.holes]];
	self.SandSaveTotal.text = [NSString stringWithFormat:@"%ld",(long)[self.stats sandSaveTotal:self.currentRound.holes]];

	self.scoreTotal.text = [NSString stringWithFormat:@"%ld",(long)[self.stats scoreTotal:self.currentRound.holes]];
	self.puttsTotal.text = [NSString stringWithFormat:@"%ld",(long)[self.stats puttsTotal:self.currentRound.holes]];
	self.penaltyStrokesTotal.text = [NSString stringWithFormat:@"%ld",(long)[self.stats penaltyStrokesTotal:self.currentRound.holes]];
    
    self.currentRound.score = [NSNumber numberWithInteger:[self.stats scoreTotal:self.currentRound.holes]];

	NSInteger currentHoleNumber=[[[MGCurrentRound sharedCurrentRound]currentHole]intValue] ;
	self.activeHoleObject = [[[MGCurrentRound sharedCurrentRound]holes] objectAtIndex:currentHoleNumber-1];

	NSInteger scoreToPar = [self.stats scoreTotal:self.currentRound.holes] - [self.stats parTotal:self.currentRound.holes]+[self.activeHoleObject.par intValue] -[self.activeHoleObject.score intValue];

	if(scoreToPar>0)
	{
		self.scoreToPar.text = [NSString stringWithFormat:@"(+%ld)",(long)scoreToPar];
		self.scoreToPar.textColor = [UIColor whiteColor];
	}
	else if(scoreToPar<0)
	{
		self.scoreToPar.text = [NSString stringWithFormat:@"(%ld)",(long)scoreToPar];
		self.scoreToPar.textColor = [UIColor redColor];
	}
	else if (scoreToPar==0)
	{
		self.scoreToPar.text = [NSString stringWithFormat:@"(E)"];
		self.scoreToPar.textColor = [UIColor whiteColor];
	}
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
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    [self singleTapSetup];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStats) name:@"dataChanged" object:nil];
    self.courseName.text = [[MGCurrentRound sharedCurrentRound]courseName];
    
    self.headerView.layer.borderWidth = 1;
    self.headerView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.courseLabelView.layer.borderWidth=1;
    self.courseLabelView.layer.borderColor =[UIColor whiteColor].CGColor;
    
    [self setStats];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tabBarController.tabBar setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self setStats];
    
   
    
 //   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC);
   // dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                //   {
                       
                    //   [self setStats];
                 //  });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)singleTapSetup
{
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapMethod)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerView addGestureRecognizer:singleTap];
    
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit Round"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(exitButtonPressed)];
    self.navigationItem.leftBarButtonItem = exitButton;
}

-(void) singleTapMethod
{
    if(self.navigationController.navigationBar.isHidden == YES)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.hidesBackButton = YES;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

-(void)exitButtonPressed
{
    UIAlertView *upgradeAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure that you want to exit the current round?  All recorded data will be lost." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Exit Round", nil];
    [upgradeAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Exit Round"])
	{
        [self.tabBarController setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
	}
}























@end
