<?php
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
		echo "Hi";

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
				// ldap
		}

		$driverPath = dirname(__FILE__) . "/Drivers"
			. $d . "AuthenticationDriver.php";
		if (is_file($driverPath))
		{
			require_once($driverPath);

		}
		else
		{
			throw new Exception("Unable to load authentication driver '" . $d . "'");
		}
		return $this;
	}
}


$c = AuthenticationController::alloc()->init();
