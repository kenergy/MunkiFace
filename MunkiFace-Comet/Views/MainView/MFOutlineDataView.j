/**
	Provides the text label and count badge for the items in the main outline
	view. This view is passed to the setDataView: method of the main outline
	view's table column. The outline view's datasource is then responsible for
	returning an object that is capable of responding to `title` and
	`numberOfChildren`. If the value of `numberOfChildren` is 0, the badge width
	will be set to 0, effectively hiding the badge. If the value of
	`numberOfChildren` changes from 0 to anything greater than 0, the badge will
	automatically be re-expanded to display the new value.
 */
@implementation MFOutlineDataView : CPView
{
	CPString title @accessors;
	CPInteger badgeValue @accessors;
	CPTextField titleView;
	CPTextField badgeView;
	CPColor badgeBackgroundDefault;
	CPColor badgeBackgroundSelected;
}




/**
	Called when the CPTableColumn needs to use a new copy of the data view.
 */
- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super initWithCoder:aCoder];
	if (self)
	{
		// Initialize the values before we try to set them so the framework doesn't
		// complain about trying to send a nil value to a CPControl's
		// -setStringValue method.
		title = @"";
		badgeValue = 0;
		[self adjustLayout];
		[self setTitle:[aCoder decodeObjectForKey:@"titleValue"]];
		[self setBadgeValue:[aCoder decodeObjectForKey:@"badgeValue"]];
		badgeBackgroundDefault = [aCoder decodeObjectForKey:@"badgeBackgroundDefault"];
		badgeBackgroundSelected = [aCoder decodeObjectForKey:@"badgeBackgroundSelected"];
	}
	return self;
}




/**
	Called when the CPTableColumn wants to archive the dataview for future use.
 */
- (void)encodeWithCoder:(CPCoder)aCoder
{
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:title forKey:@"titleValue"];
	[aCoder encodeObject:badgeValue forKey:@"badgeValue"];
	[aCoder encodeObject:badgeBackgroundDefault forKey:@"badgeBackgroundDefault"];
	[aCoder encodeObject:badgeBackgroundSelected forKey:@"badgeBackgroundSelected"];
}



/**
	Creates the two CPThreePartImage objects that are needed to display the badge,
	then makes a call to adjustLayout to make sure the title and badge subviews
	are present and initialized.
 */
- (id)init
{
	if (self = [super init])
	{
		badgeBackgroundDefault = [CPColor colorWithPatternImage:
		[[CPThreePartImage alloc] initWithImageSlices:[
			[[CPImage alloc]
				initWithContentsOfFile:@"Resources/badge-default-left.png"
				size:CGSizeMake(9.0, 16.0)],
			[[CPImage alloc]
				initWithContentsOfFile:@"Resources/badge-default-middle.png"
				size:CGSizeMake(1.0, 16.0)],
			[[CPImage alloc]
				initWithContentsOfFile:@"Resources/badge-default-right.png"
				size:CGSizeMake(9.0, 16.0)]
		] isVertical:NO]];
		badgeBackgroundSelected = [CPColor colorWithPatternImage:
		[[CPThreePartImage alloc] initWithImageSlices:[
			[[CPImage alloc]
				initWithContentsOfFile:@"Resources/badge-selected-left.png"
				size:CGSizeMake(9.0, 16.0)],
			[[CPImage alloc]
				initWithContentsOfFile:@"Resources/badge-selected-middle.png"
				size:CGSizeMake(1.0, 16.0)],
			[[CPImage alloc]
				initWithContentsOfFile:@"Resources/badge-selected-right.png"
				size:CGSizeMake(9.0, 16.0)]
		] isVertical:NO]];
		
		// Initialize the values before we try to set them so the framework doesn't
		// complain about trying to send a nil value to a CPControl's
		// -setStringValue method.
		title = @"";
		badgeValue = 0;
		[self adjustLayout];
	}
	return self;
}




/**
	Called whenever the CPTableColumn's width changes or any other time that the
	data view's frame should change. This calculates the appropriate size,
	including padding, for the title and badge views. It also makes sure that the
	badge view always has 4 pixels of padding on either side to avoid crowding of
	the badge value.
 */
