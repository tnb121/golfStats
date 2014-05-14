//
//  MGHomeStatsPageControllerViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 2/17/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGHomeStatsPageControllerViewController.h"
#import "MGTotalStats.h"



@interface MGHomeStatsPageControllerViewController ()

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

@property (strong,nonatomic) MGTotalStats * totalStats;
@property (strong,nonatomic) NSArray * allHolesArray;
@property (strong,nonatomic) NSArray * par3Array;
@property (strong,nonatomic) NSArray * par4Array;
@property (strong,nonatomic) NSArray * par5Array;
@property (strong,nonatomic) NSArray * filterArray;

@property (strong,nonatomic) UIView * fairwayPar3View;
@property (strong,nonatomic) UILabel * noFairwayDataLabel;


- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end

@implementation MGHomeStatsPageControllerViewController


-(MGTotalStats*)totalStats
{
	return [MGTotalStats sharedTotalStats];
}
-(NSArray*)filterArray
{
	return [[MGTotalStats sharedTotalStats]filteredHolesAfterPredicates];
}

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

// Offset of Scene Label
NSInteger sceneLabelYOffset = 0;

// Offset of Green Labels
NSInteger greenHitLabelYOffset = 0;
NSInteger greenLeftLabelYOffset = 0;
NSInteger greenRightLabelYOffset = 0;
NSInteger greenLongLabelYOffset = 0;
NSInteger greenShortLabelYOffset = 0;

NSInteger fairwayHitLabelYOffset = 0;
NSInteger fairwayLeftLabelYOffset = 0;
NSInteger fairwayRightLabelYOffset = 0;
NSInteger fairwayLongLabelYOffset = 0;
NSInteger fairwayShortLabelYOffset = 0;

#pragma mark -

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));

    // Update the page control
    self.pageControl.currentPage = page;

    // Work out which pages we want to load
    NSInteger firstPage = 0;
    NSInteger lastPage = 2;

    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
    
    [self.scrollView bringSubviewToFront:self.pageControl];
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }

    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;

        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [_scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];

    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }

    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createOffsets];
    
    // Set up the image we want to scroll & zoom and add it to the scroll view
    
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        _pageImages = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"Fairway Image (data collection)(3_5).png"],
                           [UIImage imageNamed:@"Green Image (stats homepage)(3.5).png"],
                           [UIImage imageNamed:@"Short Game Image (stats homepage)(3.5).png"],
                           nil];
    }
    else
    {
        self.pageImages = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"Fairway Image (stats homepage).png"],
                           [UIImage imageNamed:@"Green Image (stats homepage).png"],
                           [UIImage imageNamed:@"Short Game Image (stats homepage).png"],
                           nil];
    }


    NSInteger pageCount =_pageImages.count;

    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;

    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
     self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"App Background"]];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelTextSetup) name:@"FilteredArrayComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginSetup) name:@"HomeSubviewsComplete"  object:nil];
}

-(void)createOffsets
{
    
if ([UIScreen mainScreen].bounds.size.height<568)
    {
        // Offset of Scene Label
        sceneLabelYOffset = 10;
        
        // Offset of Fairway Labels
        fairwayHitLabelYOffset = -22;
        fairwayLeftLabelYOffset = -22;
        fairwayRightLabelYOffset = -22;
        fairwayLongLabelYOffset = -2;
        fairwayShortLabelYOffset = -32;
    
        // Offset of Green Labels
        greenHitLabelYOffset = -19;
        greenLeftLabelYOffset = -19;
        greenRightLabelYOffset = -19;
        greenLongLabelYOffset = 0;
        greenShortLabelYOffset = -35;

    }
}


-(void)labelSetup
{
	[self fairwayLabels];
	[self greenLabels];
	[self shortGameLabels];
    
}

-(void)labelTextSetup
{
	[self fairwayLabelTextSet];
	[self greenLabelTextSet];
	[self shortGameTextSet];
    [self addViewToFairwayForPar3];
}

