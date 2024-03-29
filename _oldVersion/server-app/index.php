<?php
require_once (dirname(__FILE__) . "/app/bootstrap.php");

$request = HTTPRequest::sharedRequest();


if ($request->allKeys()->containsObject("target"))
{
	IndexController::alloc()->init();
}
else if ($request->allKeys()->containsObject("MFTarget"))
{
	MFTargetController::alloc()->init();
}
else
{
	include dirname(__FILE__) . "/app/help.php";
}
