/**
	This is a singleton class that represents the data for the manifest that's
	selected in the outline view.
 */

var MFMANIFEST_INSTANCE = nil;
@implementation MFManifest : MFOutlineSelectedObject
{
}




+ (id)sharedInstance
{
	if (MFMANIFEST_INSTANCE = nil)
	{
		MFMANIFEST_INSTANCE = [[MFManifest alloc] init];
	}
	return MFMANIFEST_INSTANCE;
}
@end
