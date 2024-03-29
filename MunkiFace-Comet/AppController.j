/*
 * AppController.j
 * MunkiFace-Test
 *
 * Created by You on May 19, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Models/Models.j"
@import "Views/Views.j"
@import "Controllers/Controllers.j"


MFImageNameAddTemplate = @"MFImageNameAddTemplate";
MFImageNameRemoveTemplate = @"MFImageNameRemoveTemplate";

/**
	The primary application controller for the client app.
	\ingroup client-app
 */
@implementation AppController : CPObject
{
	MFMainViewController mainViewController @accessors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{

	// Set up a few image names
	var add = [[CPImage alloc]
		initWithContentsOfFile:@"Resources/MFImageNameAddTemplate.png"
		size:CGSizeMake(11, 12)];
	var remove = [[CPImage alloc]
		initWithContentsOfFile:@"Resources/MFImageNameRemoveTemplate.png"
		size:CGSizeMake(11, 4)];
	[add setName:MFImageNameAddTemplate];
	[remove setName:MFImageNameRemoveTemplate];
	[add release];
	[remove release];

	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
		contentView = [theWindow contentView];
	
	[theWindow orderFront:self];
	
	[self setMainViewController: [[MFMainViewController alloc] init]];
	[mainViewController setContentViewController:
		[[MFLoadingViewController alloc] init]];

	var mainView = [mainViewController view];
	[mainView setFrame:[contentView bounds]];
	[contentView addSubview:[mainViewController view]];
	var collection = [[MFPlistCollection alloc] init];


	// Set up the toolbar
	var toolbar = [[CPToolbar alloc] initWithIdentifier:@"Controls"];
	[toolbar setVisible:YES];
	[theWindow setToolbar:toolbar];


  // Set up the logo window
	var logoWindow = [[CPWindow alloc] initWithContentRect:
		CGRectMake(0, 0, 250, 58)
		styleMask: CPBorderlessWindowMask];
	var logoImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/MFLogo.png"];
	var logoImageView = [[CPImageView alloc] initWithFrame:
		CGRectMake(0, 0, 250, 58)];
	[logoImageView setImage:logoImage];
	[[logoWindow contentView] addSubview:logoImageView];
	[logoWindow setHasShadow:NO];
	[logoWindow setIgnoresMouseEvents:YES];
	[logoWindow setBackgroundColor: [CPColor clearColor]];
	[logoWindow orderFront:self];
	

	// Uncomment the following line to turn on the standard menu bar.
	//[CPMenu setMenuBarVisible:YES];

	[[CPNotificationCenter defaultCenter] addObserver:self
		selector:@selector(outlineDataCategoryDidChange:)
		name:OutlineViewDataCategoryDidChangeNotification object:nil];
}




- (void)outlineDataCategoryDidChange:(CPNotification)aNotification
{
	var outlineViewController = [aNotification object];
	var dataCategory = [outlineViewController dataCategory];
	switch (dataCategory)
	{
		case MFMainViewManifestSelection:
			[mainViewController setContentViewController:
				[[MFManifestViewController alloc] init]];
			break;

		case MFMainViewCatalogSelection:
		case MFMainViewPkgsinfoSelection:
		default:
			[mainViewController setContentViewController:
				[[MFEmptyViewController alloc] init]];
	}
}

@end
