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
				echo $model->read()->asJSON();
				break;
			case self::ACTION_READ_HEADERS:
				$model = ReadHeadersAction::alloc()->init();
				$model->setTarget($target);
				echo $model->readHeaders()->asJSON();
				break;
			case self::ACTION_SET:
				$model = SetAction::alloc()->init();
				$model->setTarget($target);
				echo json_encode($model->set());
				break;
			default:
				throw new Exception("Unknown action '" . $this->getAction() . "'",
					MFUnknownActionError
				);
		}
		return $this;
	}
}
