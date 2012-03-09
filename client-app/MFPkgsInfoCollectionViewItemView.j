@implementation MFPkgsInfoCollectionViewItemView : CPView
{
}




- (void)setSelected:(BOOL)isSelected
{
	if (isSelected)
	{
		[self setBackgroundColor:[CPColor alternateSelectedControlColor]];
		[[self viewWithTag:1] setTextColor:[CPColor whiteColor]];
		[[self viewWithTag:2] setTextColor:[CPColor whiteColor]];
	}
	else
	{
		[self setBackgroundColor:[CPColor clearColor]];
		[[self viewWithTag:1] setTextColor:[CPColor blackColor]];
		[[self viewWithTag:2] setTextColor:[CPColor blackColor]];
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
