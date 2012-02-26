/**
	Stores the catalog information from the server. For now this is a
	load-at-boot class, but it will eventually be able to reoad the data from
	the server and possibly even write some information, such as package
	descriptions, back to the server.
 */

var MF_MANIFESTS_INSTANCE = nil;

@implementation MFManifests : CPObject
{
	CPArray _manifestArray;
}




- (id)init
{
	if (MF_MANIFESTS_INSTANCE == nil)
	{
		self = [super init];
		if (self)
		{
			var uri = [[[CPBundle mainBundle] infoDictionary]
				objectForKey:@"MunkiFace Server URI"];
			var request = [CPURLRequest requestWithURL:
				uri + "?controller=manifests"];
			var connection = [CPURLConnection connectionWithRequest:request
				delegate:self];
		}
		MF_MANIFESTS_INSTANCE = self;
	}
	return MF_MANIFESTS_INSTANCE;
}




+ (id)sharedManifests
{
	if (MF_MANIFESTS_INSTANCE == nil)
	{
		return [[MFManifestss alloc] init];
	}
	return MF_MANIFESTS_INSTANCE;
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
	// There's probably a better way to do this, but for now I'm using
	// CPDictionary's ability to create a new instance of itself by recursively
	// converting everything in the json object to an objc object, then convert
	// that dictionary into an array.
	var tmp = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	_manifestsArray = [CPMutableArray array];
	for(var i = 0; i < [tmp count]; i++)
	{
		[_manifestsArray addObject:[tmp objectForKey:[[tmp allKeys]
			objectAtIndex:i]]];
	}
	var path = [[_manifestsArray lastObject] objectForKey:@"path"];
	if ([path hasPrefix:@"/"])
	{
		path = [path substringFromIndex:1];
	}
	if ([path hasSuffix:@"/"])
	{
		path = [path substringToIndex:[path length]-1];
	}
	var parts = [path componentsSeparatedByString:@"/"];
	console.log(path);
	console.log(parts);

	// Reload the outline view
	//[_outlineView reloadItem:nil];
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
