<?php


class CatalogsController extends AbstractController
{
	protected static $_catalogs;


	public function init()
	{
		parent::init();
		$model = CatalogsModel::alloc()->init()->catalogs();

		echo $model;
		return $this;
	}
}
