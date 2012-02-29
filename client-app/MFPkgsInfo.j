/**
	This is a singleton class that represents the data for the manifest that's
	selected in the outline view.
 */

var MFPKGSINFO_INSTANCE = nil;
@implementation MFPkgsInfo : MFOutlineSelectedObject
{
}




- (id)awakeFromCib
{
	MFPKGSINFO_INSTANCE = self;
}




+ (id)sharedInstance
{
	if (MFPKGSINFO_INSTANCE == nil)
	{
		MFPKGSINFO_INSTANCE = [[MFPkgsInfo alloc] init];
	}
	return MFPKGSINFO_INSTANCE;
}




- (void)dataDidReload
{
	[data setObject:[data objectForKey:@"description"] forKey:@"item_description"];
}
@end
