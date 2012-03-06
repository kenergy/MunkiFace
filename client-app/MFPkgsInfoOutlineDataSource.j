/**
	Provides the main CPOutlineView with a datasource and delegate.
 */
@implementation MFPkgsInfoOutlineDataSource : MFOutlineDataSource
{
	MFPkgsInfo _selectedPkgsInfo;
}


-(void)awakeFromCib
{
	var uri = [MF_SERVER_URI stringByAppendingString:@"?controller=pkgsinfo"];

	[self setAlsoBecomeDelegate:YES];
	[self setDataSourceURI:uri];
	[self reloadData];
}




- (void)outlineViewSelectionDidChange:(id)aNotification
{
	var anOutlineView = [aNotification object];
	var item = [anOutlineView itemAtRow:[anOutlineView selectedRow]];
	if ([item isLeaf])
	{
		_selectedPkgsInfo = [MFPkgsInfo sharedInstance];
		[_selectedPkgsInfo setRepresentedModel:item];
	}
}

@end
