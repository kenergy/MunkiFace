/**
	A simple utility class that provides some basic network connectivity. To use
	this class you would generally want to inherit from it. Then, in your
	initialization code, you'll want to provide setDataSourceURI with a valid
	server URI; one that will produce JSON output. When you're ready to receive
	data, send the reloadData message. When the data has been received, this class
	will send the dataDidReload message to itself (your implementing class).
 */
@implementation MFNetworkDataSource : CPObject
{
	CPString dataSourceURI @accessors;
	CPURLRequest _dataSourceRequest;
}




- (void)setDataSourceURI:(CPString)aURI
{
	dataSourceURI = aURI;
	_dataSourceRequest = [CPURLRequest requestWithURL:dataSourceURI];
}




/**
	Asks for new data at dataSourceURI and sets 'self' as the delegate.
 */
- (id)reloadData
{
	var connection = [CPURLConnection connectionWithRequest:_dataSourceRequest
		delegate:self];
}




/**
	This should be overridden by the implementing class in order to obtain the
	data object returned by the server. This class will always attempt to parse
	the returned data as a JSON object and then recursively transform that object
	into a CPDictionary.
	\param data
 */
- (void)dataDidReload:(CPDictionary)data
{
	CPLog("MFNetworkDataSource::dataDidReload hasn't been overridden. "
		+ "How will you know when the data has been received?");
}



/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)data
{
	var dict = [CPDictionary dictionaryWithJSObject:JSON.parse(data)
		recursively:YES];
	[self dataDidReload:dict];
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
