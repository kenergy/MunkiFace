<?php


class PkgsInfoController extends RTObject
{
	public function init()
	{
		parent::init();
		$model = PkgsInfoModel::plists();
		echo $model;
		return $this;
	}
}
