/**
	This view controller doe nothing but let the user know that they need to
	select something before they will see any editor controls.
	\ingroup client-views
 */
@import "../Views/ManifestView/ManifestView.j"

@implementation MFManifestViewController : CPViewController
{
}




- (id)init
{
	self = [super init];
	if (self)
	{
		[self setView:[[MFManifestView alloc] initWithFrame:CGRectMakeZero()]];
	}
	return self;
}
@end
