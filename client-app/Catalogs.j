@import "Pkg.j"
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
	Pkg _selectedPkg;
}




- (id)init
{
	if (CATALOGS_INSTANCE == nil)
	{
		self = [super init];
		if (self)
		{
			var uri = [[[CPBundle mainBundle] infoDictionary] objectForKey:@"MunkiFace Server URI"];
			var request = [CPURLRequest requestWithURL:uri + "?controller=catalogs"];
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
		return item;
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
