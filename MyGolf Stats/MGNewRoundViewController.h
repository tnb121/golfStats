//
//  MGNewRoundViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KeyboardController.h"
#import "ParseData.h"

@interface MGNewRoundViewController : UIViewController<UITextFieldDelegate,KeyboardControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate>


@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (strong, nonatomic) NSMutableArray * teeColors;
@property (strong,nonatomic)  NSMutableArray * coursesArray;
@property (strong,nonatomic) NSMutableArray * lengthArray;
@property (strong,nonatomic)  PFGeoPoint *currentLocation;


@property (strong,nonatomic)IBOutlet UITextField *ratingValue;
@property (strong,nonatomic)IBOutlet UITextField *slopeValue;
@property (strong,nonatomic)IBOutlet UITextField *dateValue;
@property (strong,nonatomic)IBOutlet UITextField *courseNameValue;
@property (strong,nonatomic)IBOutlet UITextField * teeValue;
@property (weak, nonatomic) IBOutlet UITextField *roundLength;
@property (strong, nonatomic) IBOutlet UIButton *createRoundButton;

@property (strong, nonatomic) IBOutlet UITextField *existingRoundText;

@end
