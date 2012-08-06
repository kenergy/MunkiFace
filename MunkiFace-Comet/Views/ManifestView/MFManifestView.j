@implementation MFManifestView : CPView
{
	CPPopupButton conditionsPopUp;
	CPPopupButton conditionOptionsPopUp;
	CPView selectedManifestLabel;
	LPMultiLineTextField conditionsEditor;
	CPTableView optionsTable;
}

- (id)initWithFrame:(CPRect)aRect
{
	self = [super initWithFrame:aRect];
	if (self)
	{
		// First we'll create the manifest header view
		selectedManifestLabel = [[CPTextField alloc] initWithFrame:CGRectMake(
			0, 0, 0, 30)];
		[selectedManifestLabel setTextColor: [CPColor whiteColor]];
		[selectedManifestLabel setFont: [CPFont boldSystemFontOfSize:14.0]];
		[selectedManifestLabel setAlignment: CPCenterTextAlignment];
		[selectedManifestLabel setVerticalAlignment: CPCenterTextAlignment];
		[self setManifestTitle:@"Select a manifest"];
		[selectedManifestLabel setAutoresizingMask: CPViewWidthSizable];
		[selectedManifestLabel setBackgroundColor: [CPColor colorWithPatternImage:
			[[CPImage alloc]
			initWithContentsOfFile:@"Resources/MFContentHeaderBackground.png"]]];

		
		// Next, we'll make the left and right panes
		var left = [[CPView alloc] initWithFrame:CGRectMake(
			5, 50, aRect.size.width/2 - 7.5, aRect.size.height-55)];
		var right = [[CPView alloc] initWithFrame:CGRectMake(
			aRect.size.width - (aRect.size.width/2 - 7.5), 50, aRect.size.width/2 - 7.5,
			aRect.size.height-55)];

		[left setAutoresizingMask:
			CPViewMaxXMargin | CPViewWidthSizable | CPViewHeightSizable];
		[right setAutoresizingMask:
			CPViewMinXMargin | CPViewWidthSizable | CPViewHeightSizable];
		


		// Now we'll add the controls to each pane
		var conditionsLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		var conditionsOptionsLabel = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		[conditionsLabel setStringValue: @"Conditions"];
		[conditionsOptionsLabel setStringValue: @"Options"];
		[conditionsLabel sizeToFit];
		[conditionsOptionsLabel sizeToFit];

		conditionsPopUp = [[CPPopUpButton alloc] initWithFrame:CGRectMake(
			0, 20, 200, 24)];
		conditionsOptionsPopUp = [[CPPopUpButton alloc] initWithFrame:CGRectMake(
			0, 20, 200, 24)];

		[conditionsPopUp addItemWithTitle:@"0"];
		[conditionsOptionsPopUp addItemsWithTitles:[
			@"Catalogs",
			@"Included Manifests",
			@"Managed Installs",
			@"Managed Uninstalls",
			@"Managed Updates",
			@"Optional Installs"]];


		// Create the conditions text editor
		conditionsEditor = [[LPMultiLineTextField alloc] initWithFrame:CGRectMake(
			0, 50, [left bounds].size.width, [left bounds].size.height-50)];
		[conditionsEditor setAutoresizingMask:
			CPViewWidthSizable | CPViewHeightSizable];
		[conditionsEditor setStringValue:@"This is some\nmulti-line text"];
		[conditionsEditor setBezeled:YES];
		[conditionsEditor setEditable:YES];


		// Create the options table and controls
		optionsTable = [[CPTableView alloc] initWithFrame:CGRectMake(
			0, 50, [right bounds].size.width, [right bounds].size.height - 50)];
		[optionsTable setUsesAlternatingRowBackgroundColors:YES];
		[optionsTable setAutoresizingMask: CPViewWidthSizable |
		CPViewHeightSizable];

		[left addSubview: conditionsLabel];
		[left addSubview: conditionsEditor];
		[left addSubview: conditionsPopUp];
		[right addSubview: conditionsOptionsLabel];
		[right addSubview: conditionsOptionsPopUp];
		[right addSubview: optionsTable];


		[self addSubview: selectedManifestLabel];
		[self addSubview: left];
		[self addSubview: right];
	}
	return self;
}




- (void)setManifestTitle:(CPString)aTitle
{
	[selectedManifestLabel setStringValue:aTitle];
}




- (CPString)manifestTitle
{
	return [selectedManifestLabel stringValue];
}

@end
