/**
	Pkg acts as a wrapper to a single package in a catalog. It is given a row of
	data and normalizes the data access keys. For example, 'name' and
	'display_name' are not always both set. Display name is preferred, but it's
	a pain to check the variables each time one or the other is needed. This
	class does takes care of that task.
 */

@implementation MFPackage : CPObject
{
	CPString _fileKey;
	CPDictionary _data;
	CPString _munkiUri;
}


- (id)initWithKey:(CPString)aKey andDictionary:(CPDictionary)aDictionary
{
	self = [super init];
	if (self)
	{
		_fileKey = aKey;
		_data = aDictionary;
		_munkiUri = [[[CPBundle mainBundle] infoDictionary]
				objectForKey:@"Munki Server URI"];
	}
	return self;
}




- (CPString)name
{
	return [_data objectForKey:@"name"];
}




- (CPString)displayName
{
	return [_data objectForKey:@"display_name"];
}




- (CPString)preferredName
{
	if ([self displayName] != nil)
	{
		return [self displayName];
	}
	return [self name];
}




- (CPString)version
{
	return [_data objectForKey:@"version"];
}




- (CPString)catalogsAsString
{
	return [[_data objectForKey:@"catalogs"] componentsJoinedByString:@", "];
}




- (CPString)catalogsArray
{
	return [[_data objectForKey:@"catalogs"]
	sortedArrayUsingSelector:@selector(compare:)];

}




- (int)installerItemSize
{
	return [_data objectForKey:@"installer_item_size"];
}




- (int)installedSize
{
	return [_data objectForKey:@"installed_size"];
}




- (CPString)formatBytes:(float)bytes
{
	var suffix = [CPArray arrayWithObjects:"B","K","M","G","T"];
	var i = 1;
	while(bytes > 1024)
	{
		bytes = bytes/1024.0;
		i++;
	}
	
	return [CPString stringWithFormat:@"%f%s",
		Math.round(bytes * Math.pow(10, 2))/Math.pow(10, 2),
		[suffix objectAtIndex:i]];
}




- (CPString)installerItemSizeFormatted
{
	return [self formatBytes:[self installerItemSize]];
}




- (CPString)installedSizeFormatted
{
	return [self formatBytes:[self installedSize]];
}




- (CPString)minOSVersion
{
	return [_data objectForKey:@"minimum_os_version"];
}




- (CPString)maxOSVersion
{
	return [_data objectForKey:@"maximum_os_version"];
}




- (CPString)notes
{
	return [_data objectForKey:@"description"];
}




- (CPString)uninstallable
{
	return [self objectForKey:@"uninstallable"];
}




- (CPString)packageUrl
{
	return [_munkiUri stringByAppendingString:
		[self objectForKey:@"installer_item_location"]];
}




- (BOOL)autoRemove
{
	return [self objectForKey:@"autoremove"];
}




- (CPArray)requires
{
	return [[self objectForKey:@"requires"]
		sortedArrayUsingSelector:@selector(compare:)];
}




- (CPArray)updateFor
{
	return [[self objectForKey:@"update_for"]
		sortedArrayUsingSelector:@selector(compare:)];
}




- (CPString)uninstallScript
{
	return [self objectForKey:@"uninstall_script"];
}




- (CPString)uninstallMethod
{
	return [self objectForKey:@"uninstall_method"];
}




- (CPArray)installerEnvironment
{
	var ar = [[CPMutableArray alloc] init];
	var vars = [self objectForKey:@"installer_environment"];
	var keys = [vars allKeys];
	for( var i = 0; i < [keys count]; i++)
	{
		var key = [keys objectAtIndex:i];
		var val = [vars objectForKey:key];
		var dict = [CPDictionary dictionaryWithObjects:[key, val]
			forKeys:["varName", "varValue"]];
		[ar addObject:dict];
	}
	return ar;
}




- (CPString)adobeSetupType
{
	return [self objectForKey:@"AdobeSetupType"];
}




/**
	A catch-all method.
 */
- (id)objectForKey:(CPString)aKey
{
	return [_data objectForKey:aKey];
}




- (int)count
{
	return 0;
}




- (id)objectValueForOutlineColumn:(CPTableColumn)aCol
{
	return [self preferredName];
}

@end
