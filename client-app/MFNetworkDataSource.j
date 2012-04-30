/**
	Akin to retain count, this static variable helps the MFNetworkDataSource know
	if the most recent request that completed was in fact the last one.
 */
var MFNetworkDataSource_ACTIVE_REQUEST_COUNT = 0;

/**
	A static BOOL that is set when the sheet that tells the admin an action is
	taking longer than expected is displayed or dismissed.
 */
var MFNetworkDataSource_INDETERMINATE_SHEET_IS_DISPLAYED = NO;

/**
	The timer is set to fire once every 0.1 seconds while waiting for a response.
	Each time the timer is fired, this value is incremented by 0.1 so
	MFNetworkDataSource will know when it's been too long.
 */
var MFNetworkDataSource_SECONDS_SINCE_FIRST_REQUEST = 0.0;

/**
	This can be adjusted to tell MFNetworkDataSource when it should display the
	sheet that lets the admin know a request is happening, but we're still
	waiting.
 */
var MFNetworkDataSource_SECONDS_ALLOWED_BEFORE_SHEET = 0.5;

/**
	A static pointer to the sheet.
 */
var MFNetworkDataSource_INDETERMINATE_SHEET_INSTANCE = nil;




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
 */
@implementation MFNetworkDataSource : CPObject
{
	CPString dataSourceURI @accessors;
	CPURLRequest _dataSourceRequest;
	BOOL _convertDataToDictionary;
	BOOL _requestInProgress;
	BOOL _indeterminateSheetIsVisible;
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
	[self _reloadDataAndConvertToDictionary:YES];
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
	[self _reloadDataAndConvertToDictionary:NO];
}




- (void)_reloadDataAndConvertToDictionary:(BOOL)aBool
{
	MFNetworkDataSource_ACTIVE_REQUEST_COUNT++;
	var timer = [CPTimer scheduledTimerWithTimeInterval:0.1
		target:self
		selector:@selector(displayIndeterminateConnectionSheet:)
		userInfo:nil
		repeats:YES];
	var connection = [CPURLConnection connectionWithRequest:_dataSourceRequest
		delegate:self];
	_convertDataToDictionary = aBool;
}




- (void)_createIndeterminateSheet
{
	if (MFNetworkDataSource_INDETERMINATE_SHEET_INSTANCE == nil)
	{
		var sheet = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0,
		150.0, 25.0)
					styleMask:CPDocModalWindowMask];
		var mainView = [sheet contentView];
		var label = [CPTextField labelWithTitle:@"Waiting for server..."];
		var bounds = [mainView bounds];
		bounds.origin.y = bounds.size.height/2 - [label frame].size.height/2;
		[label setFrame:bounds];
		[label setAlignment:CPCenterTextAlignment];
		[mainView addSubview:label];

		MFNetworkDataSource_INDETERMINATE_SHEET_INSTANCE = sheet;
	}
	
	[CPApp beginSheet:MFNetworkDataSource_INDETERMINATE_SHEET_INSTANCE
		 modalForWindow:[[CPApplication sharedApplication] mainWindow]
		  modalDelegate:self
		 didEndSelector:nil
		    contextInfo:nil];
	
	MFNetworkDataSource_INDETERMINATE_SHEET_IS_DISPLAYED = YES;
}




/**
	Called by the timer that is created everytime a request is sent to the server.
	This method will add 0.1 seconds to the total running time that a set of
	requests are taking each time it is called. If then checks to see if there is
	at least one pending request. If so, it checks to see if the amount of time
	that has elapsed is greater than
	MFNetworkDataSource_SECONDS_ALLOWED_BEFORE_SHEET. If so, it will call
	_createIndeterminateSheet so that a sheet window is displayed to the user. If
	there are no more pending requests, the timer is invalidated and a call is
	made to dismissIndeterminateConnectionSheet.
 */
- (void)displayIndeterminateConnectionSheet:(CPTimer)aTimer
{
	var settings = [MFServerSettings sharedSettings];
	if ([[settings allKeys] count] == 0)
	{
		// The settings haven't been read yet, so we should wait to see if
		// authentication is required before attempting to display the sheet.
		return;
	}
	
	MFNetworkDataSource_SECONDS_SINCE_FIRST_REQUEST += 0.1;
	if (MFNetworkDataSource_ACTIVE_REQUEST_COUNT > 0)
	{
		if (MFNetworkDataSource_INDETERMINATE_SHEET_IS_DISPLAYED == YES)
		{
			// do nothing
		}
		else if (MFNetworkDataSource_SECONDS_SINCE_FIRST_REQUEST
			>= MFNetworkDataSource_SECONDS_ALLOWED_BEFORE_SHEET)
		{
			[self _createIndeterminateSheet];
		}
	}
	else
	{
		[aTimer invalidate];
		[self dismissIndeterminateConnectionSheet];
	}
}




- (void)dismissIndeterminateConnectionSheet
{
	if (MFNetworkDataSource_INDETERMINATE_SHEET_IS_DISPLAYED == YES
	&&MFNetworkDataSource_ACTIVE_REQUEST_COUNT == 0)
	{
		try
		{
			MFNetworkDataSource_INDETERMINATE_SHEET_IS_DISPLAYED = NO;
			MFNetworkDataSource_SECONDS_SINCE_FIRST_REQUEST = 0.0;
			[CPApp endSheet:MFNetworkDataSource_INDETERMINATE_SHEET_INSTANCE];
		}
		catch(e)
		{
			// do nothing, the window was probably attached and removed before the
			// application finished launching.
		}
	}
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
}



/*------------------------CPConnection Delegate Methods-----------------------*/
- (void)connection:(CPURLConnection) connection didReceiveData:(CPString)someData
{
	MFNetworkDataSource_ACTIVE_REQUEST_COUNT--;
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
				if (parsedData.MFServerException.code == 401)
				{
					alert("login required - The login window is coming soon. "
					 + "Revert to commit c8f70b6054, wait for the next update, or "
					 + "switch to the AllowAll authentication driver to restore "
					 + "functionality.");
					return;
				}
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
			console.log(anAlert);
			console.log("Displayed an alert");
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
	MFNetworkDataSource_ACTIVE_REQUEST_COUNT--;
	alert(error);
}
@end
