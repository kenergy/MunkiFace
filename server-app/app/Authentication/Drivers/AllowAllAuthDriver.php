<?php

class AllowAllAuthDriver extends AbstractAuthDriver
{
	public function init()
	{
		parent::init();
		$this->setAccountAuthority("none");
		$this->setUsername("guest");
		return $this;
	}
}
