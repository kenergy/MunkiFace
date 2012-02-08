@import "MFPackage.j"
/**
	Represents a single munki catalog.
 */
@implementation MFCatalog : CPObject
{
	CPMutableArray _data;
	CPString _catalogName;
}




- (id)initWithName:(CPString)aName andData:(CPArray)theData
{
	self = [super init];
	if (self)
	{
		_catalogName = aName;
		_data = [CPMutableArray array];
		for(var i = 0; i < [theData count]; i++)
		{
			var data = [theData objectAtIndex:i];
			[_data addObject:[[MFPackage alloc] initWithDictionary:data]];
		}
	}
	return self;
}




- (int)count
{
	return [_data count];
}




- (id)objectAtIndex:(int)anIndex
{
	return [_data objectAtIndex:anIndex];
}




- (id)objectValueForOutlineColumn:(CPTableColumn)aColumn
{
	return _catalogName;
}
@end
