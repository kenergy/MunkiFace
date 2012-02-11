/**
	Stores the catalog information from the server. For now this is a
	load-at-boot class, but it will eventually be able to reoad the data from
	the server and possibly even write some information, such as package
	descriptions, back to the server.
 */

var MF_PACKAGES_INSTANCE = nil;

@implementation MFPackages : CPObject
{
	CPMutableDictionary _packagesCollection;
	@outlet CPOutlineView _outlineView;
}




- (id)init
{
	if (MF_PACKAGES_INSTANCE == nil)
	{
		self = [super init];
		if (self)
		{
			var uri = [[[CPBundle mainBundle] infoDictionary]
				objectForKey:@"MunkiFace Server URI"];
			var request = [CPURLRequest requestWithURL:
				uri + "?controller=pkgsinfo"];
			var connection = [CPURLConnection connectionWithRequest:request
				delegate:self];
		}
		MF_PACKAGES_INSTANCE = self;
	}
	return MF_PACKAGES_INSTANCE;
}




+ (id)sharedPackages
{
	if (MF_PACKAGES_INSTANCE == nil)
	{
		return [[MFPackages alloc] init];
	}
	return MF_PACKAGES_INSTANCE;
}




/**
	Returns the entire data collection as returned by the server.
	\returns CPDictionary
 */
- (id)allPackages
{
	return _packagesCollection;
}





/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) outlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		var key = [[_packagesCollection allKeys] objectAtIndex:index];
		return [_packagesCollection objectForKey:key];
	}
	return [item objectAtIndex:index];
}




- (BOOL)outlineView:(CPOutlineView) outlineView isItemExpandable:(id)item
{
	return 0 < [self outlineView:outlineView numberOfChildrenOfItem:item];
}




- (int)outlineView:(CPOutlineView) outlineView numberOfChildrenOfItem:(id)item
{
	return item == nil ? [_packagesCollection count] : [item count];
}




- (id)outlineView:(CPOutlineView) outlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return nil == item ? @"" : [item objectValueForOutlineColumn:tableColumn];
}






/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)data
{
	var pkgs = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	_packagesCollection = [CPMutableDictionary dictionary];

	var pkgsKeys = [pkgs allKeys];
	for (var i = 0; i < [pkgsKeys count]; i++)
	{
		var key = [pkgsKeys objectAtIndex:i];
		var row = [pkgs objectForKey:key];
		var pkg = [[MFPackage alloc] initWithKey:key andDictionary:row];
		[_packagesCollection setObject:pkg forKey:key];
	}
	[_outlineView reloadItem:nil];
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end