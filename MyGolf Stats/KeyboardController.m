//
//  KeyboardController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/14/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "KeyboardController.h"

@implementation KeyboardController

- (UIToolbar *)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:0];
    [toolbar sizeToFit];

    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];

    UISegmentedControl *leftItems = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    [leftItems setEnabled:prevEnabled forSegmentAtIndex:0];
    [leftItems setEnabled:nextEnabled forSegmentAtIndex:1];
    leftItems.momentary = YES; // do not preserve button's state
    [leftItems addTarget:self action:@selector(nextPrevHandlerDidChange:) forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem *nextPrevControl = [[UIBarButtonItem alloc] initWithCustomView:leftItems];
    [toolbarItems addObject:nextPrevControl];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbarItems addObject:flexSpace];

    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidClick:)];
    [toolbarItems addObject:doneButton];
	[doneButton setEnabled:doneEnabled];

    toolbar.items = toolbarItems;

	[toolbar reloadInputViews];

    return toolbar;
}


- (void)nextPrevHandlerDidChange:(id)sender
{
    if (!self.delegate) return;

    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case 0:
            [self.delegate previousDidTouchDown];
            break;
        case 1:
            [self.delegate nextDidTouchDown];
            break;
        default:
            break;
    }
}

- (void)doneDidClick:(id)sender
{
    if (!self.delegate) return;
    [self.delegate doneDidTouchDown];
}

@end
