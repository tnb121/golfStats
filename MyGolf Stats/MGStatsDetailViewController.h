//
//  MGStatsDetailViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseData.h"
#import "KeyboardController.h"

@interface MGStatsDetailViewController : UIViewController<UITextFieldDelegate,KeyboardControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong,nonatomic) NSArray * holesArray;
@property (strong,nonatomic) NSArray * shotsArray;
@property (strong,nonatomic) ParseData * parseData;

@property (strong,nonatomic) NSString * target;
@property (strong,nonatomic) NSString * start;

@property (strong, nonatomic) IBOutlet UILabel *targetLong;
@property (strong, nonatomic) IBOutlet UILabel *targetLeft;
@property (strong, nonatomic) IBOutlet UILabel *targetHit;
@property (strong, nonatomic) IBOutlet UILabel *targetRight;
@property (strong, nonatomic) IBOutlet UILabel *targetShort;


@property (strong, nonatomic) IBOutlet UISegmentedControl *targetLocation;
@property (strong, nonatomic) IBOutlet UITextField *startingLocation;
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;

@end
