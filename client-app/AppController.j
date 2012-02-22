/*
 * AppController.j
 * MunkiFace
 *
 * Created by Joe Wollard on January 25, 2012.
 * Copyright 2012, MunkiFace All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <LPKit/LPKit.j>
@import <MunkiFace/MunkiFace.j>
@import "DownloadableTextField.j"


@implementation AppController : CPObject
{
	@outlet CPWindow	theWindow;
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
}
@end
