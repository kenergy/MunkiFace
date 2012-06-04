/**
	This class isn't meant to be initialized on its own, but rather is more like
	an abstract class that wraps around an MFTreeModel data structure and adheres
	to the CPOutlineViewDatasource protocol.
	It also provides mechanisms for reconstructing the MFTreeModel structure from
	a provided URI.

	The derived 'outlinewView' and 'setOutlineView' methods exist to provide some
	automatic interaction between the receiver and the representing outline view.
	If it's not nil, a call to reloadData will instruct this object to fetch new
	data from the server and then instruct the CPOutlineView to refresh re-request
	data from its datasource (e.g. this object).

	The derived 'dataSourceURI' and 'setDataSourceURI' methods can be used to
	change the represented data on the fly. For example, you could in theory
	change the dataSourceURI before calling reloadData to end up with a completely
	different data set in the resulting CPOutlineView while only using one
	instance of this class.

	One last derived set of methods is 'treeModel' and 'setTreeModel'. This simply
	provides access to the underlying data structure. Note: a call to treeModel
	before a call to reloadData will return nil since there hasn't yet been a need
	to created the object.

	\ingroup client-models
 */
@implementation MFOutlineViewController : CPObject
{
	@accessors MFTreeModel treeModel;
	MFTreeModel arrangedObjects;
	CPOutlineView representedView @accessors;
	CPPredicate filterPredicate @accessors;
	int dataCategory @accessors;
	BOOL sortsManifestsByInheritance @accessors;
}




#pragma mark - Initialization




/**
	Constructs a new instance of the receiver using an existing CPOutlineView.
 */
- (id)initWithRepresentedView:(CPOutlineView)anOutlineView
{
	self = [super init];
	if (self)
	{
		// setup the outline view's datasource and delegate
		[self setRepresentedView:anOutlineView];
		var collection = [MFPlistCollection sharedCollection];
		[collection addObserver:self
			forKeyPath:@"treeModel"
			options:nil
			context:nil];
		[anOutlineView setDataSource:self];
		[anOutlineView setDelegate:self];
	}
	return self;
}




#pragma mark -
#pragma mark - Data category switching logic




/**
	When the data category changes from the user selecting an option in the
	segmented control, this method will modify its arrangedObjects to reflect the
	appropriate data set. The arrangedObjects property is being observed by the
	CPOutlineView and should update automatically when the arrangedObjects value
	changes.
 */
- (void)setDataCategory:(int)aCategory
{
	if (aCategory == nil)
	{
		aCategory = MFMainViewDefaultSelection;
	}
	dataCategory = aCategory;
	[self refreshDataInCurrentCategory];
	[[self representedView] reloadItem:nil];
	if (filterPredicate != nil)
	{
		[self setFilterPredicate:filterPredicate];
	}
}




/**
	Ensures that the proper data category is loaded into arrangedObjects.
 */
- (void)refreshDataInCurrentCategory
{
	switch([self dataCategory])
	{
		case MFMainViewManifestSelection:
			arrangedObjects = [treeModel childWithName:@"manifests"];
			break;
		case MFMainViewCatalogSelection:
			arrangedObjects = [treeModel childWithName:@"catalogs"];
			break;
		case MFMainViewPkgsinfoSelection:
			arrangedObjects = [treeModel childWithName:@"pkgsinfo"];
			break;
	}
}




#pragma mark -
#pragma mark Handle CPPredicate searches




/**
	Creates a CPPredicate object from the given string and passes it to
	setFilterPredicate:. If the given string is empty, this will call
	removeFilterPredicate.
 */
- (void)setFilterString:(CPString)aString
{
	if ([aString isKindOfClass:[CPSearchField class]])
	{
		aString = [aString stringValue];
	}
	if (aString == nil || [aString length] == 0)
	{
		[self removeFilterPredicate];
	}
	else
	{
		var predicate = [CPPredicate
			predicateWithFormat:@"itemName contains[cd] %@", aString];
		[self setFilterPredicate:predicate];
	}
}




/**
	Accepts a CPPredicate objects and filters the arranged objects based on
	matches.
 */
- (void)setFilterPredicate:(CPPredicate)aPredicate
{
	filterPredicate = aPredicate;
	// we have to reset the data set to the unfiltered version before we can
	// filter, otherwise backspacing a search would do nothing until the saerch
	// field is empty
	[self refreshDataInCurrentCategory];
	arrangedObjects = [arrangedObjects subtreeFilteredByPredicate:filterPredicate];
	[[self representedView] reloadItem:nil];
}




/**
	Removes any filtering and allows the objects to be arranged in tree-mode
	again.
 */
- (void)removeFilterPredicate
{
	filterPredicate = nil;
	[self setDataCategory:[self dataCategory]];
}




- (void)outlineViewSelectionDidChange:(id)aNotification
{
	var item = [representedView itemAtRow:[representedView selectedRow]];
	if ([item isLeaf])
	{
		CPLog.debug("Outline view selection changed to" + [item itemName]);
	}
}




#pragma mark -
#pragma mark CPOutlineView DataSource




- (id)outlineView:(CPOutlineView) anOutlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		return [[arrangedObjects childItems] objectAtIndex:index];
	}
	return [[item childItems] objectAtIndex:index];
}




- (BOOL)outlineView:(CPOutlineView) anOutlineView isItemExpandable:(id)item
{
	return [item isLeaf] == NO;
}




- (int)outlineView:(CPOutlineView) anOutlineView numberOfChildrenOfItem:(id)item
{
	if (item == nil)
	{
		return [arrangedObjects numberOfChildren];
	}
	else
	{
		return [item numberOfChildren];
	}
}




- (id)outlineView:(CPOutlineView) anOutlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return nil == item ? [self treeModel] : item;
}




#pragma mark -
#pragma mark - KVO logic




- (void)observeValueForKeyPath:(CPString)aPath ofObject:(id)anObject
	change:(id)changes context:(void)theChanges
{
	if ([aPath isEqualToString:@"treeModel"])
	{
		[self setTreeModel:[anObject treeModel]];
		[self setDataCategory:[self dataCategory]];
	}
}




#pragma mark -
@end
