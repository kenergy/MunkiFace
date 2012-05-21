@implementation MFMainViewSearchController : CPViewController
{
	CPSearchField searchField @accessors;
	MFAdvancedSearchPopoverController popoverController @accessors;
}




- (CPView)view
{
	if (self.view == nil)
	{
		var b = [[CPButton alloc] initWithFrame:CGRectMake(
			215.0, 0.0, 30.0, 30.0)];
		[b setBordered:NO];
		var image = [[CPImage alloc] initWithContentsOfFile:@"Resources/Gear.png"];
		var altImage = [[CPImage alloc]
			initWithContentsOfFile:@"Resources/GearPressed.png"];
		[b setImage:image];
		[b setAlternateImage:altImage];
		[b setAutoresizingMask: CPViewMinXMargin];
		[b setTarget:self];
		[b setAction:@selector(advancedSearchButtonClicked:)];
		self.view = b;
	}
	return self.view;
}


- (void)initWithSearchField:(CPSearchField)aSearchField
{
	self = [super init];
	if (self)
	{
		[self setSearchField:aSearchField];
		var cellMenu = [[CPMenu alloc] initWithTitle:@"Search Menu"];
		var item1;

		item1 = [[CPMenuItem alloc] initWithTitle:@"Hello World!"
			action:@selector(recentSearchSelected:) keyEquivalent:@""];
		[item1 setTarget:self];
		[cellMenu insertItem:item1 atIndex:0];
		[searchField setSearchMenuTemplate:cellMenu];

		var parentView = [searchField superview];
		[parentView addSubview:[self view]];
		popoverController = [[MFAdvancedSearchPopoverController alloc] init];
	}
	return self;
}




- (void)recentSearchSelected:(id)aSender
{
	console.log("User selected a recent search:", aSender);
}




- (void)advancedSearchButtonClicked:(id)aSender
{
	console.log("I know what you clicked last summer");
	[popoverController showPopoverForView:[self view]];
}
@end
