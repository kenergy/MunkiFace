@implementation CPTextField (Downloadable)

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
