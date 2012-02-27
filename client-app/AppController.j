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
	@outlet	CPView rebuildCatalogsSheet;
	@outlet	CPView mainView;
	@outlet	CPWindow theWindow;
	@outlet	CPOutlineView mainOutlineView;
					CPViewController mainViewController;
					CPViewController manifestsViewController;
					CPViewController packagesViewController;
	@outlet	MFManifestsOutlineDataSource manifestsOutlineDataSource;
}




- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
		packagesViewController = [[CPViewController alloc]
			initWithCibName:@"Packages" bundle:nil];
		[packagesViewController view];
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

	[self changeOutlineViewDataSource:manifestsOutlineDataSource];
}




/**
	Handles the click event for the "Rebuild Catalogs" toolbar item. Currently it
	just displays a placeholder sheet window, but it will probably be replaced
	with a progress indicator.
 */
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




/**
	Dismisses the sheet window displayed by rebuildCatalogs based on the click
	event of a button that is on that sheet. Kinda has to be on that sheet since
	the sheet is modal.
 */
- (IBAction)dismissSheet:(id)aSender
{
	[CPApp endSheet:[aSender window]];
}




/**
	When a tool bar button is clicked, this method determins which button was
	clicked based on its tag and takes the appropriate action.
 */
- (IBAction)toolbarButtonClicked:(id)aButton
{
	if ([mainViewController view])
	{
		[[mainViewController view] removeFromSuperview];
	}


	switch(parseInt([aButton tag]))
	{
		// "Manifests" button
		case 1:
			[self changeOutlineViewDataSource:manifestsOutlineDataSource];
			mainViewController = manifestsViewController;
			break;
		// "Packages" button
		case 2:
			mainViewController = packagesViewController;
			break;
	}
	[self prepareMainViewControllerForDisplay];
	[mainView addSubview:[mainViewController view]];
}




/**
	Interlal mechanism for switching out datasource objects for the primary
	CPOutlineView
 */
- (void)changeOutlineViewDataSource:(MFOutlineDataSource)aDataSource
{
	if ([mainOutlineView dataSource] != nil)
	{
		[[mainOutlineView dataSource] setOutlineView:nil];
	}
	[mainOutlineView setDataSource:aDataSource];
	[aDataSource setOutlineView:mainOutlineView];
}




- (void)prepareMainViewControllerForDisplay
{
	[[mainViewController view] setFrame:[mainView bounds]];
	[[mainViewController view] setAutoresizingMask:CPViewHeightSizable |
		CPViewWidthSizable];
}
@end
