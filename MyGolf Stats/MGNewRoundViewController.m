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

@property (strong,nonatomic) ParseData * parseData;
@property (strong,nonatomic) UIView * inactiveView;

@property (strong,nonatomic) NSMutableArray * slopeArray;
@property (strong,nonatomic) NSMutableArray * ratingArray;

@end

@implementation MGNewRoundViewController

@synthesize ratingValue=_ratingValue;
@synthesize slopeValue=_slopeValue;
@synthesize dateValue=_dateValue;
@synthesize courseNameValue=_courseNameValue;
@synthesize teeValue=_teeValue;
@synthesize createRoundButton=_createRoundButton;
@synthesize currentLocation=_currentLocation;

@synthesize parseData;
@synthesize coursesArray=_coursesArray;

@synthesize teeColors=_teeColors;
@synthesize lengthArray=_lengthArray;

@synthesize inactiveView;

NSInteger teeIndex      = 0;
NSInteger courseIndex   = 0;
NSInteger lengthIndex   = 1;
NSInteger slopeIndex    = 113-55;
NSInteger ratingIndex1  = 72-55;
NSInteger ratingIndex2  = 0;

-(ParseData*)parseData
{
	return [ParseData sharedParseData];
}

- (IBAction)BackToHome:(id)sender
{
    [self.tabBarController setSelectedIndex:0];
}

-(NSMutableArray*)slopeArray
{
    if(!_slopeArray)
    {
        _slopeArray = [[NSMutableArray alloc]init];
        
        NSInteger x;
        
        for (x=55; x<=155; x++)
        {
            [_slopeArray addObject:[NSNumber numberWithInteger:x]];
        }
        
    }
    
    return _slopeArray;
}

-(NSMutableArray*)ratingArray
{
    if(!_ratingArray)
    {
        _ratingArray = [[NSMutableArray alloc]init];
        
        NSInteger x;
        
        for (x=55; x<=95; x++)
        {
            [_ratingArray addObject:[NSNumber numberWithInteger:x]];
        }
    }
    
    return _ratingArray;
}

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

-(BOOL) roundLengthCheck
{
    if ([self.roundLength.text isEqualToString:@""])
        return NO;
    else
        return YES;
}

-(BOOL)roundDataEntryComplete
{
	if ([self RoundCourseNameCheck] == YES && [self RoundTeeNameCheck] == YES && [self RoundDateCheck] == YES && [self RoundRatingCheck] == YES && [self RoundSlopeCheck] == YES && [self roundLengthCheck]==YES)
	{
		//self.createRoundButton.enabled=YES;
       // self.createRoundButton.tintColor = [UIColor blueColor];
      //  self.createRoundButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
		return YES;
	}
	else
	{
	////	self.createRoundButton.enabled=NO;
      //  self.createRoundButton.tintColor = [UIColor whiteColor];
       //  self.createRoundButton.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
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

	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"App Background"]];
    
   [self.navigationController setNavigationBarHidden:NO];
 
    
}

- (IBAction)dataEntrySaveTest:(id)sender
{
    if ([self roundDataEntryComplete]==YES)
    {
        [self initialSave:self];
    }
    else
    {
        UIAlertView *dataEntryAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter data for all fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [dataEntryAlert show];
    }
}


