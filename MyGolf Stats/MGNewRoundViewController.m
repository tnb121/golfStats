//
//  MGNewRoundViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGNewRoundViewController.h"
#import "MGCurrentRound.h"

@interface MGNewRoundViewController ()

@end

@implementation MGNewRoundViewController

@synthesize ratingValue=_ratingValue;
@synthesize slopeValue=_slopeValue;
@synthesize dateValue=_dateValue;
@synthesize courseNameValue=_courseNameValue;
@synthesize teeValue=_teeValue;
@synthesize createRoundButton=_createRoundButton;
@synthesize currentLocation=_currentLocation;

@synthesize teeColors=_teeColors;

-(BOOL) RoundRatingCheck
{
	double rating = [_ratingValue.text doubleValue];

	if(rating>=65 && rating<=85)
		return YES;
	else
		return NO;
}

-(BOOL) RoundSlopeCheck
{
	double slope = [_slopeValue.text doubleValue];

	if(slope>=55 && slope<=155)
		return YES;
	else
		return NO;
}

-(BOOL) RoundCourseNameCheck
{
	NSString * courseText = _courseNameValue.text;

	if([courseText  isEqualToString:@""])
		return NO;
	else
		return YES;
}

-(BOOL) RoundTeeNameCheck
{
	NSString * teeText = _teeValue.text;

	if([teeText isEqualToString:@""])
		return NO;
	else
		return YES;
}

-(BOOL) RoundDateCheck
{
	NSString * dateText = _dateValue.text;
	if([dateText isEqualToString:@""])
		return NO;
	else
		return YES;
}
-(BOOL)roundDataEntryComplete
{
	if ([self RoundCourseNameCheck] == YES && [self RoundTeeNameCheck] == YES && [self RoundDateCheck] == YES && [self RoundRatingCheck] == YES && [self RoundSlopeCheck] == YES)
	{
		self.createRoundButton.enabled=YES;
		return YES;
	}
	else
	{
		self.createRoundButton.enabled=NO;
		return NO;
	}
}

- (IBAction)testDataEntry:(id)sender
{

	if([self roundDataEntryComplete] == YES)
		return;
	else
		return;
	[self.view setNeedsDisplay];
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
	// Do any additional setup after loading the view.
}

-(IBAction)createNewRound:(id)sender
{
	MGCurrentRound *currentRound = [MGCurrentRound sharedCurrentRound];
	[currentRound createCurrentRound];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *date = [formatter dateFromString:[_dateValue.text substringToIndex:10]];
	NSNumber *rating = [[NSNumber alloc] initWithDouble:[_ratingValue.text integerValue]];
	NSNumber *slope = [[NSNumber alloc] initWithDouble:[_slopeValue.text integerValue]];

	currentRound.courseName=self.ratingValue.text;
	currentRound.tee = self.teeValue.text;
	currentRound.date=date;
	currentRound.rating=rating;
	currentRound.slope=slope;
	currentRound.location=_currentLocation;
	currentRound.currentHole= [NSNumber numberWithInt:1];
	[currentRound saveRound];

	[self performSegueWithIdentifier:@"NewRoundSegue" sender:self];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self setDefaultsForTesting];

		[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
		if (!error) {
			_currentLocation=geoPoint;
		}
	}];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showDatePicker:(id)sender
{
	UIDatePicker *datePicker = [[UIDatePicker alloc]init];
	datePicker.datePickerMode = UIDatePickerModeDate;
	datePicker.maximumDate=[NSDate date];


	[datePicker setDate:[NSDate date]];
	[datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
	[self.dateValue setInputView:datePicker];

	UIDatePicker *picker = (UIDatePicker*)self.dateValue.inputView;

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:picker.date];
	self.dateValue.text = dateInput;

}
-(void)updateTextField:(id)sender
{
	UIDatePicker *picker = (UIDatePicker*)self.dateValue.inputView;

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:picker.date];
	self.dateValue.text = dateInput;
}

