/**
	Pkg acts as a wrapper to a single package in a catalog. It is given a row of
	data and normalizes the data access keys. For example, 'name' and
	'display_name' are not always both set. Display name is preferred, but it's
	a pain to check the variables each time one or the other is needed. This
	class does takes care of that task.
 */

@implementation MFPackage : CPObject
{
	CPDictionary _row;
}


- (id)initWithDictionary:(CPDictionary)aDictionary
{
	self = [super init];
	if (self)
	{
		_row = aDictionary;
	}
	return self;
}




- (CPString)name
{
	var name = [_row objectForKey:@"display_name"];
	if (name == nil)
	{
		name = [_row objectForKey:@"name"] + " "
			+ [self version];
	}
	return name;
}




- (CPString)version
{
	return [_row objectForKey:@"version"];
}




- (CPString)catalogsAsString
{
	return [[_row objectForKey:@"catalogs"] componentsJoinedByString:@", "];
}




- (int)bytes
{
	return [_row objectForKey:@"installer_item_size"];
}




- (CPString)bytesFormatted
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
	var item = [_row objectForKey:@"installs"];
	return [[item firstObject] objectForKey:@"minosversion"];
}




- (CPString)description
{
	return [_row objectForKey:@"description"];
}




- (CPString)uninstallable
{
	return [self objectForKey:@"uninstallable"];
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
	return [_row objectForKey:aKey];
}




- (int)count
{
	return 0;
}




- (id)objectValueForOutlineColumn:(CPTableColumn)aCol
{
	return [self name];
}

@end
