/**
	The MFTreeModel takes a CPDictionary and turns it into a structure that is a
	little more akin to a linked list. This makes it a little easier to plug the
	data into something like an outline view.
 */
@implementation MFTreeModel : CPObject
{
	id representedObject @accessors;
	MFTreeModel parentItem @accessors;
	CPMutableArray childItems @accessors;
	CPString itemName @accessors;
}




- (id)init
{
	self = [super init];
	if (self)
	{
		childItems = [CPMutableArray array];
		[self setRepresentedObject:nil];
	}
	return self;
}




/**
	Initializes and returns a new MFTreeModel object wrapped around anObject.
	\returns MFTreeModel
 */
- (id)initWithObject:(id)anObject
{
	self = [super init];
	if (self)
	{
		childItems = [CPMutableArray array];
		[self setRepresentedObject:anObject];
	}
	return self;
}




/**
	Initializes and returns a new MFTreeModel object wrapped around anObject with
	the aParentItem and anItemName set to aParent and aName respectively.
	\returns MFTreeModel
 */
- (id)initWithObject:(id)anObject parentItem:(MFTreeModel)aParentItem	itemName:(CPString)anItemName
{
	var obj = [self initWithObject:anObject];
	if (obj)
	{
		[obj setParentItem:aParentItem];
		[obj setItemName:anItemName];
	}
	return obj;
}




/**
	Returns the root object of the MFTreeModel structure.
	\returns MFTreeModel
 */
- (MFTreeModel)rootItem
{
	var root = nil;
	var parentNode = [self parentItem];
	while(parentNode != nil)
	{
		root = parentNode;
		parentNode = [parentNode parentItem];
	}
	if (root == nil)
	{
		return self;
	}
	else
	{
		return root;
	}
}




/**
	Adds a given object to the existing structure at the specified namespace. This
	method will always add the object to the namespace provided starting at the
	root object.
*/ 
- (void)addDescendant:(id)anObject atNamespace:(CPString)aNamespace
{
	var root = [self rootItem];
	if ([aNamespace hasPrefix:@"/"])
	{
		aNamespace = [aNamespace substringFromIndex:1];
	}
	var pathChunks = [aNamespace componentsSeparatedByString:@"/"];

	// first we need to make sure that the desired path to the object exists and
	// create it if it doesn't.
	var potentialParent = root;
	for (var i = 0; i < [pathChunks count]-1; i++)
	{
		var currentName = [pathChunks objectAtIndex:i];
		var ephemeralChild = [potentialParent childWithName:currentName];
		if (ephemeralChild == nil)
		{
			ephemeralChild = [[MFTreeModel alloc] initWithObject:nil];
			[ephemeralChild setItemName:currentName];
			[potentialParent addChild:ephemeralChild];
		}
		potentialParent = ephemeralChild;
	}

	// The target parent should now be stored in potentialParent, so we can add
	// the leaf item and its corresponding object.
	var ephemeralLeaf = [[MFTreeModel alloc] initWithObject:anObject];
	[ephemeralLeaf setItemName:[pathChunks lastObject]];
	var potentialUpdate = [potentialParent childWithName:[pathChunks lastObject]];
	if (potentialUpdate != nil)
	{
		[potentialParent removeChild:potentialUpdate];
	}
	[potentialParent addChild:ephemeralLeaf];
}





/**
	Returns the MFTreeModel object whose namespace is aNamespace. If there are
	no descendents of the receiver with a matching namespace, \c nil will be
	returned instead.
 */
- (MFTreeModel)childWithNamespace:(CPString)aNamespace
{
	for (var i = 0; i < [childItems count]; i++)
	{
		var item = [childItems objectAtIndex:i];
		if ([[item itemNamespace] isEqualToString:aNamespace])
		{
			return item;
		}
		else
		{
			var child = [item childWithNamespace:aNamespace];
			if (child != nil)
			{
				return child;
			}
		}
	}
	return nil;
}




/**
	Returns the MFTreeModel object whose name is aName. If there are no
	descendents of the receiver with a matching name, \c nil will be returned
	instead.
	\MFTreeModel
 */
- (MFTreeModel)childWithName:(CPString)aName
{
	for (var i = 0; i < [childItems count]; i++)
	{
		var item = [childItems objectAtIndex:i];
		if ([[item itemName] isEqualToString:aName])
		{
			return item;
		}
		else
		{
			var child = [item childWithName:aName];
			if (child != nil)
			{
				return child;
			}
		}
	}
	return nil;
}




/**
	Searches the entire subtree for any descendant whose namespace matches
	aNamespace. If the item cannot be found, nil will be returned instead.
	\returns MFTreeModel
 */
- (MFTreeModel)descendantWithNamespace:(CPString)aNamespace
{
	var leafs = [self leafItemsAsNormalizedArray];
	var descendant = nil;
	for (var i = 0; i < [leafs count]; i++)
	{
		var leaf = [leafs objectAtIndex:i];
		if ([[leaf itemNamespace] isEqualToString:aNamespace])
		{
			descendant = leaf;
			break;
		}
	}
	return descendant;
}



/**
	Adds a child to the end of the childItems array and sets the new child's
	parentItem to the receiver.
 */
- (void)addChild:(MFTreeModel)aTreeModel
{
	[aTreeModel setParentItem:self];
	[[self childItems] addObject:aTreeModel];
}




/**
	Removes the child item from the receiver.
	\returns MFTreeModel
 */
- (MFTreeModel)removeChild:(MFTreeModel)aTreeModel
{
	[[self childItems] removeObject:aTreeModel];
	[aTreeModel setParentItem:nil];
	return aTreeModel;
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
	if (childItems == nil)
	{
		return 0;
	}
	else
	{
		return [childItems count];
	}
}




/**
	Returns a boolean value indicating that the receiver is a leaf node, meaning
	it has no children.
	\returns BOOL
 */
- (BOOL)isLeaf
{
	return childItems != nil && [self numberOfChildren] == 0;
}




/**
	Returns the value of MFTreeModel::name to make sure the object can be logged
	with a little more meaningful information.
	\returns CPString
 */
-(CPString)description
{
	return [self itemName];
}
@end
