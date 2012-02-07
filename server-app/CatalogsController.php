<?php


class CatalogsController extends RTObject
{
	public function init()
	{
		parent::init();
		$model = CatalogsModel::catalogs();
		echo $model;
		return $this;
	}
}
