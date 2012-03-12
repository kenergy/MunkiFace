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
	@outlet @accessors CPOutlineView outlineView;
	@outlet CPSearchField searchField;
	@accessors MFTreeModel treeModel;
	CPString _manifestsURI;
	CPString _pkgsinfoURI;
}





/**
	Configures the instance as needed from the CIB.
	Sets the URI for the manifests and pkgsinfo data sources on the server.
 */
-(void)awakeFromCib
{
	var baseURI = [[[CPBundle mainBundle] infoDictionary]
		objectForKey:@"MunkiFace Server URI"];
	_manifestsURI = [baseURI stringByAppendingString:@"?controller=manifests"];
	_pkgsinfoURI = [baseURI stringByAppendingString:@"?controller=pkgsinfo"];

	// ------- This whole section is a hack
	// Something in nib2cib changes the CPSearchField in a way that it will never
	// send search strings on anything other than hitting enter.
	var oldFrame = [searchField frame];
	var oldBounds = [searchField bounds];
	var oldSuperview = [searchField superview];
	[searchField removeFromSuperview];
	[searchField release];

	var newSearchField = [[CPSearchField alloc] initWithFrame:CGRectMake(
		-157.0,
		49.0,
		248.0,
		30.0
	)];
	[newSearchField setSendsSearchStringImmediately:YES];
	[newSearchField setTarget:self];
	[newSearchField setAction:@selector(searchDidChange:)];
  [newSearchField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];

	searchField = newSearchField;
	[oldSuperview addSubview:newSearchField];
	// ------- end hack
}




- (void)outlineViewSelectionDidChange:(id)aNotification
{
	var item = [outlineView itemAtRow:[outlineView selectedRow]];
	if ([item isLeaf])
	{
		if ([[self dataSourceURI] isEqualToString:_manifestsURI])
		{
			[[MFManifest sharedInstance] setRepresentedModel:item];
		}
		else
		{
			[[MFPkgsInfo sharedInstance] setRepresentedModel:item];
		}
	}
}




/**
	Reconfigures the instance to represent manifests data and reloads the data
	from the server.
 */
- (void)representManifests
{
	[self setDataSourceURI:_manifestsURI];
	[self reloadData];
}




/**
	Reconfigures the instance to represent pkgsinfo data and reloads the data from
	the server.
 */
- (void)representPkgsInfo
{
	[self setDataSourceURI:_pkgsinfoURI];
	[self reloadData];
}




/**
	Returns the last item that was selected according to
	MFOutlineDataSource::setSelectedItem: or \c nil if no item has been set using
	that method.
 */
- (MFTreeModel)selectedItem
{
	console.log("Selected item is", _selectedItem);
	return _selectedItem;
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




/*----------------------------CPTextFieldDelegate------------------------------*/
-(void)searchDidChange:(id)aSender
{
	console.log([aSender stringValue]);
}
@end
