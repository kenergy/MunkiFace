/*
 * AppController.j
 * MunkiFace-Test
 *
 * Created by You on May 19, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Views/Views.j"
@import "Models/Models.j"


@implementation AppController : CPObject
{
	MainViewController mainViewController @accessors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
		contentView = [theWindow contentView];
	
	[theWindow orderFront:self];
	
	[self setMainViewController: [[MFMainViewController alloc] init]];
	[mainViewController setContentViewController:
		[[MFEmptyViewController alloc] init]
	];

	var mainView = [mainViewController view];
	[mainView setFrame:[contentView bounds]];
	[contentView addSubview:[mainViewController view]];
	var collection = [[MFPlistCollection alloc] init];
	// Uncomment the following line to turn on the standard menu bar.
	//[CPMenu setMenuBarVisible:YES];
}

@end
