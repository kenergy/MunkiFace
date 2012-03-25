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
			case self::ACTION_READ_HEADERS:
				$model = ReadHeadersAction::alloc()->init();
				$model->setTarget($target);
				echo $model->readHeaders();
				break;
			default:
				throw new Exception("Unknown action '" . $this->getAction() . "'",
					MFUnknownActionError
				);
		}
		return $this;
	}
}
