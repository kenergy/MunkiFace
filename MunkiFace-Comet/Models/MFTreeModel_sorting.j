@implementation MFTreeModel (Sorting)


- (void)sortChildItems
{
	// First we'll descend into the child objects themselves and get those
	// sorted.
	for (var i = 0; i < [self numberOfChildren]; i++)
	{
		var child = [childItems objectAtIndex:i];
		[child sortChildItems];
	}

	// and now we'll sort our own children.
	[childItems sortUsingFunction:function(left, right)
	{
		return [[left itemName] compare:[right itemName]];
	}
	context:nil];
}

@end
