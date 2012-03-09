var MFPKGSINFO_INSTANCE = nil;
/**
	This is a singleton class that represents the data for the manifest that's
	selected in the outline view.
	\class MFPkgsInfo
	\extends MFOutlineSelectedObject
 */
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




- (void)dataDidReload:(CPDictionary)someData
{
	[super dataDidReload:someData];
	[data setObject:[data objectForKey:@"description"] forKey:@"item_description"];

	// translate the installer_environment dictionary to an array of dictionaries
	// to make bindings happy
	var installerEnv = [data objectForKey:@"installer_environment"];
	var installerEnvKeys = [installerEnv allKeys];
	var installerEnvArray = [CPMutableArray array];
	for(var i = 0; i < [installerEnvKeys count]; i++)
	{
		var key = [installerEnvKeys objectAtIndex:i];
		var value = [installerEnv objectForKey:key];
		var dict = [CPDictionary dictionaryWithObjects:
			[key,value]
			forKeys:[@"MFInstallerEnvironmentKey", @"MFInstallerEnvironmentValue"]
		];
		[installerEnvArray addObject:dict];
	}
	[data setObject:installerEnvArray forKey:@"MFInstallerEnvironmentArray"];


	// translate the restart action for bindings.
	var restartAction = [data objectForKey:@"RestartAction"];
	var restartActionTag = 1;
	if ([restartAction isEqualToString:@"RequireLogout"])
	{
		restartActionTag = 2;
	}
	else if ([restartAction isEqualToString:@"RequireRestart"])
	{
		restartActionTag = 3;
	}
	else if ([restartAction isEqualToString:@"SuggestRestart"])
	{
		restartActionTag = 4;
	}
	else if ([restartAction isEqualToString:@"RequireShutdown"])
	{
		restartActionTag = 5;
	}
	[data setObject:restartActionTag forKey:@"MFRestartActionTag"];




	// translate the uninstall_method for bindings
	var uninstallMethod = [data objectForKey:@"uninstall_method"];
	var uninstallMethodTag = 1; //removepackages by default
	var uninstallScript = @"";
	if([uninstallMethod hasPrefix:@"/"])
	{
		uninstallMethodTag = 2;
		uninstallScript = uninstallMethod;
	}
	else if ([uninstallMethod isEqualToString:@"uninstall_script"])
	{
		uninstallMethodTag = 3;
		uninstallScript = [data objectForKey:@"uninstall_script"];
	}
	[data setObject:uninstallMethodTag forKey:@"MFUninstallMethodTag"];
	[data setObject:uninstallScript forKey:@"MFUninstallScript"];




	// prefix the installer location path with the munki repo uri
	var itemUri = [data objectForKey:@"installer_item_location"];
	var munkiRepo = [[MFServerSettings sharedSettings]
		objectForKey:@"SoftwareRepoURL"];
	itemUri = [munkiRepo stringByAppendingString:@"pkgs/" + itemUri];
	[data setObject:itemUri forKey:@"installer_item_location"];
}
@end
