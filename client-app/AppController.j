/*
 * AppController.j
 * MunkiFace
 *
 * Created by You on January 25, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <LPKit/LPKit.j>
@import "MFCatalogsController.j"
@import "MFOutlineViewController.j"
@import "MFPackages.j";


@implementation AppController : CPObject
{
	@outlet CPWindow	theWindow;
	@outlet CPView		installerInfoView;
	@outlet LPMultiLineTextField textField;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
	var img = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle]
		pathForResource:@"NSTexturedFullScreenBackgroundColor.png"]];
	var bgColor = [CPColor colorWithPatternImage:img];
	[[theWindow contentView] setBackgroundColor:bgColor];

	[installerInfoView setBackgroundColor: [CPColor whiteColor]];
}

@end
