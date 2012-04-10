<?php
require_once(dirname(__FILE__) . "/LDAP.php");

class LDAPAuthDriver extends AbstractAuthDriver
{
	protected $_url;
	protected $_ldap;
	protected $_authenticationDone;
	
	
	
	
	public function init()
	{
		$this->_ldap = LDAP::alloc()->init();
		parent::init();
		$settings = Settings::sharedSettings();
		$url = RTURL::URLWithString(
			$settings->objectForKey("authentication_method")->objectForKey("AuthLDAPURL")
		);
		$this->_ldap->setURL($url);

		$this->setAccountAuthority($url->host());
		return $this;
	}




	public function setUsername($aUsername)
	{
		parent::setUsername($aUsername);
		$this->_ldap->setUsername($aUsername);
	}




	public function setPassword($aPassword)
	{
		parent::setPassword($aPassword);
		$this->_ldap->setPassword($aPassword);
	}




	public function createSession()
	{
		if ($this->hasSession())
		{
			return YES;
		}

		$results = $this->_ldap->search($this->username());
		if ($results->count() == 0)
		{
			$this->_authenticationDone = NO;
		}
		else
		{
			$dn = $results->allKeys()->firstObject();
			//$record = $results->objectForKey($dn);
			$canBind = $this->_ldap->bind($dn, $this->password());
	
			if ($canBind == YES)
			{
				$this->_authenticationDone = YES;
			}
		}
		
		return $this->_authenticationDone;
	}




	public function hasSession()
	{
		return $this->_authenticationDone === YES;
	}
}
