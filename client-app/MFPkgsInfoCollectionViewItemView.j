@implementation MFPkgsInfoCollectionViewItemView : CPView
{
}




- (void)setSelected:(BOOL)isSelected
{
	if (isSelected)
	{
		console.log("Is selected");
	}
	else
	{
		console.log("Is not selected");
	}
}




- (void)setRepresentedObject:(id)anObject
{
	var appNameLabel = [self viewWithTag:1];
	var versionLabel = [self viewWithTag:2];
	[appNameLabel setStringValue:[anObject objectForKey:@"name"]];
	[versionLabel setStringValue:[anObject objectForKey:@"version"]];
}
@end
