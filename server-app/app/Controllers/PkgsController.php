<?php



class PkgsController extends AbstractController
{
	public function init()
	{
		parent::init();
		$packages = PkgsModel::alloc()->init()->packages();
		echo $packages;
		return $this;
	}
}