-(IBAction)showTeePicker:(id)sender
{
	UIPickerView *teePicker = [[UIPickerView alloc] init];
	teePicker.delegate =self;
	teePicker.showsSelectionIndicator = YES;
	teePicker.tag = 1;
	[self.teeValue setInputView:teePicker];


	// initialize the Array of tee colors
	_teeColors= [[NSMutableArray alloc] init];
	[_teeColors addObject:@"Black"];
	[_teeColors addObject:@"Blue"];
	[_teeColors addObject:@"Gold"];
	[_teeColors addObject:@"Green"];
	[_teeColors addObject:@"Red"];
	[_teeColors addObject:@"White"];
	[_teeColors addObject:@"Other"];

	_teeValue.text = [_teeColors objectAtIndex:0];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//One column
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

	if(pickerView.tag == 1) return _teeColors.count;
	if(pickerView.tag ==2) return _coursesArray.count;
	else return 0;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if(pickerView.tag ==1) return [_teeColors objectAtIndex:row];
	if(pickerView.tag == 2)
	{
		NSString * courseName = [[_coursesArray objectAtIndex:row]valueForKey:@"name"];
		NSString * teeName = [[_coursesArray objectAtIndex:row]valueForKey:@"tee"];
		NSString * courseString2 = [[courseName stringByAppendingString:@" - "]stringByAppendingString:teeName];
		return courseString2;
	}
	else return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if(pickerView.tag == 1) _teeValue.text=[_teeColors objectAtIndex:row];
	if(pickerView.tag ==2)
	{
		_courseNameValue.text =[[_coursesArray objectAtIndex:row] valueForKey:@"name"];
		_teeValue.text= [[_coursesArray objectAtIndex:row] valueForKey:@"tee"];
		_slopeValue.text = [NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:row] valueForKey:@"slope"]];
		_ratingValue.text =[NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:row] valueForKey:@"rating"]] ;
	}
}


- (IBAction) dismissKeyboard:(id)sender
{
	[_courseNameValue resignFirstResponder];
	[_teeValue resignFirstResponder];
	[_dateValue resignFirstResponder];
	[_slopeValue resignFirstResponder];
	[_existingRoundText resignFirstResponder];
}
- (IBAction)toolbarSetup:(id)sender
{
    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
}


- (void)nextDidTouchDown
{
	if (_courseNameValue.isFirstResponder)
		[self.teeValue becomeFirstResponder];
	else if (_teeValue.isFirstResponder)
		[self.dateValue becomeFirstResponder];
	else if (_dateValue.isFirstResponder)
		[self.ratingValue becomeFirstResponder];
	else if (_ratingValue.isFirstResponder)
		[self.slopeValue becomeFirstResponder];
	else if(_slopeValue.isFirstResponder)
		[self.courseNameValue becomeFirstResponder];
	else if(_existingRoundText.isFirstResponder)
		[self.dateValue becomeFirstResponder];
}

- (void)previousDidTouchDown
{
	if (_courseNameValue.isFirstResponder)
		[self.courseNameValue becomeFirstResponder];
	else if (_teeValue.isFirstResponder)
		[self.courseNameValue becomeFirstResponder];
	else if (_dateValue.isFirstResponder)
		[self.teeValue becomeFirstResponder];
	else if (_ratingValue.isFirstResponder)
		[self.dateValue becomeFirstResponder];
	else if (_slopeValue.isFirstResponder)
		[self.ratingValue becomeFirstResponder];

}

- (void)doneDidTouchDown
{


	if([_existingRoundText isFirstResponder] == YES)
	{
		[_existingRoundText resignFirstResponder];
		[_dateValue becomeFirstResponder];
	}
	else 	[self dismissKeyboard:self];;
}


-(void)courseAlert
{

	UIAlertView *courseAlert = [[UIAlertView alloc]
								initWithTitle:nil
								message:@"Is this a new or existing course?"
								delegate:self
								cancelButtonTitle:nil
								otherButtonTitles: @"New",@"Existing", nil];
	[courseAlert show];

}


/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];

	if ([buttonTitle isEqualToString:@"New"])
	{

	}

	if ([buttonTitle isEqualToString:@"Existing"])
	{

		//if([[[ParseData sharedParseData]roundCount]integerValue]==0)
		{
			UIAlertView *noExistingRoundsAlert = [[UIAlertView alloc]
												  initWithTitle:nil
												  message:@"You do not have any previously entered rounds."
												  delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[noExistingRoundsAlert show];
			[self.courseNameValue becomeFirstResponder];
		}
		else
		{
			[self dismissKeyboard:(self)];
			[self.existingRoundText becomeFirstResponder];

		}
	}

}
 */
- (IBAction)showCoursePicker:(id)sender
{
	UIPickerView * coursePicker= [[UIPickerView alloc] init];
	coursePicker.delegate=self;
	coursePicker.showsSelectionIndicator=YES;
	coursePicker.tag=2;
	[self.existingRoundText setInputView:coursePicker];

	ParseData * parseData = [ParseData sharedParseData];
	_coursesArray=[parseData.uniqueCourseArray mutableCopy];
	_courseNameValue.text =[[_coursesArray objectAtIndex:0] valueForKey:@"name"];
	_teeValue.text= [[_coursesArray objectAtIndex:0] valueForKey:@"tee"];
	_slopeValue.text = [NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:0] valueForKey:@"slope"]];
	_ratingValue.text =[NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:0] valueForKey:@"rating"]] ;
}

-(void) setDefaultsForTesting
{
	self.courseNameValue.text =@"test";
	self.teeValue.text = @"test";
	self.dateValue.text = [NSString string];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:[NSDate date]];
	self.dateValue.text = dateInput;

	self.ratingValue.text = @"72";
	self.slopeValue.text = @"113";

}

@end
