/*
 * AppController.j
 * MunkiFace
 *
 * Created by Joe Wollard on January 25, 2012.
 * Copyright 2012, MunkiFace All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <LPKit/LPKit.j>
@import <SCAuth/SCUSerSessionManager.j>
@import "MunkiFace.j"
@import "DownloadableTextField.j"


@implementation AppController : CPObject
{
	@outlet	MFApplicationViewController appViewController;
	@outlet	CPWindow theWindow;
}




- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	// make sure the MFServerSettings class has a chance to load its data before
	// anything in the application attempts to use that data.
	[MFServerSettings sharedSettings];
	var mainView = [[[CPApplication sharedApplication] arguments] firstObject];
	if (mainView == "pkgsinfo")
	{
		[appViewController setMainViewController:MFApplicationViewPkgsInfo];
	}
	else
	{
		[appViewController setMainViewController:MFApplicationViewManifests];
	}
}




- (void)awakeFromCib
{
	[theWindow setFullPlatformWindow:YES];
	
	var img = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle]
		pathForResource:@"NSTexturedFullScreenBackgroundColor.png"]];
	var bgColor = [CPColor colorWithPatternImage:img];
	[[theWindow contentView] setBackgroundColor:bgColor];

}




/**
	Handles the click event for the "Rebuild Catalogs" toolbar item. Currently it
	just displays a placeholder sheet window, but it will probably be replaced
	with a progress indicator.
 */
- (IBAction)rebuildCatalogs:(id)aSender
{
	[appViewController displaySheet];
}




/**
	Dismisses the sheet window displayed by rebuildCatalogs based on the click
	event of a button that is on that sheet. Kinda has to be on that sheet since
	the sheet is modal.
 */
- (IBAction)dismissSheet:(id)aSender
{
	[appViewController dismissSheet];
}




/**
	When a tool bar button is clicked, this method determins which button was
	clicked based on its tag and takes the appropriate action.
 */
- (IBAction)toolbarButtonClicked:(id)aButton
{
	[appViewController setMainViewController:[aButton tag]];
}
@end
