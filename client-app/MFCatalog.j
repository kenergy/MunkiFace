var MFCATALOG_INSTANCE = nil;

/**
	This is a singleton class that represents the data for the manifest that's
	selected in the outline view.
	\class MFCatalog
	\extends MFOutlineSelectedObject
 */
@implementation MFCatalog : MFNetworkDataSource
{
}




- (id)awakeFromCib
{
	[self setDataSourceURI:
		[MF_SERVER_URI stringByAppendingString:@"?controller=readFile&file=catalogs/all"]];
	[self reloadData];
	MFCATALOG_INSTANCE = self;
}




+ (id)sharedInstance
{
	if (MFCATALOG_INSTANCE == nil)
	{
		MFCATALOG_INSTANCE = [[MFCatalog alloc] init];
	}
	return MFCATALOG_INSTANCE;
}




- (void)dataDidReload:(CPDictionary)someData
{
	console.log(someData);
}
@end
