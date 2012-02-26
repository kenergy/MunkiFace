/**
	The MFTreeModel takes a CPDictionary and turns it into a structure that is a
	little more akin to a linked list. This makes it a little easier to plug the
	data into something like an outline view.
 */
@implementation MFTreeModel : CPObject
{
	MFTreeModel _parentItem;
	CPMutableArray _childItems;
	CPString _nodeName;
}




/**
	Converts a CPDictionary into an MFTreeModel. The dictionary is expected to
	have a very specific structure and was built with the idea of filesystem paths
	in mind.

	For example, the dictionary should contain keys that represent directories.
	Each of those keys point to an array of items within the corresponding
	directory. Each element of the array will contain either a string/number,
	which represents a file, or another dictionary, which represents a directory.
 */
- (id)initWithDictionary:(CPDictionary)aDict
{
	self = [super init];
	if (self)
	{
		_parentItem = nil;
		_childItems = [CPMutableArray array];
		_nodeName = [[aDict allKeys] firstObject];
		[self parseDataStructure:aDict];
	}
	return self;
}




/**
	This is used internally by MFTreeModel and should probably not be used
	directly.
 */
- (id)initWithDictionary:(CPDictionary)aDict andParent:(MFTreeModel)aParent
{
	self = [super init];
	if (self)
	{
		_parentItem = aParent;
		_childItems = [CPMutableArray array];
		_nodeName = [[aDict allKeys] firstObject];
		[self parseDataStructure:aDict];
	}
	return self;
}




- (id)initAsLeafWithNode:(id)aNode andParent:(MFTreeModel)aParent
{
	self = [super init];
	if (self)
	{
		_parentItem = aParent;
		_childItems = nil;
		_nodeName = aNode;
	}
	return self;
}




- (void)parseDataStructure:(CPDictionary)aDict
{
	// Look at each item in the parent dictionary
	for(var i = 0; i < [aDict count]; i++)
	{
		// look at each node it the current dictionary object
		var childNodes = [aDict objectForKey:[[aDict allKeys] objectAtIndex:i]];
		for(var j = 0; j < [childNodes count]; j++)
		{
			var childNode = [childNodes objectAtIndex:j];

			// Create a child instance of MFTreeNode for each subdirectory found
			if ([[childNode class] isSubclassOfClass:[CPDictionary class]])
			{
				[_childItems addObject:
					[[MFTreeModel alloc] initWithDictionary:childNode andParent:self]
				];
			}

			// ... and a leaf node for each subitem that is not a directory
			else
			{
				[_childItems addObject:
					[[MFTreeModel alloc] initAsLeafWithNode:childNode andParent:self]
				];
			}
		}
	}
}




- (MFTreeModel)parentItem
{
	return _parentItem;
}




- (CPArray)childItems
{
	return _childItems;
}




- (int)numberOfChildren
{
	if (_childItems == nil)
	{
		return 0;
	}
	else
	{
		return [_childItems count];
	}
}




- (BOOL)isLeaf
{
	return [self numberOfChildren] == 0;
}




- (CPString)nodeName
{
	return _nodeName;
}
@end
