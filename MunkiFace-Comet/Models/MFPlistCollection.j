var MFPlistCollectionINSTANCE = nil;


/**
	As a child of MFNetworkLongPollingDataSource, this classs is a singleton
	(otherwise you'd end up with a constant connection to the server for each
	instance). It is responsible for making sure the packages, catalogs and
	manifests data are all kept in sync with the server. This is done by first
	making a call to the server which asks for an initial picture of the
	filesystem. When that call returns data, another request is immediately made
	that asks the server to only tell it about things that are different (files
	that have been added, deleted or modified). The server won't respond until
	there is something to say, but it will keep the connection open as long as the
	server software (Apache) will allow.

	Whether Apache closes the connection or the connection is closed because the
	server had data to send to us, another connection is immediately made to
	continue the cycle and keep things in sync.
 */
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



/**
	This is the preferred meethod of obtaining an instance of this class. The init
	method will do its best to keep multiple instances from being created as well,
	but this method will give you the same results with less overhead.
	\returns MFPlistCollection
 */
+ (id)sharedCollection
{
	if (MFPlistCollectionINSTANCE == nil)
	{
		[[MFPlistCollection alloc] init];
	}
	return MFPlistCollectionINSTANCE;
}




/**
	This is called when the server finally comes back with some data. The data is
	expected to be a dictionary containing at they very least, "changed",
	"created", and "removed" keys. Those keys are examined and the receiver's
	treeModel is updated accordingly.
 */
- (void)dataDidReload:(id)someData
{
	[super dataDidReload:someData];
	if (someData == nil)
	{
		return;
	}
	// Let MFNetworkLongPollingDataSource store the results in the data ivar and
	// reinitiate the connection for future change notifications.

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