-(IBAction)initialSave:(id)sender
{
    [self dismissKeyboard];
    
	MGCurrentRound *currentRound = [MGCurrentRound sharedCurrentRound];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *date = [formatter dateFromString:[_dateValue.text substringToIndex:10]];

	NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

	NSNumber * rating = [numberFormatter numberFromString:self.ratingValue.text];
	NSNumber *slope = [numberFormatter numberFromString:self.slopeValue.text];

	currentRound.courseName=self.courseNameValue.text;
	currentRound.tee = self.teeValue.text;
	currentRound.date=date;
	currentRound.rating=rating;
	currentRound.slope=slope;
    
    if([self.roundLength.text isEqualToString: @"9 Holes"])
        currentRound.length = [NSNumber numberWithInteger:9];
    else if([self.roundLength.text isEqualToString: @"18 Holes"])
        currentRound.length = [NSNumber numberWithInteger:18];
    
	currentRound.location=_currentLocation;
	currentRound.currentHole= [NSNumber numberWithInt:1];
	[[MGCurrentRound sharedCurrentRound]createCurrentRound];
    
    self.parseData.updatedDataNeeded=YES;

	[self performSegueWithIdentifier:@"newRoundSegue" sender:self];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    self.courseNameValue.text = nil;
    self.teeValue.text = nil;
    self.dateValue.text = nil;
    self.ratingValue.text = nil;
    self.slopeValue.text = nil;
    self.roundLength.text = nil;
    
    self.createRoundButton.layer.cornerRadius = 5;
    self.createRoundButton.layer.borderWidth = 2;
    self.createRoundButton.layer.borderColor=[UIColor whiteColor].CGColor;
  //  self.createRoundButton.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
  //  [self.createRoundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
 //   [self.createRoundButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
   // self.createRoundButton.enabled = NO;
  //  self.createRoundButton.tintColor = [UIColor whiteColor];
    [self enableTextBoxes];
    
    if ([self checkForLiteVersion]==YES)
    {
        if(self.parseData.roundCount>0) [self courseAlert];
        else [_courseNameValue becomeFirstResponder];
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                _currentLocation=geoPoint;
            }
        }];
    }
    
    else
    {
        inactiveView = [[UIView alloc]initWithFrame:self.view.frame];
        inactiveView.opaque = NO;
        inactiveView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        inactiveView.center = self.view.center;
        [self.view addSubview: inactiveView];
        
        UIAlertView *upgradeAlert = [[UIAlertView alloc]initWithTitle:@"Upgrade to Full Version" message:@"You have reached your maximum number of rounds.  Upgrade now to enter an unlimited number of rounds." delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Upgrade", nil];
        [upgradeAlert show];
        [self disableAllUIElements];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [inactiveView removeFromSuperview];
 //   [self.navigationController popViewControllerAnimated:NO];
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
    [self.dateValue setFont:[UIFont systemFontOfSize:14]];

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

-(IBAction)showLengthPicker:(id)sender
{
	UIPickerView *lengthPicker = [[UIPickerView alloc] init];
	lengthPicker.delegate =self;
	lengthPicker.showsSelectionIndicator = YES;
	lengthPicker.tag = 3;
	[self.roundLength setInputView:lengthPicker];
    
    
	// initialize the Array of tee colors
    _lengthArray= [[NSMutableArray alloc] init];
	[_lengthArray addObject:@"9 Holes"];
    [_lengthArray addObject:@"18 Holes"];
    
	self.roundLength.text = [_lengthArray objectAtIndex:1];
    [lengthPicker selectRow:1 inComponent:0 animated:YES];
}

-(IBAction)showSlopePicker:(id)sender
{
    UIPickerView *slopePicker = [[UIPickerView alloc] init];
    slopePicker.delegate =self;
    slopePicker.showsSelectionIndicator = YES;
    slopePicker.tag = 4;
    [self.slopeValue setInputView:slopePicker];
    
    NSInteger  slopeAverage = [[self.parseData slopeAverage]integerValue];
    
    if(slopeIndex == 113-55)
    {
        
        if(!slopeAverage)
            slopeAverage = 113;
        slopeIndex = slopeAverage - 55;
    }
    
    NSInteger slopeInt = [[self.slopeArray objectAtIndex:slopeIndex]integerValue];
    
    NSString * testString =[NSString stringWithFormat:@"%ld",(long)slopeInt];
    
    self.slopeValue.text = testString;
    [slopePicker selectRow:slopeIndex inComponent:0 animated:YES];
}

-(IBAction)showRatingPicker:(id)sender
{
    UIPickerView *ratingPicker = [[UIPickerView alloc] init];
    ratingPicker.delegate =self;
    ratingPicker.showsSelectionIndicator = YES;
    ratingPicker.tag = 5;
    [self.ratingValue setInputView:ratingPicker];
    
    double rating1 = [[self.ratingArray objectAtIndex:ratingIndex1]doubleValue];
    double rating2 = ratingIndex2;
    double ratingReturn = rating1 + (rating2/10);
    
    self.ratingValue.text = [NSString stringWithFormat:@"%.1f",ratingReturn];
    [ratingPicker selectRow:ratingIndex1 inComponent:0 animated:YES];
    [ratingPicker selectRow:ratingIndex2 inComponent:1 animated:YES];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(pickerView.tag == 5)
        return 3;
    else
        return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            switch (pickerView.tag)
        {
            case 1:
                return _teeColors.count;
                break;
            case 2:
                return _coursesArray.count;
                break;
            case 3:
                return 2;
                break;
            case 4:
            {
                return _slopeArray.count;
                break;
            }
            case 5:
                return _ratingArray.count;
                break;
                
            default:
                break;
        }
            
        case 1:
            switch (pickerView.tag)
        {
            case 5:
                return 1;
                break;
                
            default:
                return 0;
                break;
        }
        case 2:
            switch (pickerView.tag)
        {
            case 5:
                return 10;
                break;
                
            default:
                return 0;
                break;
        }
            
            
        default:
            return 0;
            break;
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    switch (component)
    {
        case 0:
            switch (pickerView.tag)
        {
            case 1:
            {
                UILabel * pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 45)];
                [pickerLabel setText:[_teeColors objectAtIndex:row]];
                [pickerLabel setTextAlignment:NSTextAlignmentCenter];
                [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
                return pickerLabel;
                break;
            }
            case 2:
            {
                NSString * courseName = [[_coursesArray objectAtIndex:row]valueForKey:@"name"];
                NSString * teeName = [[_coursesArray objectAtIndex:row]valueForKey:@"tee"];
                NSString * courseString2 = [[courseName stringByAppendingString:@" - "]stringByAppendingString:teeName];
                
                UILabel * pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 45)];
                [pickerLabel setText:courseString2];
                [pickerLabel setTextAlignment:NSTextAlignmentCenter];
                return pickerLabel;
                break;
            }
                break;
            case 3:
            {
                UILabel * pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 45)];
                [pickerLabel setText:[NSString stringWithFormat:@"%@",[self.lengthArray objectAtIndex:row]]];
                [pickerLabel setTextAlignment:NSTextAlignmentCenter];
                [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
                return pickerLabel;
                break;
            }
                
                
            case 4:
            {
                UILabel * pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 45)];
                [pickerLabel setText:[NSString stringWithFormat:@"%@",[self.slopeArray objectAtIndex:row]]];
                [pickerLabel setTextAlignment:NSTextAlignmentCenter];
                [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
                return pickerLabel;
                break;
            }
                
                
            case 5:
            {
                UILabel * pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 45)];
                [pickerLabel setTextAlignment:NSTextAlignmentRight];
                [pickerLabel setText:[NSString stringWithFormat:@"%@",[self.ratingArray objectAtIndex:row]]];
                [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
                return pickerLabel;
                break;
            }
                
            default:
                break;
        }
            
        case 1:
            switch (pickerView.tag)
        {
            case 5:
            {
                UILabel * pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
                [pickerLabel setTextAlignment:NSTextAlignmentCenter];
                [pickerLabel setText:@"."];
                [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
                //[pickerLabel setBackgroundColor:[UIColor redColor]];
                return pickerLabel;
                break;
            }
                
            default:
                return nil;
                break;
        }
        case 2:
            switch (pickerView.tag)
        {
            case 5:
            {
                UILabel * pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 45)];
                [pickerLabel setTextAlignment:NSTextAlignmentLeft];
                [pickerLabel setText:[NSString stringWithFormat:@"%ld",(long)row]];
                [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
                return pickerLabel;
                break;
            }
                
            default:
                return nil;
                break;
        }
            
            
            
        default:
            return nil;
            break;
    }
    
}



