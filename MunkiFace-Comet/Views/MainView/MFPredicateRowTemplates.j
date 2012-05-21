/**
	A utility class that will provide the search row templates for the
	CPPredicateEditor on the fly. Since manifests, catalogs and packages all look
	a little different, they deserve custom search options.
 */
@implementation MFPredicateRowTemplates : CPObject
{
}


/**
	Provides the search row templates used when searching through pkgsinfo files.
 */
+ (CPArray)pkgsinfoSearchRows
{
	var keyPaths = [CPArray arrayWithObjects:
		[CPExpression expressionForKeyPath:@"min_os_version"],
		[CPExpression expressionForKeyPath:@"max_os_version"],
		nil];
	
	var operators = [CPArray arrayWithObjects:
		[CPNumber numberWithInt:CPEqualToPredicateOperatorType],
		[CPNumber numberWithInt:CPNotEqualToPredicateOperatorType],
		[CPNumber numberWithInt:CPBeginsWithPredicateOperatorType],
		[CPNumber numberWithInt:CPEndsWithPredicateOperatorType],
		[CPNumber numberWithInt:CPContainsPredicateOperatorType],
		nil];
	
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

@end
