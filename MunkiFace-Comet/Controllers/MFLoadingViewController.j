/**
	This view controller is added to the application before the data has been
	loaded, and therefore is only displayed one time. Its entire purpose is to let
	the user know that their data is loading.
	\ingroup client-views
 */
@implementation MFLoadingViewController : CPViewController
{
	CPTextField label;
}




- (id)init
{
	self = [super init];
	if (self)
	{
		var backgroundColor = [CPColor colorWithHexString:@"cccccc"];
		var textColor = [CPColor colorWithHexString:@"666666"];
		var textShadowColor = [CPColor colorWithHexString:@"ffffff"];
		label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		[label setFont: [CPFont boldSystemFontOfSize:24.0]];
		[label setStringValue:@"Loading Munki Repository..."];
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
