<?php

define("PHPUNIT_BASE", dirname(__FILE__) . "/phpunit/");
define("PARENT_DIR", dirname(__FILE__) . "/");
define("PHPUNIT_OUTPUT_DIR", dirname(PARENT_DIR) . "/api-docs/");

//require_once(dirname(dirname(__FILE__)) . "/Frameworks/Foundation.php");
//require_once("phpunit.php");

// --configuration <file>

$dir = dirname(__FILE__) . "/";

$cmd = "/usr/bin/php " . PHPUNIT_BASE . "/phpunit/phpunit.php " .
	" --testdox-html " . PHPUNIT_OUTPUT_DIR . "testdox.html"
	. " --coverage-html " . PHPUNIT_OUTPUT_DIR . "coverage/"
	. " --colors"
	. " --stop-on-error"
//	. " --stop-on-failure"
	. " --stop-on-skipped"
	. " --stop-on-incomplete"
	. " --bootstrap " . PARENT_DIR . "bootstrap.php "
	. PARENT_DIR . "Tests/";

echo $cmd . "\n\n\n\n\n";
passthru($cmd);
