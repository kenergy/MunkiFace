<?php
require_once (dirname(__FILE__) . "/Drivers/AbstractAuthDriver.php");
/**
	AuthenticationController reads Settings.plist to determine what authentication
	driver to use, if any.
	If no authentication is required for this instance of MunkiFace server app,
	then use the "danger" authentication driver (this is not a good practice as it
	will leave your Munki repository open to editing by anyone, but may be desired
	for setting up a test instance).

	Otherwise, this class will load the desired driver and use it to determine if
	the client has an active session or not. If not, the client will be asked to
	authenticate via HTTP headers and execution of the request will halt. If so,
	no further action is taken and the request is allowed to conrinue processing.
 */
class AuthenticationController extends RTObject
{
	protected $driver;


	public function init()
	{
		parent::init();
		$settings = Settings::sharedSettings();
		$authenticationMethod =
		$settings->objectForKey("authentication_method")->objectForKey("driver");

		switch($authenticationMethod)
		{
			case "AllowAll":
				require_once dirname(__FILE__) . "/Drivers/AllowAllAuthDriver.php";
				$this->driver = AllowAllAuthDriver::alloc()->init();
				break;

			case "WebServer":
				require_once dirname(__FILE__) . "/Drivers/WebServerAuthDriver.php";
				$this->driver = WebServerAuthDriver::alloc()->init();
				break;

			case "LDAP":
				require_once dirname(__FILE__) . "/Drivers/LDAPAuthDriver.php";
				$this->driver = LDAPAuthDriver::alloc()->init();
				$this->requireBasicAuthentication();
				break;

			case "ActiveDirectory":
				require_once dirname(__FILE__) . "/Drivers/ActiveDirectoryAuthDriver.php";
				$this->driver = ActiveDirectoryAuthDriver::alloc()->init();
				$this->requireBasicAuthentication();
				break;

			default:
				throw new Exception("Unsupported authentication driver in "
					. "Settings.plist '" . $authenticationMethod . "'");
		}

		if ($this->driver->hasSession() == NO)
		{
			echo "Failed to bind";
			exit;
		}
		return $this;
	}




	protected function requireBasicAuthentication()
	{
		if (!isset($_SERVER['PHP_AUTH_USER']) || $this->driver->hasSession() == NO)
		{
			if (headers_sent())
			{
				throw new Exception(
					"Garbage already sent in the headers; unable to request authentication");
			}
			header('WWW-Authenticate: Basic realm="MunkiFace Server"');
			header('HTTP/1.0 401 Unauthorized');
			die("Authorization required");
		}
	}
}

$c = AuthenticationController::alloc()->init();
