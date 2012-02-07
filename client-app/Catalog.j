@import "Pkg.j";
/**
	Stores the catalog information from the server. For now this is a
	load-at-boot class, but it will eventually be able to reoad the data from
	the server and possibly even write some information, such as package
	descriptions, back to the server.
 */

@implementation Catalog : CPObject
{
	CPArray _data;
	@outlet CPTableView _theTable;
}




- (id)initWithCatalogArray:(CPArray)aCatalog
{
	self = [super init];
	if (self)
	{
		_data = aCatalog;
	}
	return self;
}




/**
	Returns the entire represented catalog as returned by the server.
	\returns CPDictionary
 */
- (id)rawCatalog
{
	return _data;
}





/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) outlineView child:(CPInteger)index
  ofItem:(id)item
{
}




- (BOOL)outlineView:(CPOutlineView) outlineView isItemExpandable:(id)item
{
	return NO;
}




- (int)outlineView:(CPOutlineView) outlineView numberOfChildrenOfItem:(id)item
{
	return 0;
}




- (id)outlineView:(CPOutlineView) outlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return @" - ";
}
@end
