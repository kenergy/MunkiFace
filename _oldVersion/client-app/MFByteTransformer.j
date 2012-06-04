var BYTE_SUFFIX_ARRAY = ["KB", "MB", "GB", "TB", "PB"];

/**
	Transforms kilobyte values to a more human readable form. For instance, a
	value of 1024 would be transformed to "1MB" and a value of 44040192 would be
	transformed to "42GB"
 */
@implementation MFByteTransformer : CPValueTransformer
{
}

- (BOOL)allowsReverseTransformation
{
	return NO;
}




/**
	Accepts an integer representing kilobytes and divides that value by 1024 until
	it is less than 1024. Each division also changes the suffix of the value to
	one of KB, MB, GB, TB, PB.
	\returns CPString
 */
- (CPString)transformedValue:(id)aValue
{
	if (aValue == nil)
	{
		return nil;
	}
	var i = 0;
	while(aValue >= 1024)
	{
		i++;
		aValue = aValue / 1024;
	}

	var roundedValue = Math.round(2.0 * aValue) / 2.0;
	var formatter = [[CPNumberFormatter alloc] init];
	[formatter setMaximumFractionDigits:2];
	[formatter setRoundingMode:CPNumberFormatterRoundDown];
	var output = [formatter stringFromNumber:[CPNumber
		numberWithFloat:roundedValue]];
	[formatter release];

	return [output stringByAppendingString:@" " + BYTE_SUFFIX_ARRAY[i]];
}
@end
