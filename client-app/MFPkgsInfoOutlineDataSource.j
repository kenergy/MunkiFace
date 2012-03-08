/**
	Provides the main CPOutlineView with a datasource and delegate.
	\class MFPkgsInfoOutlineDataSource
	\extends MFOutlineDataSource
 */
@implementation MFPkgsInfoOutlineDataSource : MFOutlineDataSource
{
	MFPkgsInfo _selectedPkgsInfo;
}


/**
	When the class is loaded from the cib, it sets the URI for the
	MFOutlineDataSource, asks to become the delegate for what ever CPOutlineView
	represents the data and then requests the data from the server.
 */
-(void)awakeFromCib
{
	var uri = [MF_SERVER_URI stringByAppendingString:@"?controller=pkgsinfo"];

	[self setAlsoBecomeDelegate:YES];
	[self setDataSourceURI:uri];
	[self reloadData];
}




/**
	When the representing outline view selection changes, it calls this method (as
	long as alsoBecomeDelegate is set to YES). This method then grabs an instance
	of MFPkgsInfo and sets the representedModel to the selected MFTreeModel
	object.
	\see MFOutlineSelectedObject::setRepresentedModel
 */
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
