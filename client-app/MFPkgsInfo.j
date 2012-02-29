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
}
@end
