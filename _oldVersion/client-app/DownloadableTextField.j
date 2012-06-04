/**
	This class extends CPTextField in order to capture the mouseUp event and
	redirect the user's browser to the value of stringValue.
 */
@implementation DownloadableTextField : CPTextField


/**
	Redirects the user to the stringValue of the receiver when the user clicks and
	then releases the mouse on this object.
 */
- (void)mouseUp:(CPEvent)anEvent
{
	var url = [self stringValue];

	if (url != "")
	{
		if (!self.iFrame)
		{
			self.iFrame = document.createElement('iframe');
			self.iFrame.style.position = "absolute";
			self.iFrame.style.top = "-100px";
			self.iFrame.style.left = "-100px";
			self.iFrame.style.height = "0px";
			self.iFrame.style.width = "0px";
			document.body.appendChild(self.iFrame);
		}
		self.iFrame.src = [self stringValue];
	}
}




- (void)mouseEntered:(CPEvent)anEvent
{
	if ([self stringValue] != "")
	{
		[[CPCursor pointingHandCursor] set];
	}
}




- (void)mouseExited:(CPEvent)anEvent
{
	[[CPCursor arrowCursor] set];
}

@end
