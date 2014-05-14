//
//  MGStatsDetailViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGStatsDetailViewController.h"
#import "MGShot.h"

@interface MGStatsDetailViewController ()

@property (strong,nonatomic) NSMutableArray * startingLocationsArray;

@end

@implementation MGStatsDetailViewController

@synthesize holesArray;
@synthesize shotsArray;
@synthesize parseData;
@synthesize startingLocationsArray;

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

	self.parseData=[ParseData sharedParseData];
	self.holesArray=parseData.holesFromParse;
	self.shotsArray=parseData.shotsFromParse;
	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;
	self.target=@"fairway";
	self.start = @"teeBox";
	self.startingLocation.text = @"teeBox";
	[self filteredStats];
}

-(NSArray*)results
{
	NSPredicate * startPredicate = [NSPredicate predicateWithFormat:@"startingLocation = %@",self.start];
	NSPredicate * targetPredicate = [NSPredicate predicateWithFormat:@"target = %@",self.target];
	NSPredicate * combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:startPredicate,targetPredicate,nil]];
	NSArray * resultArray = [self.shotsArray filteredArrayUsingPredicate:combinedPredicate];
	return resultArray;
}

-(void)filteredStats
{
	NSUInteger count = self.results.count;
	if (count == 0)
	{
		[self noDataToDisplay];
		return;
	}

	NSInteger x;
	self.targetHit.textColor=[UIColor blackColor];

	if(self.targetLocation.selectedSegmentIndex==0)
	{
		double fairwayHit = 0;
		double fairwayShort=0;
		double fairwayLeft=0;
		double fairwayRight=0;
		double fairwayLong=0;

		for (x=0; x<count; x++)
		{
			MGShot * shot = [self.results objectAtIndex:x];
			if ([shot.endingLocation isEqualToString:@"fairwayHit"]) fairwayHit++;
			else if ([shot.endingLocation isEqualToString:@"fairwayShort"]) fairwayShort++;
			else if ([shot.endingLocation isEqualToString:@"fairwayLeft"]) fairwayLeft++;
			else if ([shot.endingLocation isEqualToString:@"fairwayRight"]) fairwayRight++;
			else if ([shot.endingLocation isEqualToString:@"fairwayLong"]) fairwayLong++;
		}



		self.targetHit.text = [NSString stringWithFormat:@"%.1f%%",fairwayHit/count*100];
		self.targetShort.text = [NSString stringWithFormat:@"%.1f%%",fairwayShort/count*100];
		self.targetLeft.text = [NSString stringWithFormat:@"%.1f%%",fairwayLeft/count*100];
		self.targetRight.text = [NSString stringWithFormat:@"%.1f%%",fairwayRight/count*100];
		self.targetLong.text = [NSString stringWithFormat:@"%.1f%%",fairwayLong/count*100];
	}

	else if (self.targetLocation.selectedSegmentIndex==1)
	{

		double greenHit = 0;
		double greenShort=0;
		double greenLeft=0;
		double greenRight=0;
		double greenLong=0;

		for (x=0; x<count; x++)
		{
			MGShot * shot = [self.results objectAtIndex:x];
			if ([shot.endingLocation isEqualToString:@"greenHit"]) greenHit++;
			else if ([shot.endingLocation isEqualToString:@"greenShort"]) greenShort++;
			else if ([shot.endingLocation isEqualToString:@"greenLeft"]) greenLeft++;
			else if ([shot.endingLocation isEqualToString:@"greenRight"]) greenRight++;
			else if ([shot.endingLocation isEqualToString:@"greenLong"]) greenLong++;

		}

		NSLog(@"%f,%f,%f,%f,%f",greenHit,greenShort,greenLeft,greenRight,greenLong);

		self.targetHit.text = [NSString stringWithFormat:@"%.1f%%",greenHit/count*100];
		self.targetShort.text = [NSString stringWithFormat:@"%.1f%%",greenShort/count*100];
		self.targetLeft.text = [NSString stringWithFormat:@"%.1f%%",greenLeft/count*100];
		self.targetRight.text = [NSString stringWithFormat:@"%.1f%%",greenRight/count*100];
		self.targetLong.text = [NSString stringWithFormat:@"%.1f%%",greenLong/count*100];
	}
}

-(void)noDataToDisplay
{
	self.targetHit.text = @"No Data";
	self.targetHit.textColor = [UIColor redColor];
	self.targetLeft.text=nil;
	self.targetLong.text=nil;
	self.targetRight.text=nil;
	self.targetShort.text=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)targetSegmentedControl:(id)sender
{
	if(self.targetLocation.selectedSegmentIndex == 0)
		{
		self.target = @"fairway";
		self.start = @"teeBox";
		self.startingLocation.text = @"teeBox";
		}

	else
		{
		self.target = @"green";
		self.start = @"fairwayHit";
		self.startingLocation.text = @"fairwayHit";
		}

	[self filteredStats];
}


- (IBAction)showLocationPicker:(id)sender
{

	UIPickerView *locationPicker = [[UIPickerView alloc] init];
	locationPicker.delegate =self;
	locationPicker.showsSelectionIndicator = YES;
	[self.startingLocation setInputView:locationPicker];

	startingLocationsArray= [[NSMutableArray alloc] init];

	if(self.targetLocation.selectedSegmentIndex==0)
	   {

		   [startingLocationsArray addObject:@"teeBox"];
		   [startingLocationsArray addObject:@"fairwayHit"];
		   [startingLocationsArray addObject:@"fairwayShort"];
		   [startingLocationsArray addObject:@"fairwayLeft"];
		   [startingLocationsArray addObject:@"fairwayRight"];
		   locationPicker.tag = 1;
	   }
	else if (self.targetLocation.selectedSegmentIndex==1)
		{
		[startingLocationsArray addObject:@"fairwayHit"];
		[startingLocationsArray addObject:@"fairwayShort"];
		[startingLocationsArray addObject:@"fairwayLeft"];
		[startingLocationsArray addObject:@"fairwayRight"];
		[startingLocationsArray addObject:@"fairwayLong"];
		[startingLocationsArray addObject:@"greenShort"];
		[startingLocationsArray addObject:@"greenLeft"];
		[startingLocationsArray addObject:@"greenRight"];
		[startingLocationsArray addObject:@"greenLong"];
		locationPicker.tag = 2;
	}

	_startingLocation.text = [startingLocationsArray objectAtIndex:0];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//One column
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

	if(pickerView.tag == 1) return 5;
	if(pickerView.tag == 2) return 9;
	else return 0;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [startingLocationsArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_startingLocation.text=[startingLocationsArray objectAtIndex:row];
	self.start =[startingLocationsArray objectAtIndex:row];
	[self filteredStats];

}
- (IBAction)toolbarSetup:(id)sender
{

    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];
}

- (void)doneDidTouchDown
{
	[_startingLocation resignFirstResponder];
}
- (void)nextDidTouchDown
{/**/}

- (void)previousDidTouchDown
{/**/}




@end
