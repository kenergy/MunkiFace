<?php


class PkgsInfoController extends RTObject
{
	public function init()
	{
		parent::init();
		$request = HTTPRequest::sharedRequest();
		$model = PkgsInfoModel::alloc()->init()->plists();
	
		$data = $model->phpArray();

		echo json_encode($data);

		return $this;
	}
}
