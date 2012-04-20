MFApplicationViewManifests = 1;
MFApplicationViewPkgsInfo = 2;

/**
	This class is just a proxy class that can switch between the various views
	available in the application.
 */
@implementation MFApplicationViewController : CPObject
{
	@outlet	CPView sheet @accessors;
	@outlet	CPView mainView;
	@outlet	CPOutlineView mainOutlineView;
					CPViewController mainViewController;
					CPViewController manifestsViewController;
					CPViewController pkgsInfoViewController;
	@outlet	MFOutlineDataSource outlineDataSource;
}




- (void)awakeFromCib
{
	manifestsViewController = [[CPViewController alloc]
		initWithCibName:@"Manifests" bundle:[CPBundle mainBundle]];
	pkgsInfoViewController = [[CPViewController alloc]
		initWithCibName:@"Packages" bundle:[CPBundle mainBundle]];
	[manifestsViewController view];
	[pkgsInfoViewController view];
}




/**
	Accepts one of MFApplicationViewManifests or MFApplicationViewPkgsInfo
	constants as an argument and will bring forward the corresponding view.
	\param anApplicationViewTag
 */
- (void)setMainViewController:(int)anApplicationViewTag
{
	if ([mainViewController view])
	{
		[[mainViewController view] removeFromSuperview];
	}


	switch(anApplicationViewTag)
	{
		// "Manifests" button
		case MFApplicationViewManifests:
			[outlineDataSource representManifests];
			mainViewController = manifestsViewController;
			break;
		// "Packages" button
		case MFApplicationViewPkgsInfo:
			[outlineDataSource representPkgsInfo];
			mainViewController = pkgsInfoViewController;
			break;
		default:
			alert("Unknown view, '" + anApplicationViewTag + "', requested!");
	}
	[self prepareMainViewControllerForDisplay];
	[mainView addSubview:[mainViewController view]];
}




/**
	Displays the application sheet that for now, is just used to indicate that the
	catalogs are being rebuilt.
 */
- (void)displaySheet
{
	var sheetWindow = [[CPWindow alloc] initWithContentRect:[sheet
		frame] styleMask:CPDocModalWindowMask];
	[[sheetWindow contentView] addSubview:sheet];
	[CPApp beginSheet:sheetWindow
		 modalForWindow:[[CPApplication sharedApplication] mainWindow]
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




- (void)prepareMainViewControllerForDisplay
{
	[[mainViewController view] setFrame:[mainView bounds]];
	[[mainViewController view] setAutoresizingMask:CPViewHeightSizable |
		CPViewWidthSizable];
}
@end