-(void) addViewToFairwayForPar3
{
    if([self.totalStats.parFilterSelection isEqualToString:@"3"])
    {
    
        self.fairwayPar3View = [[UIView alloc]initWithFrame: self.scrollView.frame];
        self.fairwayPar3View.backgroundColor = [UIColor blackColor];
        self.fairwayPar3View.alpha = 0.7;
    
        self.noFairwayDataLabel = [[UILabel alloc]init];
        self.noFairwayDataLabel.text = @"No fairway data for par 3's";
        self.noFairwayDataLabel.font = [UIFont boldSystemFontOfSize:20];
        self.noFairwayDataLabel.textAlignment= NSTextAlignmentCenter;
        self.noFairwayDataLabel.textColor=[UIColor whiteColor];
        [self.noFairwayDataLabel setFrame:CGRectMake(0,119, 320,20)];
   
        
        self.fairwayHitLabel.text = nil;
        self.fairwayLeftLabel.text = nil;
        self.fairwayRightLabel.text = nil;
        self.fairwayLongLabel.text = nil;
        self.fairwayShortLabel.text = nil;
    
        [self.scrollView addSubview:self.fairwayPar3View];
        [self.scrollView addSubview:self.noFairwayDataLabel];
    }
    
    else
    {
        [self.noFairwayDataLabel removeFromSuperview];
        [self.fairwayPar3View removeFromSuperview];
    }

}

-(void)fairwayLabels
{
    
	self.fairwayHitLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 119 + fairwayHitLabelYOffset, 70, 20)];
	self.fairwayLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 119+fairwayLeftLabelYOffset, 70, 20)];
	self.fairwayRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(247, 119+fairwayRightLabelYOffset, 70, 20)];
	self.fairwayLongLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 20+fairwayLongLabelYOffset, 70, 20)];
	self.fairwayShortLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 220+fairwayShortLabelYOffset, 70, 20)];

	self.fairwayHitLabel.textColor=[UIColor whiteColor];
	self.fairwayLeftLabel.textColor=[UIColor whiteColor];
	self.fairwayRightLabel.textColor=[UIColor whiteColor];
	self.fairwayLongLabel.textColor=[UIColor whiteColor];
	self.fairwayShortLabel.textColor=[UIColor whiteColor];

	self.fairwayHitLabel.font = [UIFont boldSystemFontOfSize:15];
	self.fairwayLeftLabel.font = [UIFont boldSystemFontOfSize:15];
	self.fairwayRightLabel.font = [UIFont boldSystemFontOfSize:15];
	self.fairwayLongLabel.font = [UIFont boldSystemFontOfSize:15];
	self.fairwayShortLabel.font = [UIFont boldSystemFontOfSize:15];

	self.fairwayHitLabel.textAlignment=NSTextAlignmentCenter;
	self.fairwayLeftLabel.textAlignment=NSTextAlignmentCenter;
	self.fairwayRightLabel.textAlignment=NSTextAlignmentCenter;
	self.fairwayLongLabel.textAlignment=NSTextAlignmentCenter;
	self.fairwayShortLabel.textAlignment=NSTextAlignmentCenter;

	[self.scrollView addSubview:self.fairwayHitLabel];
	[self.scrollView addSubview:self.fairwayLeftLabel];
	[self.scrollView addSubview:self.fairwayRightLabel];
	[self.scrollView addSubview:self.fairwayLongLabel];
	[self.scrollView addSubview:self.fairwayShortLabel];

	UILabel * fairwayTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(5, 5+sceneLabelYOffset, 200, 20)];
	fairwayTitleLabel.text = @"Fairway";
	fairwayTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	fairwayTitleLabel.textColor=[UIColor whiteColor];
	[self.scrollView addSubview:fairwayTitleLabel];

}

-(void)fairwayLabelTextSet
{
	NSString * hitTest = [self.totalStats fairwaysHitString:self.filterArray];

	self.fairwayHitLabel.text =	 hitTest;
	//self.fairwayHitLabel.text =	 [self.totalStats fairwaysHitString:self.filterArray];
	self.fairwayLeftLabel.text=  [self.totalStats fairwaysLeftString:self.filterArray];
	self.fairwayRightLabel.text= [self.totalStats fairwaysRightString:self.filterArray];
	self.fairwayLongLabel.text=  [self.totalStats fairwaysLongString:self.filterArray];
	self.fairwayShortLabel.text= [self.totalStats fairwaysShortString:self.filterArray];}

