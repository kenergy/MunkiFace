<?php


class PkgsInfoController extends RTObject
{
	public function init()
	{
		parent::init();
		$model = PkgsInfoModel::alloc()->init()->plists();
		echo json_encode($model);
		return $this;
	}
}
