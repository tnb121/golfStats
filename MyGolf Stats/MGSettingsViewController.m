//
//  MGSettingsViewController.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 1/10/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGSettingsViewController.h"

@interface MGSettingsViewController ()

@end

@implementation MGSettingsViewController

@synthesize availableClubs;

@synthesize product=_product;
@synthesize UpgradeLabel=_UpgradeLabel;
@synthesize trackingMethodSwitch;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

	switch(indexPath.section)
	{
		case 0://Settings
		break;

		case 1://Resources
			switch (indexPath.row)
			{
				case 0:
					[self goToUSGASWebsite:nil];
					[PFAnalytics trackEvent:@"USGA Website"];
					break;

				case 1:
					[self goToMyGolfInsightWebsite:nil];
					[PFAnalytics trackEvent:@"MyGolfInsight.com"];
					break;
			}
        break;
            
		case 2: //Social Media
			switch (indexPath.row)
			{
			case 0:
				//Facebook
				break;

			case 1:
				//Twitter
				break;

			}
        break;
		
        case 3: //Feedback
			switch (indexPath.row)
			{
			case 0:
				[self goToITunesFeedback:nil];
				break;
			case 1:
				[self emailFeedback:nil];
				break;
			}
        break;
		
        case 4: // In App purchases
			switch (indexPath.row)
			{
			case 0:
				[self upgradeToFullVersion];
				break;
			case 1:
				[PFPurchase restore];
				break;
			}
        break;
		
        case 5: // Logout
			[PFUser logOut];
			[self.tabBarController setSelectedIndex:0];
			[self.tabBarController.view setNeedsDisplay];
			self.tabBarController.selectedIndex=0;
			[PFAnalytics trackEvent:@"logout"];
			break;
	}

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    [self facebookTableViewCellSetup];
    [self twitterTableViewCellSetup];
    
    BOOL fullVersion = [[NSUserDefaults standardUserDefaults] boolForKey:@"MyGolfStatsFullVersion"];
    
	if(fullVersion== YES)
    {
		_UpgradeLabel.text = @"Using Full Version - Thank You";
    }

	self.staticTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"App Background"]];

	self.availableClubs = @[@"Driver",@"3-Wood",@"5-Wood",@"7-Wood",@"2-Iron",@"3-Iron",@"4-Iron",@"5-Iron",@"6-Iron",@"7-Iron",@"8-Iron",@"9-Iron",@"Pitching Wedge",@"Gap Wedge",@"Approach Wedge",@"Sand Wedge",@"Lob Wedge",@"Putter"];

	if([[[NSUserDefaults standardUserDefaults]valueForKey:@"shotTracking"] isEqualToString:@"hole"])
		[self.trackingMethodSwitch setOn:NO];
	else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"shotTracking"] isEqualToString:@"shot"])

		[self.trackingMethodSwitch setOn:YES];
	else
		{
			[self.trackingMethodSwitch setOn:NO];
			[[NSUserDefaults standardUserDefaults]setValue:@"hole" forKey:@"shotTracking"];
		}

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)trackingMethodTouched:(id)sender
{
	if ([self.trackingMethodSwitch isOn])
		[[NSUserDefaults standardUserDefaults]setValue:@"shot" forKey:@"shotTracking"];
	else
		[[NSUserDefaults standardUserDefaults]setValue:@"hole" forKey:@"shotTracking"];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToUSGASWebsite:(id)sender;
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.usga.org/Rule-Books/Handicap-System-Manual/Rule-10/"]];
}

- (void)goToGHINWebsite:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ghin.com/solutions.aspx?id=72&libID=93"]];
}

- (void)goToMyGolfInsightWebsite:(id)sender;
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mygolfinsight.com"]];
}

- (void)goToITunesFeedback:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/mygolf-handicap-calculator/id759479888?mt=8&ign-mpt=uo%3D4"]];
}

- (void)emailFeedback:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"MyGolf Stats Feedback";
    // Email Content
    NSString *messageBody = @"\n\n\n\n sent via the MyGolf Stats App";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"feedback@mygolfinsight.com"];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)upgradeToFullVersion
{

	if([[NSUserDefaults standardUserDefaults] boolForKey:@"MyGolfStatsFullVersion"]==YES)
	{
		UIAlertView *versionAlert = [[UIAlertView alloc]
									 initWithTitle:nil
									 message:@"You are already using the full version of the MyGolf Stats App."
									 delegate:self
									 cancelButtonTitle:@"OK"
									 otherButtonTitles: nil];
		[versionAlert show];
	}
	else
		[PFPurchase buyProduct:@"com.mygolfinsight.mygolfhandicap.fullversionupgrade" block:^(NSError *error) {
			if (!error)
			{
				UIAlertView *succesfulUpgradeAlert = [[UIAlertView alloc]initWithTitle:@"Upgrade Complete" message:@"Thank you for upgrading. Would you like to review the MyGolf Handicap Calculator app?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No Thanks", @"Leave Review", nil];
				[succesfulUpgradeAlert show];
			}
			else NSLog(@" Error = %@",error);
		}];


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];

    if ([buttonTitle isEqualToString:@"Leave Review"])
	{
		[self goToITunesFeedback:nil];
	}
	if ([buttonTitle isEqualToString:@"Upgrade"])
	{
		[PFPurchase buyProduct:@"com.mygolfinsight.mygolfhandicap.fullversionupgrade" block:^(NSError *error) {
			if (!error)
			{
				UIAlertView *succesfulUpgradeAlert = [[UIAlertView alloc]initWithTitle:@"Upgrade Complete" message:@"Thank you for upgrading. Would you like to review the MyGolf Handicap Calculator app?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No Thanks", @"Leave Review", nil];
				[succesfulUpgradeAlert show];
			}
			else NSLog(@" Error = %@",error);
		}];
	}
}

