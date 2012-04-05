<?php

class WebServerAuthDriver extends AbstractAuthDriver
{
	public function init()
	{
		parent::init();
		$server = $_SERVER['SERVER_SIGNATURE'];
		$server = strlen($server) === 0 ? $_SERVER['SERVER_SOFTWARE'] : $server;
		$this->setAccountAuthority($server);
		$u = isset($_SERVER['PHP_AUTH_USER']) ? $_SERVER['PHP_AUTH_USER'] : "";
		$p = isset($_SERVER['PHP_AUTH_PW']) ? $_SERVER['PHP_AUTH_PW'] : "";
		$this->setUsername($u);
		$this->setPassword($p);
		return $this;
	}




	public function createSession()
	{
		//
	}




	public function destroySession()
	{
		//
	}




	public function hasSession()
	{
		return isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW']);
	}
}
