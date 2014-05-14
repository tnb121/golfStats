//
//  MGHistoryTableTableViewController.h
//  MyGolf Stats
//
//  Created by Todd - Developer on 4/19/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGHistoryTableTableViewController : UIViewController   <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *roundHistoryTableView;

@end
