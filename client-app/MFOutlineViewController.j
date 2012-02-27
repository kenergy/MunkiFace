/**
	Provides the main CPOutlineView with a datasource and delegate. Also observes
	the selected value of the catalogs CPPopUpButton and adjusts the contentns of
	the CPOutlineView accordingly.
 */
@implementation MFOutlineViewController : CPObject
{
	MFTreeModel _tree;
	@outlet CPOutlineView outlineView;
}




-(void)awakeFromCib
{
	var manifests = [MFManifests sharedManifests];
	[manifests addObserver:self forKeyPath:@"manifestTree" options:nil
	context:nil];
}




- (void)observeValueForKeyPath:(id)aPath ofObject:(id)anObject
	change:(id)aChange context:(id)aContext
{
	if ([aPath isEqualToString:@"manifestTree"])
	{
		_tree = [anObject manifestTree];
		[outlineView reloadItem:nil];
	}
}




/**
	Responds accordinly when the selection in the CPOutlineView changes.
	The KVO bindings in the cib are bound to the 'activePackage' path, so really
	all we need to do is reassign the selected package to that value using
	setActivePackage:, the bindings to the rest of the work to update the values
	in the package details view.
 */
- (void)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	console.log("Selection changed");
	var selectedRow = [[aNotification object] selectedRow];
	[self setActivePackage: [_outlineView itemAtRow:selectedRow]];
}









/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) outlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		return [[_tree childItems] objectAtIndex:index];
	}
	return [[item childItems] objectAtIndex:index];
}




- (BOOL)outlineView:(CPOutlineView) outlineView isItemExpandable:(id)item
{
	return [item isLeaf] == NO;
}




- (int)outlineView:(CPOutlineView) outlineView numberOfChildrenOfItem:(id)item
{
	if (item == nil)
	{
		return [_tree numberOfChildren];
	}
	else
	{
		return [item numberOfChildren];
	}
}




- (id)outlineView:(CPOutlineView) outlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return nil == item ? [_tree itemName] : [item itemName];
}
@end
