
@import <EKShakeAnimation.j>

var MFLoginWindowInstance = nil;
var MFLoginWindowIsVisible = NO;

@implementation MFLoginWindow : CPObject
{
	CPWindow theWindow;
	CPTextField username;
	CPTextField password;
	CPMutableArray connectionQueue;
}




- (id)init
{
	self = [super self];
	if (self)
	{
		connectionQueue = [CPMutableArray array];
	}
	return self;
}




+ (id)sharedLoginWindow
{
	if (MFLoginWindowInstance == nil)
	{
		MFLoginWindowInstance = [[MFLoginWindow alloc] init];
	}

	return MFLoginWindowInstance;
}




- (void)displayLoginWindow
{
	if (MFLoginWindowIsVisible == YES)
	{
		return;
	}
	requestQueue = [CPMutableArray array];
	theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
			styleMask:CPBorderlessBridgeWindowMask];
	var contentView = [theWindow contentView];
	var autoResizingMask = CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin;

	var img = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle]
		pathForResource:@"NSTexturedFullScreenBackgroundColor.png"]];
	var bgColor = [CPColor colorWithPatternImage:img];
	[contentView setBackgroundColor:bgColor];

	username = [CPTextField textFieldWithStringValue:nil
		placeholder:@"username" width:250.0];
  password = [CPTextField textFieldWithStringValue:nil
		placeholder:@"password" width:250.0];
	[password setSecure:YES];

	[username setFont:[CPFont boldSystemFontOfSize:18.0]];
	[password setFont:[CPFont boldSystemFontOfSize:18.0]];
	[username sizeToFit];
	[password sizeToFit];
	
	[username setAutoresizingMask:autoResizingMask];
	[password setAutoresizingMask:autoResizingMask];
	[username setCenter:[contentView center]];
	var centerFrame = [username frame];
	var usernameFrame = centerFrame;
	var passwordFrame = centerFrame;
	usernameFrame.origin.y -= centerFrame.size.height;
	[username setFrame:usernameFrame];
	passwordFrame.origin.y += centerFrame.size.height;
	[password setFrame:passwordFrame];
	[username setDelegate:self];
	[password setDelegate:self];
	[username setNextKeyView:password];
	[password setNextKeyView:username];
	
	
	var logoImage = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle]
	pathForResource:@"MFRoundLogo.png"]];
	var logo = [[CPImageView alloc] initWithFrame:CGRectMake(
		[username frame].origin.x + [username frame].size.width/2 - 75/2,
		[username frame].origin.y - 100.0,
		75.0,
		76.0)];
	[logo setImage:logoImage];
	[logo setAutoresizingMask:autoResizingMask];



	[contentView addSubview:logo];
	[contentView addSubview:username];
	[contentView addSubview:password];
	
	[theWindow setInitialFirstResponder:username];
	[theWindow makeKeyAndOrderFront:self];
	[theWindow setLevel:9999];
	MFLoginWindowIsVisible = YES;
}




- (void)addConnectionToQueue:(id)aConnection
{
	[aConnection cancel];
	[connectionQueue addObject:aConnection];
}




- (void)controlTextDidEndEditing:(id)aNotification
{
	var isPasswordControl = [[aNotification object] isSecure];
	if (isPasswordControl && [[username stringValue] isEqualToString:@""] == NO)
	{
		// Logging in
		[username setEnabled:NO];
		[password setEnabled:NO];
		var settings = [[CPBundle mainBundle] infoDictionary];
		var content = [CPString stringWithFormat:@"u=%@&p=%@",
			encodeURIComponent([username stringValue]),
			encodeURIComponent([password stringValue])];
		var request = [[CPURLRequest alloc] initWithURL:[settings
			objectForKey:@"MunkiFace Server URI"]];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:content];
		[request setValue:@"application/x-www-form-urlencoded"
			forHTTPHeaderField:@"Content-type"];
		[CPURLConnection connectionWithRequest:request delegate:self];
	}
}




- (void)connection:(CPURLConnection)aConnection didReceiveData:(id)someData
{
	for(var i = 0; i < [connectionQueue count]; i++)
	{
		var conn = [connectionQueue objectAtIndex:i];
		[conn start];
	}
	[theWindow close];
	MFLoginWindowIsVisible = NO;
}




- (void)connectionDidReceiveAuthenticationChallenge:(id)aConnection
{
	if ([aConnection delegate] != self)
	{
		[self addConnectionToQueue:aConnection];
		[self displayLoginWindow];
	}
	else
	{
		[username setEnabled:YES];
		[password setEnabled:YES];
		[[EKShakeAnimation alloc] initWithView:password];
	}
}
@end


var instance = [MFLoginWindow sharedLoginWindow];
[CPURLConnection setClassDelegate:instance];
