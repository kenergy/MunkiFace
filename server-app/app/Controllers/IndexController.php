<?php


class IndexController extends AbstractController
{
	public function init()
	{
		parent::init();
		$target = $this->HTTPRequest()->sharedRequest()->objectForKey("target");
		switch($this->getAction())
		{
			case self::ACTION_READ:
				$model = ReadAction::alloc()->init();
				$model->setTarget($target);
				echo $model->read();
				break;
		}
		return $this;
	}




	protected function sendErrorToClient($anError)
	{
		$err = array("MFError" => $anError);
		error_log($anError);
		echo json_encode($err);
		exit;
	}
}
