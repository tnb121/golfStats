//
//  MGSettingsViewController.h
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>

@interface MGSettingsViewController :UITableViewController <MFMailComposeViewControllerDelegate,SKProductsRequestDelegate,UITableViewDelegate>

@property (strong,nonatomic) NSArray * availableClubs;

@property (strong,nonatomic)SKProduct * product;
@property (strong, nonatomic) IBOutlet UILabel *UpgradeLabel;
@property (strong, nonatomic) IBOutlet UISwitch *trackingMethodSwitch;
@property (strong, nonatomic) IBOutlet UITableView *staticTable;

@property (weak, nonatomic) IBOutlet UITableViewCell *facebookTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *twitterTableViewCell;
@property (strong,nonatomic) IBOutlet UIButton   *facebookButton;
@property (strong,nonatomic) IBOutlet UIButton   *twitterButton;



@end
