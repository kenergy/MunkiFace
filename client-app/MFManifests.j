/**
	Stores the catalog information from the server. For now this is a
	load-at-boot class, but it will eventually be able to reoad the data from
	the server and possibly even write some information, such as package
	descriptions, back to the server.
 */

var MF_MANIFESTS_INSTANCE = nil;

@implementation MFManifests : CPObject
{
	@accessors MFTreeModel manifestTree;
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
		return [[MFManifests alloc] init];
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
	var dict = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	[self setManifestTree:[[MFTreeModel alloc] initWithDictionary:dict]];
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
