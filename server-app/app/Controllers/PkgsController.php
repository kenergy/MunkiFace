<?php



class PkgsController extends RTObject
{
	public function init()
	{
		parent::init();
		$model = PkgsModel::packages();
		echo $model;
		return $this;
	}
}
