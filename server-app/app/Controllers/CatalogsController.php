<?php


class CatalogsController extends RTObject
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
