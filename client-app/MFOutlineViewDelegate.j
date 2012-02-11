/**
	Responds to actions that come from the main CPOutlineView object on the
	screen.
 */
@implementation MFOutlineViewDelegate : CPObject
{
	@outlet CPOutlineView _outlineView;
	@accessors MFPackage item;
}



- (void)outlineViewSelectionDidChange:(CPNotification)aNotification
{
	var selectedRow = [[aNotification object] selectedRow];
	[self setItem: [_outlineView itemAtRow:selectedRow]];
}
@end
