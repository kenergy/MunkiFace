/**
	Provides the main CPOutlineView with a datasource and delegate. Also observes
	the selected value of the catalogs CPPopUpButton and adjusts the contentns of
	the CPOutlineView accordingly.
 */
@implementation MFOutlineViewController : CPObject
{
	MFPackages						_packages;
	CPString							_selectedCatalog;
	@outlet CPOutlineView	_outlineView;
	@outlet CPPopUpButton	_catalogsPopup;
	@accessors MFPackage	activePackage;
}




- (void)awakeFromCib
{
	_packages = [MFPackages sharedPackages];
}




- (IBAction)catalogSelectionDidChange:(CPPopUpButton)aButton
{
	var activeCat =  [[aButton selectedItem] title];
	if ([activeCat isEqualToString:@"All"])
	{
		_selectedCatalog = nil;
	}
	else
	{
		_selectedCatalog = activeCat;
	}
	[_outlineView deselectAll];
	[_outlineView reloadData];
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
	var selectedRow = [[aNotification object] selectedRow];
	[self setActivePackage: [_outlineView itemAtRow:selectedRow]];
}




/**
	Returns the filtered array of packages that match the selected catalog.
 */
- (CPArray)filteredPackages
{
	if (_selectedCatalog == nil)
	{
		return [_packages allPackages];
	}


	var pkgs = [CPMutableDictionary dictionary];
	for(var i = 0; i < [[_packages allPackages] count]; i++)
	{
		var pkgKey = [[[_packages allPackages] allKeys] objectAtIndex:i];
		var pkg = [[_packages allPackages] objectForKey:pkgKey];
		var pkgCatalogs = [pkg catalogsArray];
		if ([pkgCatalogs containsObject:_selectedCatalog])
		{
			[pkgs setObject:pkg forKey:pkgKey];
		}
	}
	return pkgs;
}









/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) outlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		var key = [[[self filteredPackages] allKeys] objectAtIndex:index];
		return [[self filteredPackages] objectForKey:key];
	}
	return [item objectAtIndex:index];
}




- (BOOL)outlineView:(CPOutlineView) outlineView isItemExpandable:(id)item
{
	return 0 < [self outlineView:outlineView numberOfChildrenOfItem:item];
}




- (int)outlineView:(CPOutlineView) outlineView numberOfChildrenOfItem:(id)item
{
	return item == nil ? [[self filteredPackages] count] : [item count];
}




- (id)outlineView:(CPOutlineView) outlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return nil == item ? @"" : [item objectValueForOutlineColumn:tableColumn];
}
@end
