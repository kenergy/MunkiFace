/**
	A utility class that will provide the search row templates for the
	CPPredicateEditor on the fly. Since manifests, catalogs and packages all look
	a little different, they deserve custom search options.
	\ingroup client-views
 */
@implementation MFPredicateRowTemplates : CPObject
{
}


/**
	Provides the search row templates used when searching through pkgsinfo files.
 */
+ (CPArray)pkgsinfoSearchRows
{
	var keyPaths = [MFPredicateRowTemplates _buildExpressionFromArray:
		[CPArray arrayWithObjects:
			@"autoremove",
			@"blocking_applications",
			@"catalogs",
			@"description",
			@"display_name",
			@"force_install_after_date",
			@"forced_install",
			@"forced_uninstall",
			@"installed_size",
			@"installer_item_hash",
			@"installer_item_location",
			@"installer_item_size",
			@"installer_type",
			@"minimum_os_version",
			@"maximum_os_version",
			@"name",
			@"PackageCompleteURL",
			@"PackageURL",
			@"package_path",
			@"postinstall_script",
			@"postuninstall_script",
			@"preinstall_script",
			@"preuninstall_script",
			@"requires",
			@"RestartAction",
			@"supported_architectures",
			@"suppress_bundle_relocation",
			@"unattended_install",
			@"unattended_uninstall",
			@"uninstall_method",
			@"uninstall_script",
			@"uninstaller_item_location",
			@"uninstallable",
			@"update_for",
			@"version",
			@"receipts",
			@"installs",
			@"items_to_copy",
			@"installer_choices_xml",
			@"installer_environment",
			@"adobe_install_info",
			nil]
	];
	
	var operators = [MFPredicateRowTemplates _buildOperatorsFromArray:
		[CPArray arrayWithObjects:
			CPEqualToPredicateOperatorType, CPNotEqualToPredicateOperatorType,
			CPBeginsWithPredicateOperatorType, CPEndsWithPredicateOperatorType,
			CPContainsPredicateOperatorType,
			CPGreaterThanOrEqualToPredicateOperatorType,
			CPGreaterThanPredicateOperatorType,
			CPLessThanOrEqualToPredicateOperatorType,
			CPLessThanPredicateOperatorType, nil]];
	
	var options = (CPCaseInsensitivePredicateOption | CPDiacriticInsensitivePredicateOption);

	var template = [[CPPredicateEditorRowTemplate alloc]
		     initWithLeftExpressions:keyPaths
		rightExpressionAttributeType:CPStringAttributeType
		                    modifier: CPDirectPredicateModifier
		                   operators: operators
		                     options: options];
	
	var compoundTypes = [CPArray arrayWithObjects:
		[CPNumber numberWithInt:CPNotPredicateType],
		[CPNumber numberWithInt:CPAndPredicateType],
		[CPNumber numberWithInt:CPOrPredicateType],
		nil];
	
	var compound = [[CPPredicateEditorRowTemplate alloc]
		initWithCompoundTypes:compoundTypes];
	
	var rowTemplates = [CPArray arrayWithObjects:template, compound, nil];
	var rowTemplates = [CPArray arrayWithObjects:template, compound, nil];

	return rowTemplates;
}




+ (CPArray)_buildOperatorsFromArray:(CPArray)anArray
{
	var operators = [CPMutableArray array];
	for (var i = 0; i < [anArray count]; i++)
	{
		[operators addObject:[CPNumber numberWithInt:[anArray objectAtIndex:i]]];
	}
	return operators;
}




+ (CPArray)_buildExpressionFromArray:(CPArray)anArray
{
	var arr = [anArray sortedArrayUsingFunction:function(left, right)
	{
		return [[left description] caseInsensitiveCompare:[right description]];
	}];
	var expr = [CPMutableArray array];
	for (var i = 0; i < [arr count]; i++)
	{
		[expr addObject:[CPExpression expressionForKeyPath:
			[arr objectAtIndex:i]]];
	}
	return expr;
}

@end
