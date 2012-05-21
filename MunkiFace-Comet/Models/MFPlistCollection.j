var MFPlistCollectionINSTANCE = nil;


@implementation MFPlistCollection : MFNetworkLongPollingDataSource
{
	MFTreeModel treeModel @accessors;
}


- (id)init
{
	if (MFPlistCollectionINSTANCE == nil)
	{
		self = [super init];
		if (self)
		{
			connectionCount = 0;
			[self setDataSourceURI:@"server/polling.php"];
			[self reloadData];
			MFPlistCollectionINSTANCE = self;
		}
	}
	return MFPlistCollectionINSTANCE;
}



+ (id)sharedCollection
{
	if (MFPlistCollectionINSTANCE == nil)
	{
		[[MFPlistCollection alloc] init];
	}
	return MFPlistCollectionINSTANCE;
}




- (void)dataDidReload:(id)someData
{
	// Let MFNetworkLongPollingDataSource store the results in the data ivar and
	// reinitiate the connection for future change notifications.
	[super dataDidReload:someData];

	var changedObj = [[self data] objectForKey:@"changed"];
	var createdObj = [[self data] objectForKey:@"created"];
	var removedObj = [[self data] objectForKey:@"removed"];

	var numChanged = [changedObj count];
	var numCreated = [createdObj count];
	var numRemoved = [removedObj count];

	if ([self treeModel] == nil)
	{
		treeModel = [[MFTreeModel alloc] init];
		[treeModel setItemName:@"ROOT"];
	}
	// First, we'll add in the new files
	for (var i = 0; i < numCreated; i++)
	{
		var key = [[createdObj allKeys] objectAtIndex:i];
		var obj = [createdObj objectForKey:key];
		[treeModel addDescendant:obj atNamespace:key];
	}

	// Next we'll look for any modified files and refresh them
	for (var i = 0; i < numChanged; i++)
	{
		var key = [[changedObj allKeys] objectAtIndex:i];
		var obj = [changedObj objectForKey:key];
		[treeModel addDescendant:obj atNamespace:key];
	}


	// Finally, we'll remove any objects that have been deleted.
	for (var i = 0; i < numRemoved; i++)
	{
		var key = [@"ROOT" stringByAppendingString:
			[[removedObj allKeys] objectAtIndex:i]];
		var obj = [treeModel descendantWithNamespace:key];
		if (obj != nil)
		{
			var bereavedParent = [obj parentItem];
			[bereavedParent removeChild:obj];
		}
	}
	[treeModel sortChildItems];
	[self setTreeModel:treeModel];
}
@end
