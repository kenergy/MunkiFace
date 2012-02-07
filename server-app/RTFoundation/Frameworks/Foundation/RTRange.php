<?php




/**
	Represents the enumeration RTRange, which always contains two public fields:
	location and length.
	\ingroup Foundation
 */
class RTRange extends RTObject
{
	public $location;
	public $length;

	public function __construct($aLocation,  $aLength)
	{
		$this->location = $aLocation;
		$this->length = $aLength;
	}
}



/**
	\addtogroup Foundation
	@{
 */
class RTRangeException extends Exception
{
}





function RTMakeRange($aLocation, $aLength)
{
	if (is_a($aLocation, "RTObject"))
	{
		$aLocation = floatval($aLocation->description());
	}
	if (is_a($aLength, "RTObject"))
	{
		$aLength = floatval($aLength->description());
	}
	return new RTRange($aLocation, $aLength);
}


function RTCopyRange(RTRange $aRange)
{
	return RTMakeRange($aRange->location, $aRange->length);
}


function RTMakeRangeCopy(RTRange $aRange)
{
	return RTCopyRange($aRange);
}


function RTEmptyRange(RTRange $aRange)
{
	return $aRange->length == 0.0;
}


function RTMaxRange(RTRange $aRange)
{
	return $aRange->location + $aRange->length;
}


function RTEqualRanges(RTRange $lhsRange, RTRange $rhsRange)
{
	return (($lhsRange->location === $rhsRange->location) && ($lhsRange->length ==
	$rhsRange->length));
}


function RTLocationInRange($aLocation, RTRange $aRange)
{
	return ($aLocation >= $aRange->location) && ($aLocation <= RTMaxRange($aRange));
}


function RTUnionRange(RTRange $lhsRange, RTRange $rhsRange)
{
	$location = min($lhsRange->location, $rhsRange->location);
	return RTMakeRange($location, MAX(RTMaxRange($lhsRange), RTMaxRange($rhsRange)) - $location);
}


function RTIntersectionRange(RTRange $lhsRange, RTRange $rhsRange)
{
	if (RTMaxRange($lhsRange) < $rhsRange->location || RTMaxRange($rhsRange) <
			$lhsRange->location)
	{
		return RTMakeRange(0, 0);
	}

	$location = max($lhsRange->location, $rhsRange->location);
	return RTMakeRange($location, min(RTMaxRange($lhsRange), RTMaxRange($rhsRange)));
}


function RTRangeInRange(RTRange $lhsRange, RTRange $rhsRange)
{
	return ($lhsRange->location <= $rhsRange->location && RTMaxRange($lhsRange) >=
	RTMaxRange($rhsRange));
}


function RTStringFromRange(RTRange $aRange)
{
	return json_encode($aRange);
}




function RTRangeFromString($aString)
{
	$vals = json_decode($aString);
	return RTMakeRange($vals->location, $vals->length);
}




/** @} */
