<?php

class ActiveDirectoryAuthDriver extends AbstractAuthDriver
{
	public function init()
	{
		parent::init();
		if (isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW']))
		{
			$this->setUsername($_SERVER['PHP_AUTH_USER']);
			$this->setPassword($_SERVER['PHP_AUTH_PW']);
		}
		$this->setAccountAuthority("ActiveDirectory");
		$this->createSession();
		return $this;
	}




	public function createSession()
	{
		$settings = Settings::sharedSettings();
		$url = RTURL::URLWithString(
			$settings->objectForKey("authentication_method")->objectForKey("url")
		);
		$host = $url->host();
		$port = $url->port();
		$queryArray = $url->query()->componentsSeparatedByString("?");
		if ($queryArray->count() < 2)
		{
			throw new Exception(
				"ActiveDiretoryAuthDriver requires at least an attribute and a scope.",
				MFAuthDriverError
			);
		}
		$attribute = $queryArray->firstObject();
		$scope = $queryArray->objectAtIndex(1);
		$filter = "(objectClass=*)";
		if ($queryArray->count() == 3)
		{
			$filter = $queryArray->objectAtIndex(2);
		}



	}




	public function destroySession()
	{
		//
	}




	public function hasSession()
	{
		return YES;
	}
}
