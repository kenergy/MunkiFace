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

		if (isset($_GET['logout']))
		{
			if (ini_get("session.use_cookies"))
			{
				$params = session_get_cookie_params();
				setcookie(
					session_name(), '', time() - 42000,
					$params["path"], $params["domain"],
					$params["secure"], $params["httponly"]
				);
			}
			else
			{
				unset($_SESSION['u']);
				unset($_SESSION['p']);
			}
			header("Location: http://" . $_SERVER['HTTP_HOST']
				. "/" . $_SERVER['PHP_SELF']);
			exit;
		}

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

		return $this;
	}




	protected function requireBasicAuthentication()
	{
		$hasSession = isset($_SESSION['u']) && isset($_SESSION['p']);
		if ($hasSession == NO)
		{
			$credsExistInPost = isset($_POST['u']) && isset($_POST['p']);
			if ($credsExistInPost == YES)
			{
				$this->driver->setUsername($_POST['u']);
				$this->driver->setPassword($_POST['p']);
				if ($this->driver->createSession() == NO)
				{
					$this->askForAuthentication();
				}
				else
				{
					$_SESSION['u'] = $_POST['u'];
					$_SESSION['p'] = $_POST['p'];
				}
			}
			else
			{
				$this->askForAuthentication();
			}
		}
	}




	protected function askForAuthentication()
	{
		if (headers_sent())
		{
			throw new Exception(
				"Garbage already sent in the headers; unable to requrest authentication"
			);
		}
		header("HTTP/1.0 401 Unauthorized");
		throw new Exception("Authorization required", MFUnauthorizedError);
		die("Authorization required");
	}
}

$c = AuthenticationController::alloc()->init();
