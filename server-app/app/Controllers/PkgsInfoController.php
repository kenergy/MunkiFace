<?php


class PkgsInfoController extends RTObject
{
	public function init()
	{
		parent::init();
		$request = HTTPRequest::sharedRequest();
		$plists = PkgsInfoModel::alloc()->init()->plists();
	
		echo $plists;

		return $this;
	}
}
