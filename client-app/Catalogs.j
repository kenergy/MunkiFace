@import "Pkg.j";
/**
	Stores the catalog information from the server. For now this is a
	load-at-boot class, but it will eventually be able to reoad the data from
	the server and possibly even write some information, such as package
	descriptions, back to the server.
 */

var CATALOGS_INSTANCE = nil;

@implementation Catalogs : CPObject
{
	CPArray _data;
	@outlet CPTableView _theTable;
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
			_data = [CPArray array];
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
	console.log([tableView sortDescriptors]);
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






/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)data
{
	var cat = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	_data = [cat objectForKey:@"all"];

	// Set the initial sorted column to the application's name
	var descriptor = [CPSortDescriptor sortDescriptorWithKey:@"name"
												   ascending:YES];
	[_data sortUsingDescriptors:[CPArray arrayWithObject:descriptor]];
	[_theTable reloadData];
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