- (void)setFrame:(CGRect)aFrame
{
	[super setFrame:aFrame];

	[titleView setFrame:CGRectMake(
		0,
		aFrame.size.height/2 - [titleView frame].size.height/2,
		CGRectGetWidth(aFrame) - [badgeView frame].size.width - 6,
		[titleView frame].size.height
	)];

	var badgeWidth = [badgeView frame].size.width;
	if (badgeValue != 0)
	{
		[badgeView sizeToFit];
		badgeWidth = [badgeView frame].size.width;
		if (badgeWidth < 20)
		{
			badgeWidth = 20;
		}
		badgeWidth += 8;
	}
	[badgeView setFrame:CGRectMake(
		aFrame.size.width - badgeWidth - 4,
		aFrame.size.height/2 - [badgeView frame].size.height/2,
		badgeWidth,
		[badgeView frame].size.height
	)];
}




/**
	Makes sure that the title view and badge view are present as subviews of the
	receiver, and creates them if needed. This is also where the badge view is set
	to center-align its contents and stick to the right side of the view. The
	title view is likewise set to stick to the left side of the data view and
	adjust its width as the data view's width is adjusted.
 */
- (void)adjustLayout
{
	// Make sure the views exist and create them if not.
	if (titleView == nil)
	{
		titleView = [CPTextField labelWithTitle:title];
		[titleView setAutoresizingMask:CPViewWidthSizable
			| CPViewMaxYMargin | CPViewMaxXMargin];
		[self addSubview:titleView];
	}
	if (badgeView == nil)
	{
		badgeView = [CPTextField labelWithTitle:@""];
		[badgeView setFont:[CPFont boldSystemFontOfSize:11]];
		[badgeView setValue:CPCenterTextAlignment forThemeAttribute:@"alignment"];
		[badgeView setAutoresizingMask:CPViewMinXMargin];
		[self addSubview:badgeView];
	}

	// Adjust the layout options of the view components
	[self setAutoresizingMask:CPViewWidthSizable];
}




/**
	Accepts an object from the outline view, which it obtains from its data
	source. The object must respond to the `title` and `numberOfChilren` messages.
 */
- (void)setObjectValue:(id)anObject
{
	if ([anObject respondsToSelector:@selector(title)] && [anObject
	respondsToSelector:@selector(numberOfChildren)])
	{
		[self setTitle:[anObject title]];
		[self setBadgeValue:[anObject numberOfChildren]];
	}
	else
	{
		CPLog.error(
			"MFOutlineDataView - data source returned an object that doesn't"
			+ " respond to both `title` and `numberOfChildren`");
	}
}




/**
	Called automatically when the row in the outline view is selected. It makes
	sure that the title text color is white and that the badge view's text and
	background are updated to blue and white respectively.
 */
- (void)setThemeState:(id)aState
{
	var theme = [CPTheme defaultTheme];
	if (aState == CPThemeStateSelectedDataView)
	{
		[titleView setFont:[CPFont boldSystemFontOfSize:[[titleView font] size]]];
		[titleView setTextColor:[CPColor whiteColor]];
		[badgeView setBackgroundColor:badgeBackgroundSelected];
		[badgeView setFont:[CPFont boldSystemFontOfSize:[[badgeView font] size]]];
		[badgeView setTextColor:[CPColor colorWithHexString:@"3183D0"]];
	}
}




/**
	Rerturns the colors of the title view and badge view to their normal,
	unselected, states.
 */
- (void)unsetThemeState:(id)aState
{
	if (aState == CPThemeStateSelectedDataView)
	{
		[titleView setFont:[CPFont systemFontOfSize:[[titleView font] size]]];
		[titleView setTextColor:[CPColor blackColor]];
		[badgeView setBackgroundColor:badgeBackgroundDefault];
		[badgeView setFont:[CPFont systemFontOfSize:[[badgeView font] size]]];
		[badgeView setTextColor:[CPColor whiteColor]];
	}
}




/**
	Sets the title value for the data view and recalculates the frame geometry.
 */
- (void)setTitle:(CPString)aString
{
	title = aString;
	[titleView setObjectValue:aString];
	[self setFrame:[self frame]];
}




/**
	Sets the badge value (count) and recalculates the frame geometry. If the badge
	value is 0, the badge view's width will be set to 0, effectively hiding the
	badge.
 */
- (void)setBadgeValue:(CPInteger)aValue
{
	badgeValue = aValue;
	[badgeView setObjectValue:[CPString stringWithFormat:@"%d", badgeValue]];
	if (badgeValue == 0 || badgeValue == nil)
	{
		[badgeView setFrameSize:CGSizeMake(0.0, 0.0)];
	}
	else
	{
		[badgeView sizeToFit];
	}
	[self setFrame:[self frame]];
}

@end
