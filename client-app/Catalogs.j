@import "Pkg.j"
@import "Catalog.j"
/**
	Stores the catalog information from the server. For now this is a
	load-at-boot class, but it will eventually be able to reoad the data from
	the server and possibly even write some information, such as package
	descriptions, back to the server.
 */

var CATALOGS_INSTANCE = nil;

@implementation Catalogs : CPObject
{
	CPDictionary _data;
	@outlet CPOutlineView _outlineView;
}




- (id)init
{
	if (CATALOGS_INSTANCE == nil)
	{
		self = [super init];
		if (self)
		{
			var request = [CPURLRequest
				requestWithURL:@"/MunkiFace/server-app/?controller=catalogs"];
			var connection = [CPURLConnection connectionWithRequest:request
				delegate:self];
			_data = [CPDictionary dictionary];
		}
		CATALOGS_INSTANCE = self;
	}
	return CATALOGS_INSTANCE;
}




+ (id)sharedCatalogs
{
	if (CATALOGS_INSTANCE == nil)
	{
		return [[Catalogs alloc] init];
	}
	return CATALOGS_INSTANCE;
}




/**
	Returns the entire data collection as returned by the server.
	\returns CPDictionary
 */
- (id)catalogs
{
	return _data;
}





/*------------------------CPTableView DataSource Methods----------------------*/
- (void)tableView:(CPTableView)tableView
  sortDescriptorsDidChange:(CPArray)oldDescriptors
{
	[_data sortUsingDescriptors:[tableView sortDescriptors]];
	[tableView reloadData];
}




- (int)numberOfRowsInTableView:(CPTableView) aTableView
{
	return [_data count];
}




- (id)tableView:(CPTableView) aTableView
  objectValueForTableColumn:(CPTableColumn)aColumn row:(int)aRowIndex
{
	var pkg = [[Pkg alloc] initWithDictionary:[_data objectAtIndex:aRowIndex]];
	var colId = [aColumn identifier];
	if (colId == @"display_name")
	{
		return [pkg name];
	}
	else if (colId == @"catalog")
	{
		return [pkg catalogsAsString];
	}
	else if (colId == @"installer_item_size")
	{
		return [pkg bytesFormatted];
	}
	else if (colId == @"uninstallable")
	{
		return [pkg uninstallable];
	}
	else if (colId == @"autoremove")
	{
		return [pkg autoRemove];
	}

	return [pkg objectForKey:colId];
}





/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) outlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == null)
	{
		return [[_data allKeys] objectAtIndex:index];
	}
	else
	{
		return [[_data objectForKey:item] objectAtIndex:index];
	}
}




- (BOOL)outlineView:(CPOutlineView) outlineView isItemExpandable:(id)item
{
	if (item == null || [[_data allKeys] containsObject:item])
	{
		return YES;
	}
	return NO;
}




- (int)outlineView:(CPOutlineView) outlineView numberOfChildrenOfItem:(id)item
{
	var isCatalog = [[_data allKeys] containsObject:item];

	if (item == null)
	{
		return [_data count];
	}
	else if (isCatalog)
	{
		return [[_data objectForKey:item] count];
	}
	return  0;
}




- (id)outlineView:(CPOutlineView) outlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	var isCatalog = [[_data allKeys] containsObject:item];
	
	if (isCatalog)
	{
		return item + " (" + [[_data objectForKey:item] count] + ")";
	}
	else
	{
		return [item objectForKey:@"name"];
	}
	return @"";
}






/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)data
{
	var cat = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	_data = cat;//[cat objectForKey:@"all"];
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
