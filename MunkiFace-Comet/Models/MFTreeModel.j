/**
	The MFTreeModel takes a CPDictionary and turns it into a structure that is a
	little more akin to a linked list. This makes it a little easier to plug the
	data into something like an outline view.
	\ingroup client-models
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
	var self = [self init];
	if (self)
	{
		[self setRepresentedObject:anObject];
		[self setParentItem:aParentItem];
		[self setItemName:anItemName];
	}
	return obj;
}




- (void)setItemName:(CPString)aName
{
	if (aName == "")
	{
		[CPException raise:YES reason:@"itemName cannot be empty for an MFTreeModel"];
	}
	itemName = aName;
}




/**
	Returns the root object of the MFTreeModel structure.
	\returns MFTreeModel
 */
- (MFTreeModel)rootItem
{
	if ([self parentItem] == nil)
	{
		return self;
	}
	var root = nil;
	var parentNode = [self parentItem];
	while(parentNode != nil)
	{
		root = parentNode;
		parentNode = [parentNode parentItem];
	}
	return root;
}




/**
	Adds a given object to the existing structure at the specified relative
	namespace. This method will always add the object to the namespace starting at
	the receiver. Therefore, you must always use a desired namespace that is
	relative to the receiver's namespace.
	\param anObject The object to wrap in an MFTreeModel object and add to the
	structure.
	\param aNamespace An array of path components representing the desired
	namespace relative to the receiver.
 */
- (void)addDescendant:(id)anObject atRelativeNamespace:(CPArray)aNamespace
{
	var child = nil;
	// If there's only one component, it goes here
	if ([aNamespace count] == 1)
	{
		child = [[MFTreeModel alloc] initWithObject:anObject];
		[child setItemName:[aNamespace firstObject]];
		[self addChild:child];
		return;
	}

	// Make the range needed in order to knock off the first object of the
	// namespace array.
	// - is this the proper range?
	var range = CPMakeRange(1, [aNamespace count] - 1);
	
	
	// if the first object of the namespace matches the itemName of one of this
	// object's children, we'll descend.
	for (var i = 0; i < [self numberOfChildren]; i++)
	{
		child = [childItems objectAtIndex:i];
		if ([child itemName] == [aNamespace firstObject])
		{
			return [child addDescendant:anObject atRelativeNamespace:
				[aNamespace subarrayWithRange:range]];
		}
	}

	// No child was found with the name, so we'll make one.
	child = [[MFTreeModel alloc] init];
	[child setItemName:[aNamespace firstObject]];
	[self addChild:child];
	[child addDescendant:anObject atRelativeNamespace:
		[aNamespace subarrayWithRange:range]];
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
	var currentName = nil;
	var ephemeralChild = nil;
	for (var i = 0; i < [pathChunks count]-1; i++)
	{
		currentName = [pathChunks objectAtIndex:i];
		ephemeralChild = [potentialParent childWithName:currentName];
		if (ephemeralChild == nil)
		{
			ephemeralChild = [[MFTreeModel alloc] init];
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
	var result = nil;
	var child = nil;
	for (var i = 0; i < [childItems count]; i++)
	{
		child = [childItems objectAtIndex:i];
		if ([child itemNamespace] == aNamespace)
		{
			result = child;
			break;
		}
	}
	return result;
}




/**
	Returns the MFTreeModel object whose name is aName. If there are no
	descendents of the receiver with a matching name, \c nil will be returned
	instead.
	\MFTreeModel
 */
- (MFTreeModel)childWithName:(CPString)aName
{
	var result = nil;
	var child = nil;
	for (var i = 0; i < [childItems count]; i++)
	{
		child = [childItems objectAtIndex:i];
		if ([child itemName] == aName)
		{
			result = child;
			break;
		}
	}
	return result;
}




/**
	Returns any descendant of the receiver whose name is aName. If there are no
	descendants of the receiver with a matching name, \c nil will be returned
	instead.
	\MFTreeModel
 */
- (MFTreeModel)descendantWithName:(CPString)aName
{
	var result = [self childWithName:aName];
	var child = nil;
	if (result != nil)
	{
		return result;
	}

	for (var i = 0; i < [childItems count]; i++)
	{
		child = [[childItems objectAtIndex:i] childWithName:aName];
		if (child != nil)
		{
			result = child;
			break;
		}
	}
	return result;
}




/**
	Searches the entire subtree for any descendant whose namespace matches
	aNamespace. If the item cannot be found, nil will be returned instead.
	\returns MFTreeModel
 */
- (MFTreeModel)descendantWithNamespace:(CPString)aNamespace
{
	var descendant = [self childWithNamespace:aNamespace];
	if (descendant != nil)
	{
		return descendant;
	}
	var leafs = [self leafItemsAsNormalizedArray];
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
	if (childItems == nil)
	{
		childItems = [CPMutable array];
	}
	[aTreeModel setParentItem:self];
	[[self childItems] addObject:aTreeModel];
}




/**
	Removes the child item from the receiver.
 */
- (void)removeChild:(MFTreeModel)aTreeModel
{
	if (childItems != nil)
	{
		[[self childItems] removeObject:aTreeModel];
		[aTreeModel setParentItem:nil];
	}
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
	function addLeafItemsForNode_toArray(aNode, anArray)
	{
		if (anArray == nil)
		{
			anArray = [CPMutableArray array];
		}
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

	return addLeafItemsForNode_toArray(self, nil);
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
	return [self numberOfChildren] == 0;
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
