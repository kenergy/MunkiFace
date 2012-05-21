@implementation MFSplitView : CPSplitView
{
	float initialSplitterPosition @accessors;
	float minSplitterPosition @accessors;
	float maxSplitterPosition @accessors;
}


- (id)initWithFrame:(CGRect)aRect
{
	self = [super initWithFrame:aRect];
	if (self)
	{
		// Make sure the split view will fill its available bounds and resize with
		// its parent by default
		[self setAutoresizingMask: CPViewHeightSizable | CPViewWidthSizable];
		//[self setInitialSplitterPosition:250.0];
		[self setMinSplitterPosition:50.0];
		[self setMaxSplitterPosition:500.0];

		// Add some placeholder views
		/**
		var view1 = [[CPView alloc] initWithFrame:CGRectMake(
			0.0, 0.0, 200.0, 200.0
		)];
		var view2 = [[CPView alloc] initWithFrame:CGRectMake(
			0.0, 0.0, 200.0, 200.0
		)];
		[self addSubview:view1];
		[self addSubview:view2];
		*/
		// set ourself as the delegate
		[self setDelegate:self];
	}
	return self;
}



/**
	Reimplemented from CPView to make sure the splitter ends up where it's
	supposed to when the splitview changes superviews.
 */
- (void)viewWillMoveToSuperview:(CPView)aView
{
	//[self setPosition:[self initialSplitterPosition] ofDividerAtIndex:0];
}



#pragma mark delegate methods


- (float)splitView:(CPSplitView)aView constrainMinCoordinate:(float)proposedMin
	ofSubviewAt:(int)subviewIndex
{
	if (subviewIndex == 0)
	{
		return [self minSplitterPosition];
	}
	return 0.0;
}




- (float)splitView:(CPSplitView)aView constrainMaxCoordinate:(float)proposedMax
	ofSubviewAt:(int)subviewIndex
{
	if (subviewIndex == 0)
	{
		return [self maxSplitterPosition];
	}
	return 0.0;
}
@end
