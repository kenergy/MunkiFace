


@implementation Model : CPObject
{
}


- (void)requestWithURL:(id)aURL
{
	var request = [CPURLRequest requestWithURL:aURL];
	var connection = [CPURLConneciton connectionWithRequest:request
												   delegate:self];
}




- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
	// This method is called when a connection receives a response. In a
	// multi-part request, this method will eventually be called multiple times,
	// once for each part of the response.
}




- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
	// This method is called if the request fails for any reason.
}
@end
