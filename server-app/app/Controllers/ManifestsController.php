<?php


class ManifestsController extends AbstractController
{

	public function init()
	{
		parent::init();
		$manifests = ManifestsModel::alloc()->init()->manifests();

		echo $manifests;
		
		return $this;
	}
}
