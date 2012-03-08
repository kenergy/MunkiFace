/**
	This class isn't meant to be initialized on its own, but rather is more like
	an abstract class that wraps around an MFTreeModel data structure and adheres
	to the CPOutlineViewDatasource protocol.
	It also provides mechanisms for reconstructing the MFTreeModel structure from
	a provided URI.

	The derived 'outlinewView' and 'setOutlineView' methods exist to provide some
	automatic interaction between the receiver and the representing outline view.
	If it's not nil, a call to reloadData will instruct this object to fetch new
	data from the server and then instruct the CPOutlineView to refresh re-request
	data from its datasource (e.g. this object).

	The derived 'dataSourceURI' and 'setDataSourceURI' methods can be used to
	change the represented data on the fly. For example, you could in theory
	change the dataSourceURI before calling reloadData to end up with a completely
	different data set in the resulting CPOutlineView while only using one
	instance of this class.

	One last derived set of methods is 'treeModel' and 'setTreeModel'. This simply
	provides access to the underlying data structure. Note: a call to treeModel
	before a call to reloadData will return nil since there hasn't yet been a need
	to created the object.

	\class MFOutlineDataSource
	\extends MFNetworkDataSource
 */
@implementation MFOutlineDataSource : MFNetworkDataSource
{
	@outlet CPOutlineView outlineView 				@accessors;
						MFTreeModel treeModel						@accessors;
						       BOOL alsoBecomeDelegate	@accessors;
}




/**
	Returns the flag used to determine if the receiver should become the delegate
	for the outline view when it becomes the datasource. Implementing classes that
	want this behavior should set this value to YES during initialization using
	[self setAlsoBecomeDelegate:YES];
 */
- (BOOL)alsoBecomeDelegate
{
	return alsoBecomeDelegate == YES;
}



- (void)setOutlineView:(CPOutlineView)anOutlineView
{
	if (anOutlineView == nil)
	{
		outlineView = nil;
		return;
	}
	outlineView = anOutlineView;
	if ([outlineView dataSource] != nil)
	{
		[[outlineView dataSource] setOutlineView:nil];
	}
	[outlineView setDataSource:self];


	if ([self alsoBecomeDelegate] == YES)
	{
		[outlineView setDelegate:self];
	}

	[outlineView reloadItem:nil];
}




/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) anOutlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		return [[[self treeModel] childItems] objectAtIndex:index];
	}
	return [[item childItems] objectAtIndex:index];
}




- (BOOL)outlineView:(CPOutlineView) anOutlineView isItemExpandable:(id)item
{
	return [item isLeaf] == NO;
}




- (int)outlineView:(CPOutlineView) anOutlineView numberOfChildrenOfItem:(id)item
{
	if (item == nil)
	{
		return [[self treeModel] numberOfChildren];
	}
	else
	{
		return [item numberOfChildren];
	}
}




- (id)outlineView:(CPOutlineView) anOutlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return nil == item ? [[self treeModel] itemName] : [item itemName];
}






/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)dataDidReload:(CPDictionary)someData
{
	[self setTreeModel:[[MFTreeModel alloc] initWithDictionary:someData]];
	if ([self outlineView] != nil)
	{
		[outlineView reloadItem:nil];
	}
}
@end
