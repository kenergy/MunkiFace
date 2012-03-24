<?php


function JSONException($exception)
{
	$err = array(
		"MFServerException" => array(
			"code" => $exception->getCode(),
			"message" => $exception->getMessage()
		)
	);
	error_log($exception);
	echo json_encode($err);
	exit;
}




function JSONError($code, $message)
{
	$err = array(
		"MFServerError" => array(
			"code" => $code,
			"message" => $message
		)
	);
	error_log(json_encode($err));
	echo json_encode($err);
	exit;
}


set_exception_handler("JSONException");
set_error_handler("JSONError");
