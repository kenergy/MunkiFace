/**
	Provides access to the Catalogs array.
 */
var MF_CATALOGS_CONTROLLER_INSTANCE = nil;
@implementation MFCatalogsController : CPObject
{
	@accessors CPArray catalogs;
}




- (id)init
{
	if (MF_CATALOGS_CONTROLLER_INSTANCE == nil)
	{
		[self createInstance];
	}
	return MF_CATALOGS_CONTROLLER_INSTANCE;
}




- (void)awakeFromCib
{
	[self createInstance];
}




- (id)createInstance
{
	if (MF_CATALOGS_CONTROLLER_INSTANCE == nil)
	{
		self = [super init];
		catalogs = [CPArray array];
		[self reloadCatalogs];
		MF_CATALOGS_CONTROLLER_INSTANCE = self;
	}
	return MF_CATALOGS_CONTROLLER_INSTANCE;
}




+ (id)sharedController
{
	return MF_CATALOGS_CONTROLLER_INSTANCE;
}




- (void)reloadCatalogs
{
	var packages = [[MFPackages sharedPackages] allPackages];
	var tmpCat = [CPMutableArray array];
	var keys = [packages allKeys];

	[tmpCat addObject:"All"];

	for(var i = 0; i < [keys count]; i++)
	{
		var key = [keys objectAtIndex:i];
		var catalogs = [[packages objectForKey:key] catalogsArray];
		for(var j = 0; j < [catalogs count]; j++)
		{
			var obj = [catalogs objectAtIndex:j];
			if ([tmpCat containsObject:obj] == NO)
			{
				[tmpCat addObject:obj];
			}
		}
	}
	[self setCatalogs:[tmpCat sortedArrayUsingSelector:@selector(compare:)]];
}


@end