/*
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender

{
	if ([[segue identifier] isEqualToString:@"definitionSegue"])
	{
		DefinitionViewController* vc = (DefinitionViewController*)segue.destinationViewController;

		vc.definitionItemText = self.defItem;
		vc.definitionDetalText=self.defDetail;
	}
}
*/

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	NSArray * identifiers = @[@"com.mygolfinsight.mygolfhandicap.fullversionupgrade"];
	[self validateProductIdentifiers:identifiers];

}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[PFAnalytics trackEvent:@"Information Page"];
}

-(void)facebookTableViewCellSetup
{
    NSString * linkedString = nil;
    
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
        linkedString = @"Link Facebook Account";
    else
        linkedString = @"Unlink Facebook Account";
    
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.facebookButton.frame = CGRectMake(65,6, 225, 30);
    self.facebookButton.tag = 1;
    [self.facebookButton setTitle:linkedString forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.facebookButton.layer.cornerRadius = 8;
    UIColor *lightBlue = [UIColor colorWithRed:54.0/255 green:100.0/255.0 blue:162.0/255.0 alpha:1];
    self.facebookButton.layer.backgroundColor = lightBlue.CGColor;
    self.facebookButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.facebookButton addTarget:self action:@selector(facebookLinkUnlink) forControlEvents:UIControlEventTouchDown];
    [self.facebookTableViewCell.contentView addSubview:self.facebookButton];
    
   // FBLoginView *loginView = [[FBLoginView alloc] initWithFrame:CGRectMake(100,2,200, 30.0)];
    //[self.facebookTableViewCell.contentView addSubview:loginView];
}

-(void)twitterTableViewCellSetup
{
    NSString * linkedString = nil;
    
    if (![PFTwitterUtils isLinkedWithUser:[PFUser currentUser]])
        linkedString = @"Link Twitter Account";
    else
        linkedString = @"Unlink Twitter Account";
    
    self.twitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.twitterButton.frame = CGRectMake(65,6, 225, 30);
    self.twitterButton.tag = 2;
    [self.twitterButton setTitle:linkedString forState:UIControlStateNormal];
    [self.twitterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.twitterButton.layer.cornerRadius = 8;
    UIColor *lightBlue = [UIColor colorWithRed:94.0/255 green:169.0/255.0 blue:221.0/255.0 alpha:1];
    self.twitterButton.layer.backgroundColor = lightBlue.CGColor ;
    self.twitterButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.twitterButton addTarget:self action:@selector(twitterLinkUnlink) forControlEvents:UIControlEventTouchDown];
    [self.twitterTableViewCell.contentView addSubview: self.twitterButton];
}

-(void)facebookLinkUnlink
{
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
	{
		[PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error)
		 {
             if(error)return;
                [self facebookTableViewCellSetup];
		 }];
	}
    
    else
    {
        [PFFacebookUtils unlinkUser:[PFUser currentUser]];
        [self facebookTableViewCellSetup];
    }
}

-(void)twitterLinkUnlink
{
    if (![PFTwitterUtils isLinkedWithUser:[PFUser currentUser]])
	{
		[PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL succeeded, NSError *error)
		 {
             if(error)return;
                 [self twitterTableViewCellSetup];
		 }];
	}
    
    else
    {
        [PFTwitterUtils unlinkUser:[PFUser currentUser]];
        [self twitterTableViewCellSetup];
    }
}

-    (void) tableView : (UITableView*) tableView
willDisplayHeaderView : (UIView*) view
           forSection : (NSInteger) section
{
    [[((UITableViewHeaderFooterView*) view) textLabel] setTextColor : [UIColor whiteColor] ];
	[[((UITableViewHeaderFooterView*) view) textLabel] setFont:[UIFont boldSystemFontOfSize:16]];
}


-(void)RestoreInAppPurchases
{
	PFQuery *query = [PFUser query];
	[query whereKey:@"username" equalTo:[PFUser currentUser].username];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject* user, NSError * error)
	 {
		 if(!error)
		 {
			 double fullVersion = [[user valueForKey:@"MyGolfStatsFullVersion"]integerValue];

			 if (fullVersion ==0)
			 {
				 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MyGolfStatsFullVersion"];
				 UIAlertView *noInAppPurchaseAlert = [[UIAlertView alloc]initWithTitle:@"Restore Purchases" message:@"You have not yet upgraded to the full version.  Would you like to upgrade now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Upgrade", nil];
				 [noInAppPurchaseAlert show];
			 }
			 else if (fullVersion == 1)
			 {
				 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MyGolfStatsFullVersion"];

				 UIAlertView *restoreInAppPurchaseAlert = [[UIAlertView alloc]initWithTitle:@"Restore Purchases" message:@"Your purchases have been restored" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				 [restoreInAppPurchaseAlert show];
			 }
			 else
			 {
				 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MyGolfStatsFullVersion"];
			 }
		 }
	 }];
}

// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
   // self.product =[response.products objectAtIndex:0];
	//NSLog(@"%@",self.product.price);
	//[self UpgradePrice];
}

-(void)UpgradePrice
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:_product.priceLocale];
	NSString *formattedPrice = [numberFormatter stringFromNumber:_product.price];
	_UpgradeLabel.text=[@"Upgrade to Full Version for " stringByAppendingString:formattedPrice];
}


@end
