/**
	Provides the main CPOutlineView with a datasource and delegate.
 */
@implementation MFPkgsInfoOutlineDataSource : MFOutlineDataSource


-(void)awakeFromCib
{
	var uri = [[[CPBundle mainBundle] infoDictionary]
				objectForKey:@"MunkiFace Server URI"];
	uri = [uri stringByAppendingString:@"?controller=pkgsinfo"];

	[self setDataSourceURI:uri];
	[self reloadData];
}
@end
