@implementation MFAdvancedSearchPopoverController : CPViewController
{
	CPPopover popover @accessors;
	CPPredicateEditor predicateEditor @accessors;
}



- (CPView)view
{
	if (self.view == nil)
	{
		var frame = CGRectMake(0.0, 0.0, 500.0, 350.0);
		self.view = [[CPView alloc] initWithFrame:frame];
		var sv = [[CPScrollView alloc] initWithFrame:CGRectInset(frame, 2.0, 5.0)];

		var templateRows = [MFPredicateRowTemplates pkgsinfoSearchRows];
	
		[sv setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];

		predicateEditor = [[CPPredicateEditor alloc] initWithFrame:[sv bounds]];
		[predicateEditor setFormattingStringsFilename:nil];
		[predicateEditor setRowTemplates:templateRows];
		[predicateEditor setObjectValue:[CPPredicate predicateWithFormat:
			@"%K CONTAINS ''", @"display_name"]];
		[sv setDocumentView:predicateEditor];
		

		[self.view addSubview:sv];
	}
	return self.view;
}




- (id)init
{
	self = [super init];
	if (self)
	{
		popover = [[CPPopover alloc] init];
		[popover setAnimates:YES];
		[popover setContentViewController:self];
		[popover setBehaviour:CPPopoverBehaviorTransient];
	}
	return self;
}




- (void)showPopoverForView:(CPView)aView
{
	if ([popover shown] == NO)
	{
		[popover showRelativeToRect:nil ofView:aView
			preferredEdge:CPMaxYEdge];
	}
}




- (void)closePopover
{
	[popover close];
}
@end
