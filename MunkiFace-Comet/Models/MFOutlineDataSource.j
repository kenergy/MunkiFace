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

	\ingroup client-models
 */
@implementation MFOutlineDataSource : MFNetworkDataSource
{
	@accessors MFTreeModel treeModel;
	MFTreeModel arrangedObjects;
	CPOutlineView representedView @accessors;
	int dataCategory @accessors;
}




- (void)setDataCategory:(int)aCategory
{
	if (aCategory == nil)
	{
		aCategory = MFMainViewDefaultSelection;
	}
	switch(aCategory)
	{
		case MFMainViewManifestSelection:
			arrangedObjects = [treeModel childWithName:@"manifests"];
			break;
		case MFMainViewCatalogSelection:
			arrangedObjects = [treeModel childWithName:@"catalogs"];
			break;
		case MFMainViewPkgsinfoSelection:
			arrangedObjects = [treeModel childWithName:@"pkgsinfo"];
			break;
	}
	[[self representedView] reloadItem:nil];
}





- (void)outlineViewSelectionDidChange:(id)aNotification
{
	var item = [representedView itemAtRow:[representedView selectedRow]];
	if ([item isLeaf])
	{
		console.log("Outline view selection changed to" + [item itemName]);
	}
}




/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) anOutlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		return [[arrangedObjects childItems] objectAtIndex:index];
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
		return [arrangedObjects numberOfChildren];
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




- (void)observeValueForKeyPath:(CPString)aPath ofObject:(id)anObject
	change:(id)changes context:(void)theChanges
{
	if ([aPath isEqualToString:@"treeModel"])
	{
		[self setTreeModel:[anObject treeModel]];
		[self setDataCategory:[self dataCategory]];
	}
}
@end
