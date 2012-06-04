@implementation MFManifestObserver : CPObject
{
	CPArray _keysToObserve;
}




- (id)init
{
	self = [super init];
	if (self)
	{
		_keysToObserve = [CPArray arrayWithObjects:
			@"data.notes",
			nil
		];
		[self registerObservers];
	}
	return self;
}




- (void)registerObservers
{
	var manifest = [MFManifest sharedInstance];
	for(var i = 0; i < [_keysToObserve count]; i++)
	{
		[manifest addObserver:self
			forKeyPath:[_keysToObserve objectAtIndex:i]
			options:nil
			context:nil
		];
	}
}




- (void)observeValueForKeyPath:(CPString)aPath ofObject:(id)anObject
	change:(CPDictionary)change context:(void)context
{
	//jsonObj = [CKJSONKeyedArchiver archivedDataWithRootObject:[anObject data]];
	//console.log(JSON.stringify(jsonObj["CP.objects"]));
	//console.log(aPath);
}
@end
