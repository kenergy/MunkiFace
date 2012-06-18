/**
MFTreeModel behaves a bit link a doubly linked list only it can have multiple
children, hence a 'tree model'.

The tree always starts with an object with title "ROOT" which has no represented
object. ROOT has three children; **pkgsinfo**, **manifests**, and **catalogs**.
Each node within the tree links to its parent via its parentItem method and the
ROOT object via the rootItem method. The tree can easily be reorganized using
the setParent method on any node other than ROOT.

---

##Searching
MFTreeModel supports predicate searching. Simply pass a predicate to the subtreeFilteredByPredicate method on any node, and you'll receive a subtree of that node matching the predicate.
	\ingroup client-models

##About Namespaces
Namespaces in MFTreeModel are intended to represent a textual path to the
object. Since the server provides the data payload which feeds into the tree by
scanning a directory structure, it makes sense that the namespace is intended to
represent the file on the filesystem.

In addition, if a new object is added to the filesystem, the server will let us
know about it and will include its directory path. That path is generally used
by the ROOT object to figure out where it should insert the object into the
tree. Likewise, if a file is deleted, it is quickly removed from the tree using
its namespace which avoids any temptation to iterate over the entire tree to
find the object.

## Accessors
Objective-J accessors aren't parsed very nicely by Doxygen, so here's a list of
accessors available on any MFTreeModel object.
- **representedObject** The data (usually a dictionary) represented by the node.
- **parentItem** a quick way to read and set the parent node.
- **childItems** provides direct access to the array of child nodes for the
	receiver.
- **itemName** the title that is to be used when representing the object in the
	outlineview or other UI components.
 */
@implementation MFTreeModel : CPObject
{
	/** The object represented by this tree */
	id representedObject @accessors;
	/** The parent MFTreeModel */
	MFTreeModel parentItem @accessors;
	/** The array of MFTreeModels that are children of the receiver */
	CPMutableArray childItems @accessors;
	/** The `name` of the receiver */
	CPString itemName @accessors;
}




- (void)encodeWithCoder:(CPCoder)coder
{
	[coder encodeObject:representedObject forKey:@"representedObject"];
//	[coder encodeObject:parentItem forKey:@"parentItem"];
	[coder encodeObject:childItems forKey:@"childItems"];
	[coder encodeObject:itemName forKey:@"itemName"];
}




#pragma mark - Initialization
/** @name Initialization
@{*/



- (id)init
{
	self = [super init];
	if (self)
	{
		childItems = [CPMutableArray array];
	}
	return self;
}




- (id)initWithCoder:(CPCoder)coder
{
	[self init];
	[self setRepresentedObject:[coder decodeObjectForKey:@"representedObject"]];
//	[self setParentItem:[coder decodeObjectForKey:@"parentItem"]];
	[self setChildItems:[coder decodeObjectForKey:@"childItems"]];
	[self setItemName:[coder decodeObjectForKey:@"itemName"]];
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



/** @}*/
#pragma mark -
#pragma mark - Accessing data
/** @name Accessing data
@{*/




/**
	Returns the object that is represented by the receiver. setRepresentedObject
	is also available via accessors.
	\returns id
 */
- (id)representedObject
{
	return representedObject;
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
	Proxy to itemName to make MFOutlineDataView happy.
 */
- (CPString)title
{
	return [self itemName];
}




/**
	Returns a boolean value indicating that the receiver is a leaf node, meaning
	it has no children.
	\returns BOOL
 */
- (BOOL)isLeaf
{
	return [self numberOfChildren] == 0 && representedObject != nil;
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




/** @} */
#pragma mark -
#pragma mark - Modifying data
/** @name Modifying data
@{*/




- (void)setParentItem:(MFTreeModel)newParent
{
	if (newParent == nil)
	{
		// Can't really do that since an object with a nil parent would represent
		// the root node
		return;
	}

	// Avoid any attempts to add the receiver to itself or to its existing parent
	if (newParent != self && parentItem != newParent)
	{	
		if (parentItem != nil)
		{
			[parentItem removeChild:self];
		}
		parentItem = newParent;
		[[parentItem childItems] addObject:self];
	}
}




- (void)setItemName:(CPString)aName
{
	if (aName == "")
	{
		aName = @"<an item name>";
	}
	itemName = aName;
}




/** @}*/
#pragma mark -
#pragma mark - Adding child items
/** @name Adding child items
@{*/



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
	var currentName = [aNamespace firstObject];
	if (currentName == "")
	{
		// we're probably at the end of the namespace and there was a trailing "/",
		// so we don't actually want to create a new object here.
		return;
	}

	// If there's only one component, it goes here
	if ([aNamespace count] == 1)
	{
		child = [[MFTreeModel alloc] initWithObject:anObject];
		[child setItemName:currentName];
		[self addChild:child];
		return;
	}

	// Make the range needed in order to knock off the first object of the
	// namespace array.
	var range = CPMakeRange(1, [aNamespace count] - 1);
	
	
	// if the first object of the namespace matches the itemName of one of this
	// object's children, we'll descend.
	for (var i = 0; i < [self numberOfChildren]; i++)
	{
		child = [childItems objectAtIndex:i];
		if ([child itemName] == currentName)
		{
			return [child addDescendant:anObject atRelativeNamespace:
				[aNamespace subarrayWithRange:range]];
		}
	}

	// No child was found with the name, so we'll make one.
	child = [[MFTreeModel alloc] init];
	[child setItemName:currentName];
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
		if (currentName == "")
		{
			continue;
		}
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
	Adds a child to the end of the childItems array and sets the new child's
	parentItem to the receiver.
 */
- (void)addChild:(MFTreeModel)aTreeModel
{
	if (childItems == nil)
	{
		childItems = [CPMutableArray array];
	}
	[aTreeModel setParentItem:self];
}



/** @} */
#pragma mark -
#pragma mark - Removing child items
/** @name Removing child items
@{ */



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



/** @} */
#pragma mark -
#pragma mark - Sorting and filtering
/** @name Sorting and Filtering
@{ */



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




/**
	Returns a new MFTreeModel that is filtered based on the given CPPredicate
	object. A copy of the receiver will always be the root of the returned tree,
	whether it matches the predicate or not.
	\returns MFTreeModel
 */
- (MFTreeModel)subtreeFilteredByPredicate:(CPPredicate)aPredicate
{
	var items = [self leafItemsAsNormalizedArray];
	var newTree = [[MFTreeModel alloc] init];
	[newTree setItemName:[self itemName]];
	[newTree setRepresentedObject:[self representedObject]];

	CPLog.debug("MFTreeModel - Evaluating predicate '%@' on '%@'", aPredicate,
	[self itemName]);
	for (var i = 0; i < [items count]; i++)
	{
		var item = [items objectAtIndex:i];
		var matches = NO;
		try
		{
			matches = [aPredicate evaluateWithObject:item];
		}
		catch (e)
		{
			matches = [aPredicate evaluateWithObject:[item representedObject]];
		}
		if (matches)
		{
			var relativeNamespace = [[item itemNamespace]
			stringByReplacingOccurrencesOfString:[self itemNamespace] withString:@""];
			[newTree addDescendant:[item representedObject]
			atRelativeNamespace:[relativeNamespace componentsSeparatedByString:@"/"]];
		}
	}
	return newTree;
}



/** @} */
#pragma mark -
@end
