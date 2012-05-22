@implementation MFNetworkLongPollingDataSource : MFNetworkDataSource
{
	CPDictionary data @accessors;
	BOOL shouldStopPolling;
	BOOL URIConverted;
}


- (void)dataDidReload:(id)someData
{
	CPLog("Data loaded from server");
	if (shouldStopPolling == nil)
	{
		CPLog(" -- reconnecting");
		var newURI = [self dataSourceURI];
		if (URIConverted == nil)
		{
			newURI = [[self dataSourceURI] stringByAppendingString:@"?fromNow"];
			URIConverted = YES;
		}
		[self setDataSourceURI:newURI];
		[self reloadData];
		CPLog(" -- Connection requested");
	}
	[self setData:someData];
}



/**
	Cancels the current XHR. The next call to reloadData will cause the receiver
	to start polling again.
 */
- (void)stopPolling
{
	shouldStopPolling = YES;
	[_dataSourceConnection cancel];
}
@end