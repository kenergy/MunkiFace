#!/usr/bin/env php
<?php
/* PHPUnit
 *
 * Copyright (c) 2002-2011, Sebastian Bergmann <sebastian@phpunit.de>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Sebastian Bergmann nor the names of his
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


$base = dirname(dirname(__FILE__)) . "/";

set_include_path(
	$base . "dbunit" . PATH_SEPARATOR .
	$base . "php-code-coverage" . PATH_SEPARATOR .
	$base . "php-file-iterator" . PATH_SEPARATOR .
	$base . "php-text-template" . PATH_SEPARATOR .
	$base . "php-timer" . PATH_SEPARATOR .
	$base . "php-token-stream" . PATH_SEPARATOR .
	$base . "phpunit" . PATH_SEPARATOR .
	$base . "phpunit-mock-objects" . PATH_SEPARATOR .
	$base . "phpunit-selenium" . PATH_SEPARATOR .
	$base . "phpunit-story" . PATH_SEPARATOR .
	$base . "phpunit-invoker" .
	get_include_path()
);


if (strpos('@php_bin@', '@php_bin') === 0) {
    require dirname(__FILE__) . DIRECTORY_SEPARATOR . 'PHPUnit/Autoload.php';
} else {
    require '@php_dir@' . DIRECTORY_SEPARATOR . 'PHPUnit/Autoload.php';
}

PHPUnit_TextUI_Command::main();
