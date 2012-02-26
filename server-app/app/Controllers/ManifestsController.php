<?php


class ManifestsController extends RTObject
{

	public function init()
	{
		parent::init();
		$manifests = ManifestsModel::alloc()->init()->manifests();

		echo $manifests;
		
		return $this;
	}
}