-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // NSInteger tag = pickerView.tag;
    
    switch (component)
    {
        case 0:
            switch (pickerView.tag)
        {
            case 1:
                return [_teeColors objectAtIndex:teeIndex];
                break;
            case 2:
            {
                NSString * courseName = [[_coursesArray objectAtIndex:courseIndex]valueForKey:@"name"];
                NSString * teeName = [[_coursesArray objectAtIndex:courseIndex]valueForKey:@"tee"];
                NSString * courseString2 = [[courseName stringByAppendingString:@" - "]stringByAppendingString:teeName];
                return courseString2;
            }
                break;
            case 3:
                return [self.lengthArray objectAtIndex:lengthIndex];
                break;
            case 4:
            {
                return [NSString stringWithFormat:@"%@",[self.slopeArray objectAtIndex:row]];
                break;
            }
            case 5:
                return [NSString stringWithFormat:@"%@",[self.ratingArray objectAtIndex:row]];
                break;
                
            default:
                break;
        }
            
        case 1:
            switch (pickerView.tag)
        {
            case 5:
                return [NSString stringWithFormat:@"%ld",(long)row];
                break;
                
            default:
                return 0;
                break;
        }
            
        default:
            return 0;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        _teeValue.text=[_teeColors objectAtIndex:row];
        teeIndex = row;
    }
    
    if(pickerView.tag ==2)
    {
        NSInteger slope     =[[[_coursesArray objectAtIndex:row] valueForKey:@"slope"]integerValue];
        double    rating    =[[[_coursesArray objectAtIndex:row] valueForKey:@"rating"]doubleValue]+.0001;
        NSInteger ratingInt = rating;
        double    ratingDecimal = rating -(double)ratingInt;
        
        ratingIndex1 = ratingInt-55;
        ratingIndex2 = ratingDecimal * 10;
        slopeIndex   = slope - 55;
        
        
        _courseNameValue.text =[[_coursesArray objectAtIndex:row] valueForKey:@"name"];
        _teeValue.text= [[_coursesArray objectAtIndex:row] valueForKey:@"tee"];
        _slopeValue.text = [NSString stringWithFormat:@"%ld",(long)slope];
        _ratingValue.text =[NSString stringWithFormat:@"%.1f",rating];
        courseIndex = row;

        
        _ratingValue.text =[NSString stringWithFormat:@"%.1f",rating];
        
        
    }
    
    if(pickerView.tag == 3)
    {
        [self.roundLength setFont:[UIFont systemFontOfSize:14]];
        self.roundLength.text =[_lengthArray objectAtIndex:row];
        lengthIndex = row;
    }
    
    if(pickerView.tag == 4)
    {
        self.slopeValue.text = [NSString stringWithFormat:@"%@",[self.slopeArray objectAtIndex:row]];
        slopeIndex = row;
    }
    
    if(pickerView.tag == 5)
    {
        double wholeNumber = [pickerView selectedRowInComponent:0]+55;
        double decimal = [pickerView selectedRowInComponent:2];
        
        double ratingReturn = wholeNumber + (decimal/10);
        _ratingValue.text = [NSString stringWithFormat:@"%.1f",ratingReturn];
        
        if(component ==0)
            ratingIndex1 = row;
        else if (component == 2)
            ratingIndex2 = row;
        else return;
    }
}

