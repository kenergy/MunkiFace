/**
	This controller represents the root of all logic that starts with its view,
	which is the advanced search icon. You initialize it by giving it a
	CPSearchField object and you end up with the icon being placed in the search
	field's superview. When you click the icon, logic control is then passed on to
	the MFAdvancedSearchPopoverController.

	This controller also manages the provided search field's menu and populates it
	with saved advances searches. The popover window will give the user the
	ability to create, edit, or remove these saved searches.
	\ingroup client-views
 */
@implementation MFMainViewSearchController : CPViewController
{
	CPSearchField searchField @accessors;
	MFOutlineViewController searchDelegate @accessors;
	MFAdvancedSearchPopoverController popoverController @accessors;
}




#pragma mark - View Handlers
/** @name View Handlers
@{*/




/**
	Creates the advanced search icon that is placed in the same superview as the
	attached CPSearchField. This also instructs that button to send its click
	actions back to this instance's advancedSearchButtonClicked: method.
	\returns CPButton
 */
- (CPButton)view
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




/*@}*/
#pragma mark -
#pragma mark - Initialization
/** @name Initialization
@{*/




/**
	Initializes a new instance of the receiver after creating a menu for the
	provided CPSearchField.
 */
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




/**
	Assigns the search delegate for the search field as well as the predicate
	editor.
 */
- (void)setSearchDelegate:(id)aDelegate
{
	searchDelegate = aDelegate;
	[searchField setTarget:searchDelegate];
	[searchField setAction:@selector(setFilterString:)];
	[popoverController setSearchDelegate:searchDelegate];
}




/*@}*/
#pragma mark -
#pragma mark - Control Delegates
/**@name Control Delegates
@{*/




/**
	A placeholder target that is called when an item from the search field's menu
	is clicked.
 */
- (void)recentSearchSelected:(id)aSender
{
	CPLog.debug("User selected a recent search: %@", aSender);
}




/**
	Called when the advanced search button is clicked. This instructs the
	MFAdvancedSearchPopoverController to display the popover window and take
	control.
 */
- (void)advancedSearchButtonClicked:(id)aSender
{
	[popoverController showPopoverForView:[self view]];
}




/*@}*/
#pragma mark -
@end
