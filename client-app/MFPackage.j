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
		if ([_munkiUri hasSuffix:@"/"] == NO)
		{
			_munkiUri = [_munkiUri stringByAppendingString:@"/pkgs/"];
		}
		else
		{
			_munkiUri = [_munkiUri stringByAppendingString:@"pkgs/"];
		}
	}
	return self;
}




- (CPString)name
{
	return [self objectForKey:@"name"];
}




- (CPArray)blockingApplications
{
	return [self objectForKey:@"blocking_applications"];
}




- (CPString)displayName
{
	return [self objectForKey:@"display_name"];
}




- (CPString)preferredName
{
	if ([self displayName] != nil)
	{
		return [self displayName];
	}
	return [self name];
}




- (CPString)versionString
{
	return [self objectForKey:@"version"];
}




- (CPString)catalogsAsString
{
	return [[self objectForKey:@"catalogs"] componentsJoinedByString:@", "];
}




- (CPString)catalogsArray
{
	return [[self objectForKey:@"catalogs"]
	sortedArrayUsingSelector:@selector(compare:)];

}




- (int)installerItemSize
{
	return [self objectForKey:@"installer_item_size"];
}




- (int)installedSize
{
	return [self objectForKey:@"installed_size"];
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
	return [self objectForKey:@"minimum_os_version"];
}




- (CPString)maxOSVersion
{
	return [self objectForKey:@"maximum_os_version"];
}




- (CPString)notes
{
	return [self objectForKey:@"description"];
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




- (CPString)preinstallScript
{
	return [self objectForKey:@"preinstall_script"];
}




- (CPString)postinstallScript
{
	return [self objectForKey:@"postinstall_script"];
}




- (CPString)preuninstallScript
{
	return [self objectForKey:@"preuninstall_script"];
}




- (CPString)postuninstallScript
{
	return [self objectForKey:@"postuninstall_script"];
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




- (CPArray)installs
{
	return [self objectForKey:@"installs"];
}




- (CPArray)receipts
{
	var ar = [self objectForKey:@"receipts"];
	[ar enumerateObjectsUsingBlock:function(obj, idx, stop)
	{
		if ([[obj allKeys] containsObject:@"__formatted"] == NO)
		{
			[obj setObject:[self formatBytes:[obj objectForKey:@"installed_size"]]
				forKey:@"installed_size"];
			[obj setObject:YES forKey:@"__formatted"];
		}
	}];
	return ar;
}




- (CPString)forceInstallAfterDate
{
	return [self objectForKey:@"force_install_after_date"];
}




- (BOOL)unattendedInstall
{
	if ([[_data allKeys] containsObject:@"forced_install"])
	{
		return [_data objectForKey:@"forced_install"];
	}
	return [self objectForKey:@"unattended_install"];
}




- (BOOL)unattendedUninstall
{
	if ([[_data allKeys] containsObject:@"forced_uninstall"])
	{
		return [_data objectForKey:@"forced_uninstall"];
	}
	return [self objectForKey:@"unattended_uninstall"];
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
	return [CPString stringWithFormat:@"%@-%@",
		[self preferredName],
		[self versionString]];
}

@end
