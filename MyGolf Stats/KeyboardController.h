//
//  KeyboardController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/14/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyboardControllerDelegate

- (void)nextDidTouchDown;
- (void)previousDidTouchDown;
- (void)doneDidTouchDown;
@end

@interface KeyboardController : NSObject

- (UIToolbar*)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled;
@property (nonatomic, strong) id <KeyboardControllerDelegate> delegate;

@end
