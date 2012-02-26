<?php



class PkgsController extends RTObject
{
	public function init()
	{
		parent::init();
		$packages = PkgsModel::alloc()->init()->packages();
		echo $packages;
		return $this;
	}
}
