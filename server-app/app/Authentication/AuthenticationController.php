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
		$authenticationMethod = $settings->objectForKey("authentication_method");

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
			default:
				throw new Exception("Unsupported authentication driver in "
					. "Settings.plist '" . $authenticationMethod . "'");
				// ldap
		}
		return $this;
	}
}


$c = AuthenticationController::alloc()->init();
