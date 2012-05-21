@implementation MFAdvancedSearchPopoverController : CPViewController
{
	CPPopover popover @accessors;
	CPPredicateEditor predicateEditor @accessors;
}



- (CPView)view
{
	if (self.view == nil)
	{
		self.view = [CPTextField labelWithTitle:@"Predicate Editor (hopefully soon)"];
		[self.view setFont:[CPFont boldSystemFontOfSize:24.0]];
		[self.view sizeToFit];
		
		
		/*
		var frame = CGRectMake(0.0, 0.0, 500.0, 350.0);
		var v = [[CPScrollView alloc] initWithFrame:frame];

		var templateRows = [MFPredicateRowTemplates pkgsinfoSearchRows];
	
		[v setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
		console.log(templateRows);

		predicateEditor = [[CPPredicateEditor alloc] initWithFrame:frame];
		[predicateEditor setRowTemplates:templateRows];
		[predicateEditor setObjectValue:[CPPredicate predicateWithFormat:
			@"%K BEGINSWITH '%@'", @"min_os_version", "10.7"]];
		[v setDocumentView:predicateEditor];
		
		self.view = v;
		*/
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