- (void) dismissKeyboard
{
	[_courseNameValue resignFirstResponder];
	[_teeValue resignFirstResponder];
	[_dateValue resignFirstResponder];
	[_slopeValue resignFirstResponder];
	[_existingRoundText resignFirstResponder];
    [_roundLength resignFirstResponder];
}
- (IBAction)toolbarSetup:(id)sender
{
    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:NO]];
}


- (void)nextDidTouchDown
{
	if (_courseNameValue.isFirstResponder)
		[self.teeValue becomeFirstResponder];
	else if (_teeValue.isFirstResponder)
		[self.dateValue becomeFirstResponder];
	else if (_dateValue.isFirstResponder)
		[self.roundLength becomeFirstResponder];
     else if (self.roundLength.isFirstResponder)
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
    else if (self.roundLength.isFirstResponder)
		[self.dateValue becomeFirstResponder];
	else if (_ratingValue.isFirstResponder)
		[self.roundLength becomeFirstResponder];
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
	//else 	[self dismissKeyboard:self];
}


-(void)courseAlert
{
    [self dismissKeyboard];
    
    UIActionSheet * courseActionSheet = [[UIActionSheet alloc]initWithTitle:@"Is this a new or existing course?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Course",@"Existing Course", nil];
    [courseActionSheet showInView:self.view];

	/*UIActionSheet *courseAlert = [[UIActionSheet alloc]
								initWithTitle:nil
								message:@"Is this a new or existing course?"
								delegate:self
								cancelButtonTitle:nil
								otherButtonTitles: @"New",@"Existing", nil];
	//[courseAlert show];
     */

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
   
    if([buttonTitle isEqualToString:@"New Course"])
    {
        [self.courseNameValue becomeFirstResponder];
    }
    
    else if([buttonTitle isEqualToString:@"Existing Course"])
    {
        if([[[ParseData sharedParseData]roundCount]integerValue]==0)
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
			[self dismissKeyboard];
			[self.existingRoundText becomeFirstResponder];
            
		}

    }
        
    
}

