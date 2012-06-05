/**
	Represents the required CPViewController for the CPPopover view of the
	advanced search.
	\ingroup client-views
 */
@implementation MFAdvancedSearchPopoverController : CPViewController
{
	CPPopover popover @accessors;
	CPButton searchButton @accessors;
	CPOutlineViewController searchDelegate @accessors;
	CPPredicateEditor predicateEditor @accessors;
}




#pragma mark - Initialization
/** @name Initialization
@{ */




- (id)init
{
	self = [super init];
	if (self)
	{
		popover = [[CPPopover alloc] init];
		[popover setAnimates:YES];
		[popover setContentViewController:self];
		[popover setBehavior:CPPopoverBehaviorTransient];
	}
	return self;
}




/*@}*/
#pragma mark -
#pragma mark - Handling the View
/** @name Handling the View
@{*/



/**
	If there is no view, this will create one complete with popover window,
	predicate editor and search button.
 */
- (CPView)view
{
	if (self.view == nil)
	{
		var frame = CGRectMake(0.0, 0.0, 500.0, 300.0);
		self.view = [[CPView alloc] initWithFrame:frame];
		searchButton = [CPButton buttonWithTitle:@"Search"];
		[searchButton sizeToFit];
		[searchButton setFrame:CGRectMake(
			frame.origin.x  + frame.size.width - [searchButton frame].size.width,
			frame.origin.y  + frame.size.height - [searchButton frame].size.height,
			[searchButton frame].size.width,
			[searchButton frame].size.height)];
		[searchButton setTarget:self];
		[searchButton setAction:@selector(performPredicateSearch:)];
		var sv = [[CPScrollView alloc] initWithFrame:CGRectMake(
			2.0,
			4.0,
			frame.size.width - 4.0,
			frame.size.height - [searchButton frame].size.height - 10.0)];

		var templateRows = [MFPredicateRowTemplates pkgsinfoSearchRows];
	
		//[sv setAutoresizingMask: CPViewWidthSizable];

		predicateEditor = [[CPPredicateEditor alloc] initWithFrame:[sv bounds]];
		[predicateEditor setFormattingStringsFilename:nil];
		[predicateEditor setRowTemplates:templateRows];
		[predicateEditor setObjectValue:[CPPredicate predicateWithFormat:
			@"%K CONTAINS ''", @"display_name"]];
		[sv setDocumentView:predicateEditor];
	

		[self.view addSubview:sv];
		[self.view addSubview:searchButton];
	}
	return self.view;
}




/**
	Sends the search predicates to the search delegate (MFOutlineViewController).
 */
- (void)performPredicateSearch:(id)aSender
{
	[self closePopover];
	[searchDelegate setFilterPredicate:[predicateEditor objectValue]];
}




/**
	Displays the popover windoow using the given view as an anchor point
 */
- (void)showPopoverForView:(CPView)aView
{
	if ([popover isShown] != YES)
	{
		[popover showRelativeToRect:nil ofView:aView
			preferredEdge:CPMaxYEdge];
	}
}




/**
	Closes the popover window when called.
 */
- (void)closePopover
{
	[popover close];
}




/*@}*/
#pragma mark -
@end
