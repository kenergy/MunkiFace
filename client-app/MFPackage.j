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
}


- (id)initWithKey:(CPString)aKey andDictionary:(CPDictionary)aDictionary
{
	self = [super init];
	if (self)
	{
		_fileKey = aKey;
		_data = aDictionary;
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




- (int)installerItemSize
{
	return [_data objectForKey:@"installer_item_size"];
}




- (CPString)installerItemSizeFormatted
{
	var bytes = [self bytes];
	var suffix = [CPArray arrayWithObjects:"B","K","M","G","T"];
	var i = 1;
	while(bytes > 1024)
	{
		bytes = bytes/1024;
		i++;
	}
	return [CPString stringWithFormat:@"%d%s",
		bytes,
		[suffix objectAtIndex:i]];
}




- (CPString)minOSVersion
{
	return [_data objectForKey:@"minimum_os_version"];
}




- (CPString)maxOSVersion
{
	return [_data objectForKey:@"maximum_os_version"];
}




- (CPString)description
{
	return [_data objectForKey:@"description"];
}




- (CPString)uninstallable
{
	return [self objectForKey:@"uninstallable"];
}




- (CPString)packageUrl
{
	return [self objectForKey:@"installer_item_location"];
}




- (CPString)autoRemove
{
	return [self objectForKey:@"autoremove"];
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
