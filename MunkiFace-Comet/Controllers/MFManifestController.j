/**
	Manifests can be displayed in two ways; the filesystem layout and the logical
	layout. The filesystem layout represents the files in a hierarchy that exactly
	represents the way the files live on the filesystem. The logical layout
	presents the data in an inheritance view where containers are manifests that
	have other manifests inheriting from them, and the leafs are manifests which
	inherit from another manifest (or not), but have nothing inheriting from them.

	This controller will organize the manifest data either of these two views, but
	does not currently take into consideration the conditional_items keys that can
	live in a manifest.
	\ingroup client-app
 */
@implementation MFManifestController : CPObject
{
	MFTreeModel manifests;
	MFTreeModel arrangedObjects @accessors;
}




/**
	Initializes a new instance of MFManifestController and binds the internal
	ivar 'manifests' to the MFTreeModel named 'manifests'.
 */
- (id)init
{
	self = [super init];
	if (self)
	{
		
	}
	return self;
}
@end
