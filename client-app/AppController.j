/*
 * AppController.j
 * MunkiFace
 *
 * Created by Joe Wollard on January 25, 2012.
 * Copyright 2012, MunkiFace All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <LPKit/LPKit.j>
@import "MunkiFace.j"
@import "DownloadableTextField.j"


@implementation AppController : CPObject
{
	@outlet CPWindow	theWindow;
	@outlet CPView	rebuildCatalogsSheet;
	@outlet CPView mainView;
	CPViewController mainViewController;
	CPViewController manifestsViewController;
	CPViewController packagesViewController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
		packagesViewController = [[CPViewController alloc]
			initWithCibName:@"Packages" bundle:nil];
		[packagesViewController view];
		var tmp = [[MFManifests alloc] init];
}

- (void)awakeFromCib
{
	[theWindow setFullPlatformWindow:YES];
	
	var img = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle]
		pathForResource:@"NSTexturedFullScreenBackgroundColor.png"]];
	var bgColor = [CPColor colorWithPatternImage:img];
	[[theWindow contentView] setBackgroundColor:bgColor];


	manifestsViewController = [[CPViewController alloc]
		initWithCibName:@"Manifests" bundle:nil];
	mainViewController = manifestsViewController;
	[self prepareMainViewControllerForDisplay];
	[mainView addSubview:[mainViewController view]];
}




- (IBAction)rebuildCatalogs:(id)aSender
{
	var sheet = [[CPWindow alloc] initWithContentRect:[rebuildCatalogsSheet
	frame] styleMask:CPDocModalWindowMask];
	[[sheet contentView] addSubview:rebuildCatalogsSheet];
	[CPApp beginSheet:sheet
		 modalForWindow:theWindow
		  modalDelegate:self
		 didEndSelector:nil
		    contextInfo:nil];
}




- (IBAction)dismissSheet:(id)aSender
{
	[CPApp endSheet:[aSender window]];
}




- (IBAction)toolbarButtonClicked:(id)aButton
{
	if ([mainViewController view])
	{
		[[mainViewController view] removeFromSuperview];
	}
	switch(parseInt([aButton tag]))
	{
		case 1:
			mainViewController = manifestsViewController;
			break;
		case 2:
			mainViewController = packagesViewController;
			break;
	}
	[self prepareMainViewControllerForDisplay];
	[mainView addSubview:[mainViewController view]];
}




- (void)prepareMainViewControllerForDisplay
{
	[[mainViewController view] setFrame:[mainView bounds]];
	[[mainViewController view] setAutoresizingMask:CPViewHeightSizable |
		CPViewWidthSizable];
}
@end
