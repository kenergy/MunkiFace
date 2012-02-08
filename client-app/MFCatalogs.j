@import "MFCatalog.j"
/**
	Stores the catalog information from the server. For now this is a
	load-at-boot class, but it will eventually be able to reoad the data from
	the server and possibly even write some information, such as package
	descriptions, back to the server.
 */

var MF_CATALOGS_INSTANCE = nil;

@implementation MFCatalogs : CPObject
{
	CPMutableArray _catalogCollection;
	@outlet CPOutlineView _outlineView;
}




- (id)init
{
	if (MF_CATALOGS_INSTANCE == nil)
	{
		self = [super init];
		if (self)
		{
			var uri = [[[CPBundle mainBundle] infoDictionary]
				objectForKey:@"MunkiFace Server URI"];
			var request = [CPURLRequest requestWithURL:
				uri + "?controller=catalogs"];
			var connection = [CPURLConnection connectionWithRequest:request
				delegate:self];
		}
		MF_CATALOGS_INSTANCE = self;
	}
	return MF_CATALOGS_INSTANCE;
}




+ (id)sharedCatalogs
{
	if (MF_CATALOGS_INSTANCE == nil)
	{
		return [[Catalogs alloc] init];
	}
	return MF_CATALOGS_INSTANCE;
}




/**
	Returns the entire data collection as returned by the server.
	\returns CPDictionary
 */
- (id)catalogs
{
	return _catalogCollection;
}





/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) outlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		return [_catalogCollection objectAtIndex:index];
	}
	return [item objectAtIndex:index];
}




- (BOOL)outlineView:(CPOutlineView) outlineView isItemExpandable:(id)item
{
	return 0 < [self outlineView:outlineView numberOfChildrenOfItem:item];
}




- (int)outlineView:(CPOutlineView) outlineView numberOfChildrenOfItem:(id)item
{
	return item == nil ? [_catalogCollection count] : [item count];
}




- (id)outlineView:(CPOutlineView) outlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return nil == item ? @"" : [item objectValueForOutlineColumn:tableColumn];
}






/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)data
{
	var cat = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	_catalogCollection = [CPMutableArray array];

	var catKeys = [cat allKeys];
	for (var i = 0; i < [catKeys count]; i++)
	{
		var key = [catKeys objectAtIndex:i];
		var row = [cat objectForKey:key];
		var catalog = [[MFCatalog alloc] initWithName:key andData:row];
		[_catalogCollection addObject:catalog];
	}
	[_outlineView reloadItem:nil];

	// Set the initial sorted column to the application's name
//	var descriptor = [CPSortDescriptor sortDescriptorWithKey:@"name"
//												   ascending:YES];
//	[_data sortUsingDescriptors:[CPArray arrayWithObject:descriptor]];
//	[_theTable reloadData];
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
