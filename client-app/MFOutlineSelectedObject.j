/**
	This class will accept an MFTreeModel instance, extract the object's path and
	ask the server for the full details about that object. The intent here is for
	this class to be extended and built upon such that a selected manifest or
	package from the outline view can be programatically loaded with data from the
	server on each selection. This will prevent the entire database from needing
	to be loaded into memory all at once.

	\class MFOutlineSelectedObject
	\extends MFNetworkDataSource
 */
@implementation MFOutlineSelectedObject : MFNetworkDataSource
{
	MFTreeModel representedModel @accessors;
	CPDictionary data @accessors;
}




/**
	Accepts an instance of MFTreeModel, examines its itemNamespace string and asks
	the server for the full contents of the file.
 */
- (void)setRepresentedModel:(MFTreeModel)aTreeModel
{
	representedModel = aTreeModel;

	var path = [aTreeModel itemNamespace];
	[self setDataSourceURI:[MF_SERVER_URI stringByAppendingString:
		@"?controller=readFile&file=" + path]];
	[self reloadData];
}




/**
	Used to set the url hash when a model has changed.
 */
- (void)updateURLHash
{
	window.location.hash = "#" + [[self representedModel] itemNamespace];
}




/**
	When data is received from the server, this method is called. The data that's
	returned is set to the data field and then a call is made to
	MFOutlineSelectedObject::updateURLHash to make sure the address bar contents
	change according to the selected object.
 */
- (void)dataDidReload:(CPDictionary)someData
{
	[self setData:someData];
	[self updateURLHash];
}
@end
