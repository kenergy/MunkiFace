/**
	A simple utility class that provides some basic network connectivity. To use
	this class you would generally want to inherit from it. Then, in your
	initialization code, you'll want to provide setDataSourceURI with a valid
	server URI; one that will produce JSON output. When you're ready to receive
	data, send the reloadData message. When the data has been received, this class
	will send the dataDidReload message to itself (your implementing class).

	This class is able to observe the length of time that overlapping requests are
	taking. For example, if there are two instances of this class (or subclass)
	and they both fire off a request, this class will count the number of
	milliseconds between the first request and the last response. If that amount
	of time surpasses MFNetworkDataSource_SECONDS_ALLOWED_BEFORE_SHEET, it will
	display a sheet window that lets the user know that the application is still
	waiting on data. Once the last response is received, the sheet will
	automatically be dismissed.
	\ingroup client-models
 */
@implementation MFNetworkDataSource : CPObject
{
	CPString dataSourceURI @accessors;
	CPURLRequest _dataSourceRequest;
	CPURLConnection _dataSourceConnection;
	BOOL _convertDataToDictionary;
}




#pragma mark - DataSource Methods
/** @name DataSource Methods
Additional accessor here is `- (CPString)dataSourceURI`
@{*/




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




/*@}*/
#pragma mark -
#pragma mark - Starting Connections
/** @name Starting Connections
@{*/




/**
	Asks for new data at dataSourceURI and converts the response from the server
	to a CPDictionary object before sending it through dataDidReload:.
	In your implementation, you should expect the data in the dataDidReload
	delegate method.
	\see MFNEtworkDataSource::reloadRawData
 */
- (void)reloadData
{
	[self _reloadDataAndConvertToDictionary:YES];
}




/**
	Asks for new data at dataSourceURI and attempts to parse the response from the
	server using JSON.parse before sending the data object back through
	MFNetworkDataSource::dataDidReload.
	In your implementation, you should expect the data in the
	MFNetworkDataSource::dataDidReload method.
	Unlike the MFNetworkDataSource::reloadData method, this method will pass the
	resulting JSON data through JSON.parse and then hand it over to the
	dataDidReload method. If you want the resulting object to be a CPDictionary,
	use MFNetworkDataSource::reloadData instead.
	\see MFNetworkDataSource::reloadData
 */
- (void)reloadRawData
{
	[self _reloadDataAndConvertToDictionary:NO];
}




/**
	Used internally by this class - there's probably no reason to ever call this
	manually.
 */
- (void)_reloadDataAndConvertToDictionary:(BOOL)aBool
{
	_dataSourceConnection = [CPURLConnection
		connectionWithRequest:_dataSourceRequest delegate:self];
	_convertDataToDictionary = aBool;
}




/*@}*/
#pragma mark -
#pragma mark - Getting Data From Connections
/** @name Getting Data From Connections
Subclasses should override these methods in order to receive data.
@{*/




/**
	This should be overridden by the implementing class in order to obtain the
	data object returned by the server. This class will always attempt to parse
	the returned data as a JSON object and then recursively transform that object
	into a CPDictionary.
	\param data
 */
- (void)dataDidReload:(id)someData
{
	CPLog.warn("MFNetworkDataSource::dataDidReload hasn't been overridden. "
		+ "How will you know when the data has been received?");
}




/**
	If the response was not JSON or was JSON but could not be parsed this method
	will be called. The default implementation is to log an error via
	CPLog.error(), but if you want to present a notification to the user, you
	should override this method.
 */
- (void)data:(id)someData didReloadWithError:(id)anError
{
	CPLog.error("[" + [self className] + "] Parse error: " + anError);
	CPLog.error("Data: " + someData);
	[self dataDidReload:nil];
}



/*@}*/
#pragma mark -
#pragma mark - CPConnection Delegate Methods
/** @name CPConnectionDelegate methods
@{*/


- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)someData
{
	var parsedData = nil;
	try
	{
		parsedData = JSON.parse(someData);
		if (parsedData.MFServerError || parsedData.MFServerException)
		{
			var errorMessage = "";
			var errorTitle = "";
			if (parsedData.MFServerError)
			{
				errorTitle = "MunkiFace Server Error " + parsedData.MFServerError.code;
				errorMessage = parsedData.MFServerError.message;
			}
			else
			{
				errorTitle = "MunkiFace Server Exception " +
					parsedData.MFServerException.code;
				errorMessage = parsedData.MFServerException.message;
			}

			var anAlert = [CPAlert alertWithMessageText:errorTitle
				defaultButton:@"Okay"
				alternateButton:nil
				otherButton:nil
				informativeTextWithFormat:errorMessage];
			[anAlert setAlertStyle:CPCriticalAlertStyle];
			[anAlert setTheme:[CPTheme defaultHudTheme]];
			[anAlert runModal];
			return;
		}
		if (_convertDataToDictionary == YES)
		{
			var dict = [CPDictionary dictionaryWithJSObject:parsedData recursively:YES];
			[self dataDidReload:dict];
		}
		else
		{
			[self dataDidReload:parsedData];
		}
	}
	catch(e)
	{
		[self data:someData didReloadWithError:e];
	}
}




- (void)connection:(CPURLConnection) connection didFailWithError:(CPString)error
{
	alert(error);
}




/*@}*/
#pragma mark -
@end
