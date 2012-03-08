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
	BOOL _convertDataToDictionary;
}




/**
	Set the URI that will be used in all future requests made by calling
	MFNetworkDataSource::reloadData. There is nothing wrong with using the same
	instance of the receiver to make multiple requests to multiple URIs.
 */
- (void)setDataSourceURI:(CPString)aURI
{
	dataSourceURI = aURI;
	_dataSourceRequest = [CPURLRequest requestWithURL:dataSourceURI];
}




/**
	Asks for new data at dataSourceURI and sets 'self' as the delegate.
	In your implementation, you should expect the data in the dataDidReload
	delegate method.
	\see MFNEtworkDataSource::reloadRawData
 */
- (void)reloadData
{
	var connection = [CPURLConnection connectionWithRequest:_dataSourceRequest
		delegate:self];
	_convertDataToDictionary = YES;
}




/**
	Asks for new data at dataSourceURI and sets 'self' as the delegate.
	In your implementation, you should expect the data in the dataDidReload
	delegate method.
	Unlike the MFNetworkData::reloadData method, this method will pass the
	resulting JSON data through JSON.parse and then hand it over to the
	dataDidReload method. If you want the resulting object to be a CPDictionary,
	use MFNetworkDataSource::reloadData instead.
	\see MFNetworkDataSource::reloadData
 */
- (void)reloadRawData
{
	var connection = [CPURLConnection connectionWithRequest:_dataSourceRequest
		delegate:self];
	_convertDataToDictionary = NO;
}




/**
	This should be overridden by the implementing class in order to obtain the
	data object returned by the server. This class will always attempt to parse
	the returned data as a JSON object and then recursively transform that object
	into a CPDictionary.
	\param data
 */
- (void)dataDidReload:(id)someData
{
	CPLog("MFNetworkDataSource::dataDidReload hasn't been overridden. "
		+ "How will you know when the data has been received?");
}



/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)someData
{
	if (_convertDataToDictionary == YES)
	{
		var dict = [CPDictionary dictionaryWithJSObject:JSON.parse(someData)
			recursively:YES];
		[self dataDidReload:dict];
	}
	else
	{
		[self dataDidReload:JSON.parse(someData)];
	}
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}
@end
