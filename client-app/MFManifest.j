/**
	This is a singleton class that represents the data for the manifest that's
	selected in the outline view.
 */

var MFMANIFEST_INSTANCE = nil;
@implementation MFManifest : MFOutlineSelectedObject
{
}




- (id)awakeFromCib
{
	MFMANIFEST_INSTANCE = self;
}




+ (id)sharedInstance
{
	if (MFMANIFEST_INSTANCE == nil)
	{
		MFMANIFEST_INSTANCE = [[MFManifest alloc] init];
	}
	return MFMANIFEST_INSTANCE;
}




- (void)dataDidReload:(CPDictionary)someData
{
	[super dataDidReload:someData];
	var installsCount = [[data objectForKey:@"managed_installs"] count];
	var updatesCount = [[data objectForKey:@"managed_updates"] count];
	var uninstallsCount = [[data objectForKey:@"managed_uninstalls"] count];
	var optionalInstallsCount = [[data objectForKey:@"optional_installs"] count];
	var manifestsCount = [[data objectForKey:@"included_manifests"] count];
	var catalogsCount = [[data objectForKey:@"catalogs"] count];
	
	[data setObject:installsCount forKey:@"MFManagedInstallsCount"];
	[data setObject:updatesCount forKey:@"MFManagedUpdatesCount"];
	[data setObject:uninstallsCount forKey:@"MFManagedUninstallsCount"];
	[data setObject:optionalInstallsCount forKey:@"MFOptionalInstallsCount"];
	[data setObject:manifestsCount forKey:@"MFIncludedManifestsCount"];
	[data setObject:catalogsCount forKey:@"MFIncludedCatalogsCount"];
}
@end
