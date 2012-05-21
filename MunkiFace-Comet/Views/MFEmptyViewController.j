/**
	This view controller doe nothing but let the user know that they need to
	select something before they will see any editor controls.
 */
@implementation MFEmptyViewController : CPViewController
{
	CPTextField label;
}




- (id)init
{
	self = [super init];
	if (self)
	{
		var backgroundColor = [CPColor colorWithHexString:@"cccccc"];
		var textColor = [CPColor colorWithHexString:@"888888"];
		var textShadowColor = [CPColor colorWithHexString:@"ffffff"];
		label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		[label setFont: [CPFont boldSystemFontOfSize:48.0]];
		[label setStringValue:@"No Selection"];
		[label setTextColor:textColor];
		[label setTextShadowColor:textShadowColor];
		[label setTextShadowOffset:CGSizeMake(0.0, 1.0)];
		[label sizeToFit];
		[label setAutoresizingMask: CPViewWidthSizable | CPViewMinXMargin | CPViewMaxXMargin |
		CPViewMinYMargin | CPViewMaxYMargin];

		var view = [[CPView alloc] initWithFrame:CGRectMakeZero()];
		[view setBackgroundColor:backgroundColor];
		[view addSubview:label];
		[self setView:view];
	}
	return self;
}
@end
