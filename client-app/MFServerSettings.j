var MF_SERVER_SETTINGS_INSTANCE = nil;
/**
	MFServerSettings is exactly what is sounds like; it fetches the server-side
	settings and makes them available through its singleton instance.
	\class MFServerSettings
	\extends MFNetworkDataSource
 */
@implementation MFServerSettings : MFNetworkDataSource
{
	CPDictionary _settings;
}




/**
	Creates a new instance if one doesn't already exist, then fetches the settings
	from the server.
 */
+ (MFServerSettings) sharedSettings
{
	if (MF_SERVER_SETTINGS_INSTANCE == nil)
	{
		var instance = [[MFServerSettings alloc] init];
		[instance setDataSourceURI:
			[MF_SERVER_URI stringByAppendingString:@"?controller=settings"]];
		[instance reloadData];
		MF_SERVER_SETTINGS_INSTANCE = instance;
	}
	return MF_SERVER_SETTINGS_INSTANCE;
}




/**
	Caches the server response which is expected to be a CPDictionary of items.
 */
- (void)dataDidReload:(CPDictionary)someData
{
	[super dataDidReload:someData];
	if ([[someData allKeys] containsObject:@"SoftwareRepoURL"])
	{
		var url = [someData objectForKey:@"SoftwareRepoURL"];
		if ([url hasSuffix:@"/"] == NO)
		{
			url = [url stringByAppendingString:@"/"];
			[someData setObject:url forKey:@"SoftwareRepoURL"];
		}
	}
	_settings = someData;
}




/**
	Retuns a CPArray of all of the keys found in the settings dictionary.
 */
- (CPArray)allKeys
{
	return [_settings allKeys];
}




/**
	Returns the object represented in the settings dictionary by aKey, or an empty
	string if the key doesn't exist.
 */
- (id)objectForKey:(id)aKey
{
	if ([[self allKeys] containsObject:aKey])
	{
		return [_settings objectForKey:aKey];
	}
	return @"";
}
@end
