<?php
/**
	\file Foundation.php
	\addtogroup Foundation
	The Foundation framework is a very lose implementation of Apple's Foundation
	framework and is meant to harden the logic that is built upon it.
	@{
 */
/** \enum A mapping to the boolean 'true' */
define("YES", TRUE);
/** \enum A mapping to the boolean 'false' */
define("NO", FALSE);

/** \enum The base directory at which the Foundation framework can be located.
 */
define("RT_FOUNDATION_DIR", dirname(__FILE__) . "/");


/** \enum This is set to PHP_INT_MAX */
define("RTNotFound", PHP_INT_MAX);


/** \enum An implementation of Apple's NSComparisonResult enum set. */
define("RTOrderedAscending", -1);
/** \enum An implementation of Apple's NSComparisonResult enum set. */
define("RTOrderedSame", 0);
/** \enum An implementation of Apple's NSComparisonResult enum set. */
define("RTOrderedDescending", 1);


require_once(RT_FOUNDATION_DIR . "CFPropertyList/CFPropertyList.php");


require_once(RT_FOUNDATION_DIR . "RTObject.php");
require_once(RT_FOUNDATION_DIR . "RTString.php");
require_once(RT_FOUNDATION_DIR . "RTArray.php");
require_once(RT_FOUNDATION_DIR . "RTMutableArray.php");
require_once(RT_FOUNDATION_DIR . "RTDictionary.php");
require_once(RT_FOUNDATION_DIR . "RTMutableDictionary.php");
require_once(RT_FOUNDATION_DIR . "RTRange.php");
require_once(RT_FOUNDATION_DIR . "RTURL.php");

/**
	@}
 */
