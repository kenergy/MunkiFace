/**
	This class will accept an MFTreeModel instance, extract the object's path and
	ask the server for the full details about that object. The intent here is for
	this class to be extended and built upon such that a selected manifest or
	package from the outline view can be programatically loaded with data from the
	server on each selection. This will prevent the entire database from needing
	to be loaded into memory all at once.
 */
@implementation MFOutlineSelectedObject : CPObject
{
	MFTreeModel representedModel @accessors;
	CPURLRequest _dataSourceRequest;
	CPString _munkiURI;
	CPDictionary data @accessors;
}




/**
	Accepts an instance of MFTreeModel, examines its itemNamespace string and asks
	the server for the full contents of the file.
 */
- (void)setRepresentedModel:(MFTreeModel)aTreeModel
{
	if (_munkiURI == nil)
	{
		_munkiURI = [[[CPBundle mainBundle] infoDictionary]
			objectForKey:@"MunkiFace Server URI"];
		_munkiURI = [_munkiURI stringByAppendingString:@"?controller=readFile&file="];
	}

	var path = [aTreeModel itemNamespace];
	dataSourceURI = [_munkiURI stringByAppendingString:path];
	_dataSourceRequest = [CPURLRequest requestWithURL:dataSourceURI];
	[self reloadData];
}




/**
	Asks for new data at dataSourceURI and sets 'self' as the delegate.
 */
- (id)reloadData
{
	var connection = [CPURLConnection connectionWithRequest:_dataSourceRequest
		delegate:self];
}




/**
	This is meant to be overridden by implementing classes, so if it's not, we'll
	log an error message to let developers know that.
 */
- (void)dataDidReload
{
	CPLog("If you're implementing MFOutlineSelectedObject, you should reimplement"
		+ " the dataDidReload method so you can update any KVO/KVC properties.");
}




/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)someData
{
	[self setData:[CPDictionary dictionaryWithJSObject:JSON.parse(someData)
		recursively:YES]];
	[self dataDidReload];
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
