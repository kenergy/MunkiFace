/**
	Provides the main CPOutlineView with a datasource and delegate.
 */
@implementation MFPkgsInfoOutlineDataSource : MFOutlineDataSource


-(void)awakeFromCib
{
	var uri = [[[CPBundle mainBundle] infoDictionary]
				objectForKey:@"MunkiFace Server URI"];
	uri = [uri stringByAppendingString:@"?controller=pkgsinfo"];

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
