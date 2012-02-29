/**
	Provides the main CPOutlineView with a datasource and delegate. Also observes
	the selected value of the catalogs CPPopUpButton and adjusts the contentns of
	the CPOutlineView accordingly.
 */
@implementation MFManifestsOutlineDataSource : MFOutlineDataSource


-(void)awakeFromCib
{
	var uri = [[[CPBundle mainBundle] infoDictionary]
				objectForKey:@"MunkiFace Server URI"];
	uri = [uri stringByAppendingString:@"?controller=manifests"];

	[self setAlsoBecomeDelegate:YES];
	[self setDataSourceURI:uri];
	[self reloadData];
}




- (void)outlineViewSelectionDidChange:(id)aNotification
{
	var anOutlineView = [aNotification object];
	var item = [anOutlineView itemAtRow:[anOutlineView selectedRow]];
	console.log([item itemNamespace]);
}
@end
