/**
	This class extends CPTextField in order to capture the mouseUp event and
	redirect the user's browser to the value of stringValue.
 */
@implementation DownloadableTextField : CPTextField


/**
	Redirects the user to the stringValue of the receiver when the user clicks and
	then releases the mouse on this object.
	\todo This is currently updaing window.location, there has to be a better way
	to present the user with a file to download than this.
 */
- (void)mouseUp:(CPEvent)anEvent
{
	var url = [self stringValue];

	if (url != "")
	{
		// \TODO This is totally not the best way to resolve this problem in a
		// cappuccino app, but it works in a pinch to convert a CPTextField into a
		// clickable label.
		window.location = [self stringValue];
	}
}

@end
