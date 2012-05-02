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

	var img = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle]
		pathForResource:@"NSTexturedFullScreenBackgroundColor.png"]];
	var bgColor = [CPColor colorWithPatternImage:img];
	[contentView setBackgroundColor:bgColor];


	username = [CPTextField textFieldWithStringValue:nil
		placeholder:@"username" width:250.0];
  password = [CPTextField textFieldWithStringValue:nil
		placeholder:@"password" width:250.0];
	[password setSecure:YES];

	[username setFont:[CPFont boldSystemFontOfSize:24.0]];
	[password setFont:[CPFont boldSystemFontOfSize:24.0]];
	[username sizeToFit];
	[password sizeToFit];
	
	[username setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
	[password setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
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
		alert("Authentication Failed");
	}
}
@end


var instance = [MFLoginWindow sharedLoginWindow];
[CPURLConnection setClassDelegate:instance];