-(void)greenLabels
{
	self.greenHitLabel = [[UILabel alloc] initWithFrame:CGRectMake(132+320, 119+greenHitLabelYOffset, 70, 20)];
	self.greenLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(6+320, 119+greenLeftLabelYOffset, 70, 20)];
	self.greenRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(247+320, 119+greenRightLabelYOffset, 70, 20)];
	self.greenLongLabel = [[UILabel alloc] initWithFrame:CGRectMake(132+320, 19+greenLongLabelYOffset, 70, 20)];
	self.greenShortLabel = [[UILabel alloc] initWithFrame:CGRectMake(132+320, 223+greenShortLabelYOffset, 70, 20)];

	self.greenHitLabel.textColor=[UIColor whiteColor];
	self.greenLeftLabel.textColor=[UIColor whiteColor];
	self.greenRightLabel.textColor=[UIColor whiteColor];
	self.greenLongLabel.textColor=[UIColor whiteColor];
	self.greenShortLabel.textColor=[UIColor whiteColor];

	self.greenHitLabel.font = [UIFont boldSystemFontOfSize:15];
	self.greenLeftLabel.font = [UIFont boldSystemFontOfSize:15];
	self.greenRightLabel.font = [UIFont boldSystemFontOfSize:15];
	self.greenLongLabel.font = [UIFont boldSystemFontOfSize:15];
	self.greenShortLabel.font = [UIFont boldSystemFontOfSize:15];

	self.greenHitLabel.textAlignment=NSTextAlignmentCenter;
	self.greenLeftLabel.textAlignment=NSTextAlignmentCenter;
	self.greenRightLabel.textAlignment=NSTextAlignmentCenter;
	self.greenLongLabel.textAlignment=NSTextAlignmentCenter;
	self.greenShortLabel.textAlignment=NSTextAlignmentCenter;

	[self.scrollView addSubview:self.greenHitLabel];
	[self.scrollView addSubview:self.greenLeftLabel];
	[self.scrollView addSubview:self.greenRightLabel];
	[self.scrollView addSubview:self.greenLongLabel];
	[self.scrollView addSubview:self.greenShortLabel];

	UILabel * greenTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(5+320, 5+sceneLabelYOffset, 200, 20)];
	greenTitleLabel.text = @"Green";
	greenTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	greenTitleLabel.textColor=[UIColor whiteColor];
	[self.scrollView addSubview:greenTitleLabel];

	[self greenLabelTextSet];
}
-(void)greenLabelTextSet
{
	self.greenHitLabel.text =  [self.totalStats greensHitString:self.filterArray];
	self.greenLeftLabel.text=  [self.totalStats greensLeftString:self.filterArray];
	self.greenRightLabel.text= [self.totalStats greensRightString:self.filterArray];
	self.greenLongLabel.text=  [self.totalStats greensLongString:self.filterArray];
	self.greenShortLabel.text= [self.totalStats greensShortString:self.filterArray];
}
-(void)shortGameLabels
{
    self.puttsPerHoleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50+640, 50, 200, 20)];
	self.puttsPerRoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(50+640, 80, 200, 20)];
	self.upAndDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(50+640, 110, 200, 20)];
	self.sandSavesLabel = [[UILabel alloc] initWithFrame:CGRectMake(50+640, 140, 200, 20)];
    
    self.puttsPerHoleDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(200+640, 50, 200, 20)];
	self.puttsPerRoundDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(200+640, 80, 70, 20)];
	self.upAndDownDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(200+640, 110, 70, 20)];
	self.sandSavesDataLabel= [[UILabel alloc] initWithFrame:CGRectMake(200+640, 140, 70, 20)];

	self.puttsPerHoleLabel.textColor=[UIColor whiteColor];
    self.puttsPerRoundLabel.textColor=[UIColor whiteColor];
	self.upAndDownLabel.textColor=[UIColor whiteColor];
	self.sandSavesLabel.textColor=[UIColor whiteColor];

	self.puttsPerHoleDataLabel.textColor=[UIColor whiteColor];
    self.puttsPerRoundDataLabel.textColor=[UIColor whiteColor];
	self.upAndDownDataLabel.textColor=[UIColor whiteColor];
	self.sandSavesDataLabel.textColor=[UIColor whiteColor];

    self.puttsPerHoleLabel.font = [UIFont boldSystemFontOfSize:18];
	self.puttsPerRoundLabel.font = [UIFont boldSystemFontOfSize:18];
	self.upAndDownLabel.font = [UIFont boldSystemFontOfSize:18];
	self.sandSavesLabel.font= [UIFont boldSystemFontOfSize:18];

	self.puttsPerHoleDataLabel.font = [UIFont boldSystemFontOfSize:18];
    self.puttsPerRoundDataLabel.font = [UIFont boldSystemFontOfSize:18];
	self.upAndDownDataLabel.font = [UIFont boldSystemFontOfSize:18];
	self.sandSavesDataLabel.font = [UIFont boldSystemFontOfSize:18];

    self.puttsPerHoleLabel.textAlignment=NSTextAlignmentLeft;
	self.puttsPerRoundLabel.textAlignment=NSTextAlignmentLeft;
	self.upAndDownLabel.textAlignment=NSTextAlignmentLeft;
	self.sandSavesLabel.textAlignment=NSTextAlignmentLeft;

    self.puttsPerHoleDataLabel.textAlignment=NSTextAlignmentLeft;
    self.puttsPerRoundDataLabel.textAlignment=NSTextAlignmentLeft;
	self.upAndDownDataLabel.textAlignment=NSTextAlignmentLeft;
	self.sandSavesDataLabel.textAlignment=NSTextAlignmentLeft;
    
    [self.scrollView addSubview:self.puttsPerHoleLabel];
	[self.scrollView addSubview:self.puttsPerRoundLabel];
	[self.scrollView addSubview:self.upAndDownLabel];
	[self.scrollView addSubview:self.sandSavesLabel];

    [self.scrollView addSubview:self.puttsPerHoleDataLabel];
	[self.scrollView addSubview:self.puttsPerRoundDataLabel];
	[self.scrollView addSubview:self.upAndDownDataLabel];
	[self.scrollView addSubview:self.sandSavesDataLabel];

	UILabel * greenSurfaceTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(5+640, 5+sceneLabelYOffset, 200, 20)];
	greenSurfaceTitleLabel.text = @"Short Game";
	greenSurfaceTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	greenSurfaceTitleLabel.textColor=[UIColor whiteColor];
	[self.scrollView addSubview:greenSurfaceTitleLabel];

	[self shortGameTextSet];
}
-(void)shortGameTextSet
{
	self.puttsPerHoleLabel.text = @"Putts per Hole:";
    self.puttsPerRoundLabel.text =  @"Putts per Round:";
	self.upAndDownLabel.text=  @"Up & Down: ";
	self.sandSavesLabel.text= @"Sand Saves: ";

    self.puttsPerHoleDataLabel.text = [self.totalStats puttsPerHoleString:self.filterArray];
	self.puttsPerRoundDataLabel.text = [self.totalStats puttsPer18String:self.filterArray];
	self.upAndDownDataLabel.text=  [self.totalStats upAndDownPercentageString:self.filterArray];
	self.sandSavesDataLabel.text= [self.totalStats sandSavePercentageString:self.filterArray];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)beginSetup
{
    
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
       CGSize pagesScrollViewSize = self.scrollView.frame.size;
        self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
        self.scrollView.bounds = CGRectMake(0, 0, 320, 221);
    }
    else
    {
        CGSize pagesScrollViewSize = self.scrollView.frame.size;
        self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
           self.scrollView.bounds = CGRectMake(0, 0, 320, 266);
    }

    // Load the initial set of pages that are on screen
    [self loadVisiblePages];

	if(!self.fairwayHitLabel)[self labelSetup];
	[self labelTextSetup];
}

- (void)viewDidUnload {
    [super viewDidUnload];

    self.scrollView = nil;
    self.pageControl = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}
@end
