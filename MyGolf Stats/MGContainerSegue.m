//
//  MGContainerSegue.m
//  MyGolf Stats
//
//  Created by Todd Bohannon on 3/8/14.
//  Copyright (c) 2014 Todd Bohannon. All rights reserved.
//

#import "MGContainerSegue.h"

@implementation MGContainerSegueForward

- (void)perform
{

		UIViewController *source = self.sourceViewController;
		UIViewController *destination = self.destinationViewController;
		UIViewController *container = source.parentViewController;

		[container addChildViewController:destination];
		destination.view.frame = source.view.frame;
		[source willMoveToParentViewController:nil];

		[container transitionFromViewController:source
							   toViewController:destination
									   duration:0.75
										options:UIViewAnimationOptionTransitionFlipFromRight
									 animations:^{
									 }
									 completion:^(BOOL finished) {
										 [source removeFromParentViewController];
										 [destination didMoveToParentViewController:container];
									 }];
}


@end

@implementation MGContainerSegueBack

- (void)perform
{

	UIViewController *source = self.sourceViewController;
	UIViewController *destination = self.destinationViewController;
	UIViewController *container = source.parentViewController;

	[container addChildViewController:destination];
	destination.view.frame = source.view.frame;
	[source willMoveToParentViewController:nil];

	[container transitionFromViewController:source
						   toViewController:destination
								   duration:0.75
									options:UIViewAnimationOptionTransitionFlipFromLeft
								 animations:^{
								 }
								 completion:^(BOOL finished) {
									 [source removeFromParentViewController];
									 [destination didMoveToParentViewController:container];
								 }];
}


@end

@implementation MGContainerSegueCurl

- (void)perform
{

	UIViewController *source = self.sourceViewController;
	UIViewController *destination = self.destinationViewController;
	UIViewController *container = source.parentViewController;

	[container addChildViewController:destination];
	destination.view.frame = source.view.frame;
	[source willMoveToParentViewController:nil];

	[container transitionFromViewController:source
						   toViewController:destination
								   duration:0.75
									options:UIViewAnimationOptionTransitionCurlUp
								 animations:^{
								 }
								 completion:^(BOOL finished) {
									 [source removeFromParentViewController];
									 [destination didMoveToParentViewController:container];
								 }];
}


@end
