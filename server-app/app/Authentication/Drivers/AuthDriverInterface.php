<?php



interface AuthDriverInterface extends RTObject
{
	/**
		Returns the username portion of the authentication request, or "guest" if no
		username is required.
		\returns RTString
	 */
	public function username();




	/**
		Returns the source from which the user account should be extracted. This is
		most useful for accounts that come from ldap servers. For drivers that do
		not require authentication, 'none' is returned. For the WebServerAuthDriver,
		the server's signature should be returned.
		\returns RTString
	 */
	public function accountAuthority();




	/**
		Returns a BOOL value indicating that the user is currently authenticated or
		not. This will always return true for drivers that do not require
		authentication.
		\returns BOOL
	 */
	public function hasSession();




	/**
		Destroys the current session, assuming that hasSession returns YES.
	 */
	public function destroySession();




	/**
		Returns a BOOL value indicating that the user was able to create a session
		based on the credentials provided. This will always reurn true for drivers
		that do not require authentication.
		\returns BOOL
	 */
	public function createSession();




	/**
		Sets the username portion of the authentication request.
		\param $aUsername
	 */
	public function setUsername($aUsername);




	/**
		Sets the password portion of the authentication request.
		\param $aPassword
	 */
	public function setPassword($aPassword);
}
