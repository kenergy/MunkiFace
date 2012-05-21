/**
	This category of MFTreeModel makes MFTreeModel capable of sorting itself and
	its children.
 */
@implementation MFTreeModel (Sorting)


/**
	Recursively sorts the child items of the current MFTreeModel instance. If you
	need to sort the entire tree, you should send this message like so:
	<code>[[anItem rootItem] sortChildItems];</code>.

	This method starts off by sorting its own children and then sends each of
	those children then same message. The sort is done by comparing the itemName
	of each child in a case sensative manner. If case insensative is preferred,
	this woul be the place to change it.
 */
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
