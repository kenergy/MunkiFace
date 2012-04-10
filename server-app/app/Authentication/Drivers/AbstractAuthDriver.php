<?php
session_start();

abstract class AbstractAuthDriver extends RTObject
{
	protected $_sess;
	protected $_username;
	protected $_password;
	protected $_accountAuthority;




	public function init()
	{
		parent::init();
		$this->sess = RTDictionary::dictionaryWithPHPArray($_SESSION);
		if ($this->sess->allKeys()->containsObject("username"))
		{
			$this->setUsername($this->sess->objectForKey("username"));
		}
		if ($this->sess->allKeys()->containsObject("pass"))
		{
			$this->setPassword($this->sess->objectForKey("pass"));
		}
		return $this;
	}
	
	
	
	
	protected function setAccountAuthority($anAuthorityString)
	{
		$this->_accountAuthority = RTString::stringWithString($anAuthorityString);
	}
	
	
	
	
	/**
		Returns the username portion of the authentication request, or "guest" if no
		username is required.
		\returns RTString
	 */
	public function username()
	{
		return $this->_username;
	}




	protected function password()
	{
		return $this->_password;
	}




	/**
		Returns the source from which the user account should be extracted. This is
		most useful for accounts that come from ldap servers. For drivers that do
		not require authentication, 'none' is returned. For the WebServerAuthDriver,
		the server's signature should be returned.
		\returns RTString
	 */
	public function accountAuthority()
	{
		return $this->_accountAuthority;
	}




	/**
		Returns a BOOL value indicating that the user is currently authenticated or
		not. This will always return true for drivers that do not require
		authentication.
		\returns BOOL
	 */
	public function hasSession()
	{
		$keys = $this->_sess->allKeys();
		return $keys->containsObject("username") && $keys->containsObject("pass");
	}




	/**
		Destroys the current session, assuming that hasSession returns YES.
	 */
	public function destroySession()
	{
		unset($_SESSION['username']);
		unset($_SESSION['pass']);
	}




	/**
		Returns a BOOL value indicating that the user was able to create a session
		based on the credentials provided. This will always reurn true for drivers
		that do not require authentication.
		\returns BOOL
	 */
	public function createSession()
	{
		$_SESSION['username'] = $this->username();
		$_SESSION['pass'] = $this->password();
	}
	
	
	
	
	/**
		Sets the username portion of the authentication request.
		\param $aUsername
	 */
	public function setUsername($aUsername)
	{
		$this->_username = RTString::stringWithString($aUsername);
	}




	/**
		Sets the password portion of the authentication request.
		\param $aPassword
	 */
	public function setPassword($aPassword)
	{
		$this->_password = RTString::stringWithString($aPassword);
	}
}
