@import "MFCatalogs.j";
/**
	Serves as the delegate for the main table in the application.
 */
@implementation MainTableDelegate : CPObject
{
	@outlet CPTextField _metaLabel;
	@outlet CPTextField _metaDescription;
}




- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
	var table = [aNotification object];
	var idx = [[table selectedRowIndexes] firstIndex];
	var catalogs = [[Catalogs sharedCatalogs] catalogs];

	if (idx == -1)
	{
		[_metaLabel setObjectValue:nil];
		[_metaDescription setObjectValue:nil];
	}
	else
	{
		var pkg = [[Pkg alloc] initWithDictionary:[catalogs objectAtIndex:idx]];

		[_metaLabel setObjectValue:[pkg name]];
		[_metaDescription setObjectValue:[pkg description]];
	}
}


@end
