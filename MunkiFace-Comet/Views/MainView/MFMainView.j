/**
	Represents the Manifest category view
	\var  MFMainViewManifestSelection
	\ingroup client-views
 */
MFMainViewManifestSelection = 0;
/**
	Represents the Catalog category view
	\var  MFMainViewCatalogSelection
	\ingroup client-views
 */
MFMainViewCatalogSelection = 1;
/**
	Represents the Pkgsinfo category view
	\var  MFMainViewPkgsinfoSelection
	\ingroup client-views
 */
MFMainViewPkgsinfoSelection = 2;
/**
	Sets the default (not 'current') category view. Changing this to another value
	will cause the corresponding tab to be selected by default when the applicaton
	loads.
	\var  MFMainViewDefaultSelection
	\ingroup client-views
 */
MFMainViewDefaultSelection = MFMainViewPkgsinfoSelection;



/**
	MFMainView is responsible for drawing the main split view as well as the
	default components of the left side of that split view. Those components are a
	CPSearchField, CPSegmentedControl, and a CPOutlineView embedded in a
	CPScollView. The left pane is also colored blue when it is created.

	Accessors make all of these components available save the split view. Those
	accessors are \c outlineView, \c searchField, and \c segmentedControl. If you
	need access to the split view, the easiest way would be...
	<code>[[mfmainViewInstance subviews] firstObject];</code>

	In addition, this class acts as the delegate for the split view, making sure
	that the left pane is never smaller than 50px and never wider than 350px. When
	this view changes superviews, it will reposition the divider of the split view
	to 245px.
	\ingroup client-views
 */
@implementation MFMainView : CPView
{
	CPSplitView splitView;
	CPOutlineView outlineView @accessors;
	CPSearchField searchField @accessors;
	CPSegmentedControl segmentedControl @accessors;
}


/**
	Please note that the receiver cannot handle an empty rect, so if you give it
	one, do expect the unexpected.
 */
- (MCMainView)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self)
	{
		[self setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
		[self _buildSplitView];
		[self _buildOutlineView];
		[self _buildSearchField];
		[self _buildSegmentedControl];
	}
	return self;
}





#pragma mark - private methods to help build the subviews




- (void)_buildSplitView
{
	splitView = [[CPSplitView alloc] initWithFrame:[self bounds]];
	[splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[splitView setDelegate:self];
	
	var leftView = [[CPView alloc] initWithFrame:CGRectMake(
		0.0, 0.0, 245.0, 200.0)];
	var rightView = [[CPView alloc] initWithFrame:[self bounds]];
	[splitView addSubview:leftView];
	[splitView addSubview:rightView];
	[leftView setBackgroundColor:[CPColor colorWithHexString:@"eef2f8"]];
	[self addSubview:splitView];
}




- (void)_buildSearchField
{
	searchField = [[CPSearchField alloc] initWithFrame:CGRectMake(
		0.0, 0.0, 215.0, 30.0)];
	[searchField setAutoresizingMask:CPViewWidthSizable];
	[searchField sizeToFit];
	[[[splitView subviews] firstObject] addSubview:searchField];
}




- (void)_buildSegmentedControl
{
	// Create the segmentedControl object
	segmentedControl = [[CPSegmentedControl alloc] initWithFrame:
		CGRectMake(31.0, 30.0, 0.0, 30.0)];
	
	[segmentedControl setSegmentCount:3];
	[segmentedControl setLabel:@"Manifests" forSegment:MFMainViewManifestSelection];
	[segmentedControl setTag:MFMainViewManifestSelection
		forSegment:MFMainViewManifestSelection];
	[segmentedControl setLabel:@"Catalogs" forSegment:MFMainViewCatalogSelection];
	[segmentedControl setTag:MFMainViewCatalogSelection
		forSegment:MFMainViewCatalogSelection];
	[segmentedControl setLabel:@"PkgsInfo" forSegment:MFMainViewPkgsinfoSelection];
	[segmentedControl setTag:MFMainViewPkgsinfoSelection
		forSegment:MFMainViewPkgsinfoSelection];


	[segmentedControl setAutoresizingMask: CPViewMinXMargin | CPViewMaxXMargin];
	[[[splitView subviews] firstObject] addSubview:segmentedControl];
}




- (void)_buildOutlineView
{
	// First we need a scroll view
	var leftView = [[splitView subviews] firstObject];
	var outlineScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(
		0.0, 60.0, 245.0, 140.0)];
	[outlineScrollView setAutoresizingMask:
		CPViewHeightSizable | CPViewWidthSizable];
	
	// Now we can build the outline view
	outlineView = [[CPOutlineView alloc] initWithFrame:CGRectMakeZero()];
	var col = [[CPTableColumn alloc] initWithIdentifier:@"id"];

	[outlineView setColumnAutoresizingStyle:
		CPTableViewFirstColumnOnlyAutoresizingStyle];
	[col setWidth:[outlineView frame].size.width];
	[col setDataView:[[MFOutlineDataView alloc] init]];
	[outlineView addTableColumn:col];
	[outlineView setBackgroundColor:[CPColor clearColor]];
	[outlineView setHeaderView:nil];
	[outlineView setAutoresizingMask:CPViewWidthSizable];
		
	[outlineScrollView setDocumentView:outlineView];
	[[[splitView subviews] firstObject] addSubview:outlineScrollView];
}




#pragma mark CPSplitView delegate methods


- (float)splitView:(CPSplitView)aView constrainMinCoordinate:(float)proposedMin
	ofSubviewAt:(int)subviewIndex
{
	if (subviewIndex == 0)
	{
		return [segmentedControl frame].size.width;
	}
	return proposedMin;
}




- (float)splitView:(CPSplitView)aView constrainMaxCoordinate:(float)proposedMax
	ofSubviewAt:(int)subviewIndex
{
	if (subviewIndex == 0)
	{
		return 350.0;
	}
	return proposedMax;
}




/**
	Repositions the divider to 245px from the left side of the new super view.
 */
- (void)viewWillMoveToSuperview:(CPView)aView
{
	[super viewWillMoveToSuperview:aView];
	[splitView setPosition:245.0 ofDividerAtIndex:0];
}
@end
