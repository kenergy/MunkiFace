/**
	Responds to actions that come from the main CPOutlineView object on the
	screen.
 */
@implementation MFOutlineViewDelegate : CPObject
{
	@outlet CPOutlineView _outlineView;
	@outlet CPTextField _packageName;
	@outlet CPTextField _packageVersion;
	@outlet CPTextField _minOSVersion;
	@outlet CPTextField _installerSize;
	@outlet CPButton _isUninstallable;
	@outlet CPButton _willAutoRemove;
	@outlet CPTextField _packageDescription;
}




- (id)awakeFromCib
{
	[self setFieldsToNil];
}




- (void)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	var selectedRow = [[aNotification object] selectedRow];
	if (selectedRow == -1)
	{
		[self setFieldsToNil];
	}
	else
	{
		var item = [_outlineView itemAtRow:selectedRow];
		if (![item respondsToSelector:@selector(name)])
		{
			[self setFieldsToNil];
		}
		else
		{
			[_packageName setObjectValue:[item name]];
			[_packageVersion setObjectValue:[item version]];
			[_minOSVersion setObjectValue:[item minOSVersion]];
			[_installerSize setObjectValue:[item bytesFormatted]];
			[_isUninstallable setState:([item uninstallable] ? CPOnState :
				CPOffState)];
			[_willAutoRemove setState:([item autoRemove] ? CPOnState :
				CPOffState)];
			[_packageDescription setObjectValue:[item description]];
		}
	}
}




- (void)setFieldsToNil
{
	[_packageName setObjectValue:nil];
	[_packageVersion setObjectValue:nil];
	[_minOSVersion setObjectValue:nil];
	[_installerSize setObjectValue:nil];
	[_isUninstallable setState:CPMixedState];
	[_willAutoRemove setState:CPMixedState];
	[_packageDescription setObjectValue:nil];
}
@end
