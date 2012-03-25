var MFCATALOG_INSTANCE = nil;

/**
	This is a singleton class that represents the data for the manifest that's
	selected in the outline view.
	\class MFCatalog
	\extends MFOutlineSelectedObject
 */
@implementation MFCatalog : MFNetworkDataSource
{
	@accessors CPArray packages;
	@outlet CPImageView iconView;
}




- (id)awakeFromCib
{
	[super awakeFromCib];
	[self setPackages:[CPArray array]];
	[self setDataSourceURI:
		[MF_SERVER_URI stringByAppendingString:@"?target=catalogs/all&read"]];
	[self reloadRawData];
	MFCATALOG_INSTANCE = self;

	[iconView setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/__icon__pkgs.png"]];
}




+ (id)sharedInstance
{
	if (MFCATALOG_INSTANCE == nil)
	{
		MFCATALOG_INSTANCE = [[MFCatalog alloc] init];
	}
	return MFCATALOG_INSTANCE;
}




- (void)dataDidReload:(CPArray)someData
{
	var arr = [CPMutableArray array];
	for(var i = 0; i < [someData count]; i++)
	{
		[arr addObject:[CPDictionary dictionaryWithJSObject:[someData
		objectAtIndex:i] recursively:YES]];
	}
	[self setPackages:arr];
}
@end
