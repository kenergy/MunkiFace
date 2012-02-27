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




/**
	This is used internally by MFTreeModel and should probably not be used
	directly.
 */
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




/**
	This is used internally by MFTreeModel and should probably not be used
	directly.
 */
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




/**
	Returns the parent MFTreeModel object if there is one, or nil if this is the
	top of the structure.
	\returns MFTreeModel
 */
- (MFTreeModel)parentItem
{
	return _parentItem;
}




/**
	Calculates the textual path or namespace to this object within the
	datastructure in the form of a relative URI. For example:
	"manifests/apps/Firefox"
	\returns CPString
 */
- (CPString)itemNamespace
{
	var path = @"";
	var obj = self;

	while(obj != nil)
	{
		if ([obj isLeaf])
		{
			path = [obj itemName];
		}
		else
		{
			path = [[obj itemName] stringByAppendingFormat:@"/%@", path];
		}
		obj = [obj parentItem];
	}
	return path;
}




/**
	Returns the CPArray of child MFTreeModel objects contained within this one.
	\returns CPArray
 */
- (CPArray)childItems
{
	return _childItems;
}




/**
	Returns a CPArray containing a normalized list of all objects in the receiver
	that are leaf nodes. In terms of a file listing, it's a pretty easy way to
	condense the structure into an array of all of the files that are represented
	without regard to their home on the filesystem.
	\returns CPArray
 */
- (CPArray)leafItemsAsNormalizedArray
{
	var items = [CPMutableArray array];
	
	function addLeafItemsForNode_toArray(aNode, anArray)
	{
		var children = [aNode childItems];
		for(var i = 0; i < [children count]; i++)
		{
			var child = [children objectAtIndex:i];
			if ([child isLeaf])
			{
				[anArray addObject:child];
			}
			else
			{
				anArray = addLeafItemsForNode_toArray(child, anArray);
			}
		}
		return anArray;
	}

	return addLeafItemsForNode_toArray(self, items);
}




/**
	Returns the number of child MFTreeModel objects represented by the receiver.
	\returns int
 */
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




/**
	Returns a boolean value indicating that the receiver is a leaf node, meaning
	it has no children.
	\returns BOOL
 */
- (BOOL)isLeaf
{
	return [self numberOfChildren] == 0;
}




/**
	Returns the name of the receiver. When the MFTreeModel data structure
	represents a filesystem, this can be thought of as the name of a folder or if
	the receiver is a leaf node, the name of the file it represents.
	\returns CPString
 */
- (CPString)itemName
{
	return _nodeName;
}




-(CPString)description
{
	return [self itemName];
}
@end