- (IBAction)showCoursePicker:(id)sender
{
	UIPickerView * coursePicker= [[UIPickerView alloc] init];
	coursePicker.delegate=self;
	coursePicker.showsSelectionIndicator=YES;
	coursePicker.tag=2;
	[self.existingRoundText setInputView:coursePicker];
    [self toolbarSetup:self.existingRoundText];
    
	_coursesArray=[self.parseData.uniqueCourseArray mutableCopy];
	_courseNameValue.text =[[_coursesArray objectAtIndex:0] valueForKey:@"name"];
	_teeValue.text= [[_coursesArray objectAtIndex:0] valueForKey:@"tee"];
	_slopeValue.text = [NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:0] valueForKey:@"slope"]];

    
    NSInteger slope     =[[[_coursesArray objectAtIndex:0] valueForKey:@"slope"]integerValue];
    double    rating    =[[[_coursesArray objectAtIndex:0] valueForKey:@"rating"]doubleValue]+.0001;
    NSInteger ratingInt = rating;
    double    ratingDecimal = rating -(double)ratingInt;
    
    _ratingValue.text =[NSString stringWithFormat:@"%.1f",rating];
    ratingIndex1 = ratingInt-55;
    ratingIndex2 = ratingDecimal * 10;
    slopeIndex   = slope - 55;
    
   
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
   	if ([buttonTitle isEqualToString:@"New"])
	{
        [self.courseNameValue becomeFirstResponder];
	}
    
	else if ([buttonTitle isEqualToString:@"Existing"])
	{
        
		if([[[ParseData sharedParseData]roundCount]integerValue]==0)
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
			[self dismissKeyboard];
			[self.existingRoundText becomeFirstResponder];
            
		}
	}
    else if ([buttonTitle isEqualToString:@"Upgrade"])
	{
		[PFPurchase buyProduct:@"com.mygolfinsight.mygolfstats.fullversionupgrade" block:^(NSError *error) {
			if (!error) {
				UIAlertView *succesfulUpgradeAlert = [[UIAlertView alloc]initWithTitle:@"Upgrade Complete" message:@"Thank you for upgrading. Would you like to review the MyGolf Stats app?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No Thanks", @"Leave Review", nil];
				[succesfulUpgradeAlert show];
                [self.parseData upgradeToFullVersion];
			}
			else
            {
               NSLog(@" Error = %@",error);
                return;
            }
		}];
	}
    else if ([buttonTitle isEqualToString:@"Leave Review"])
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/mygolf-handicap-calculator/id759479888?mt=8&ign-mpt=uo%3D4"]];
	}

}

-(void)disableAllUIElements
{
    self.courseNameValue.enabled = NO;
    self.teeValue.enabled = NO;
    self.dateValue.enabled = NO;
    self.ratingValue.enabled = NO;
    self.slopeValue.enabled = NO;
    self.createRoundButton.enabled=NO;
}

-(void)enableTextBoxes
{
    self.courseNameValue.enabled = YES;
    self.teeValue.enabled = YES;
    self.dateValue.enabled =YES;
    self.ratingValue.enabled = YES;
    self.slopeValue.enabled = YES;
}

-(BOOL)checkForLiteVersion
{
	BOOL fullVersion = [[NSUserDefaults standardUserDefaults] boolForKey:@"MyGolfStatsFullVersion"];
    
	if(fullVersion== NO)
    {
		if([[[ParseData sharedParseData]roundCountWithHoleData]integerValue]>=3)
            return NO;
    }
    
    return YES;
}



@end
