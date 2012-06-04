<?php


class MFTargetController extends AbstractController
{
	public function init()
	{
		parent::init();
		$target = $this->HTTPRequest()->sharedRequest()->objectForKey("MFTarget");
		switch($this->getAction())
		{
			case "settings":
				echo Settings::sharedSettings()->asJSON();
				break;
			default:
				throw new Exception("Unknown MFAction '" . $this->getAction() . "'",
					MFUnknownActionError
				);
		}
		return $this;
	}
}
