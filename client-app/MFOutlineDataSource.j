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
 */
@implementation MFOutlineDataSource : CPObject
{
					     CPString dataSourceURI 			@accessors;
					 CPURLRequest _dataSourceRequest;
	@outlet CPOutlineView outlineView 				@accessors;
						MFTreeModel treeModel						@accessors;
}



- (id)initWithDataURI:(CPString)aURI
{
	self = [super init];
	if (self)
	{
		[self setDataSourceURI:aURI];
	}
	return self;
}




- (void)setDataSourceURI:(CPString)aURI
{
	dataSourceURI = aURI;
	_dataSourceRequest = [CPURLRequest requestWithURL:dataSourceURI];
}




/**
	Asks for new data at dataSourceURI and sets 'self' as the delegate.
 */
- (id)reloadData
{
	var connection = [CPURLConnection connectionWithRequest:_dataSourceRequest
		delegate:self];
}



/*-----------------------CPOutlineView DataSource Methods---------------------*/
- (id)outlineView:(CPOutlineView) anOutlineView child:(CPInteger)index
  ofItem:(id)item
{
	if (item == nil)
	{
		return [[[self treeModel] childItems] objectAtIndex:index];
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
		return [[self treeModel] numberOfChildren];
	}
	else
	{
		return [item numberOfChildren];
	}
}




- (id)outlineView:(CPOutlineView) anOutlineView
  objectValueForTableColumn:(CPTableColumn) tableColumn byItem:(id)item
{
	return nil == item ? [[self treeModel] itemName] : [item itemName];
}






/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)data
{
	var dict = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	[self setTreeModel:[[MFTreeModel alloc] initWithDictionary:dict]];
	if ([self outlineView] != nil)
	{
		[outlineView reloadItem:nil];
	}
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
