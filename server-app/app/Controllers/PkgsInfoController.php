<?php


class PkgsInfoController extends RTObject
{
	public function init()
	{
		parent::init();
		$request = HTTPRequest::sharedRequest();
		$model = PkgsInfoModel::alloc()->init()->plists();
	
		echo json_encode($model->phpArray());

		return $this;
	}
}
