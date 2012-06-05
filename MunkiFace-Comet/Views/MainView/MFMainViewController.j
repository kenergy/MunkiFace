
/**
	This controller is responsible for creating an instance of MFMainView,
	managing its "right pane" view via the contentViewController and
	setContentViewController: methods, and responding to changes in the search
	field and segmented control. In addition, it also sets up the data feed for
	the main outline view by creating an instance of MFOutlineDataSource and
	setting it as the outline view's datasource and delegate. Once that is done,
	it adds the MFOutlineDataSource instance as a listener to the
	MFPlistCollection shared instance's keypath "treeModel". This ensures that
	whenever new data comes across the wire and gets piped into MFPlistCollection,
	it will be updated graphically as well; at least as far as this controller is
	capable of ensuring.
	\ingroup client-views
 */
@implementation MFMainViewController : CPViewController
{
	int mainViewSelection @accessors;
	CPSplitView splitView;
	CPOutlineView outlineView @accessors;
	CPOutlineViewController outlineViewController @accessors;
	CPSearchField searchField @accessors;
	CPSegmentedControl segmentedControl @accessors;
	CPViewController contentViewController @accessors;
	MFMainViewSearchController searchController @accessors;
}



/**
	Creates a new instance of MFMainView if needed, connects the outline view to
	its data source and delegate, and adds that data source as a listener to
	MFPlistCollection's "treeModel" keypath. It also sets itself as the target for
	the segmented control changes so they can be registered and appropriate
	actions taken. Those actions are decided in the segmentedControlDidChange
	selector.
 */
- (CPView)view
{
	if (self.view == nil)
	{
		self.view = [[MFMainView alloc] initWithFrame:CGRectMake(
			0.0, 0.0, 500.0, 500.0)];
		[self setOutlineView:[self.view outlineView]];
		[self setSearchField:[self.view searchField]];
		[self setSegmentedControl:[self.view segmentedControl]];

		var sc = [[MFMainViewSearchController alloc]
			initWithSearchField:searchField];
		[self setSearchController:sc];
		
		// setup the outline view's datasource and delegate
		outlineViewController = [[MFOutlineViewController alloc]
			initWithRepresentedView:outlineView];
		[searchController setSearchDelegate:outlineViewController];
		
		// set this instance as the target for the segmented control
		[segmentedControl setTarget:self];
		[segmentedControl setAction:@selector(segmentedControlDidChange:)];
		[segmentedControl setSelectedSegment:MFMainViewDefaultSelection];
	}
	return self.view;
}



/**
	Passing an instance of CPViewController to this method will cause the
	right-side of the screen to be replaced with that CPViewController's view.
 */
- (void)setContentViewController:(CPViewController)aController
{
	contentViewController = aController;
	var splitView = [[[self view] subviews] firstObject];
	[splitView addSubview:[aController view]];
	[[[splitView subviews] objectAtIndex:1] removeFromSuperview];
}




- (IBAction)segmentedControlDidChange:(CPSegmentedControl)aControl
{
	[self setMainViewSelection:[aControl selectedTag]];
	[[outlineView dataSource] setDataCategory:[aControl selectedTag]];
}
@end
