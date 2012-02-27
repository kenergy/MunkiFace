<?php


class PkgsInfoController extends AbstractController
{
	public function init()
	{
		parent::init();
		$request = HTTPRequest::sharedRequest();
		if ($request->allKeys()->containsObject("action"))
		{
			$action = $request->objectForKey("action");
			switch($action)
			{
				case "read":
					echo PkgsInfoModel::alloc()->init()->contentsOfFileUsingRelativePath(
						$request->objectForKey("file")
					);
					break;
				default:
					// should probably implement some kind of error message that can be
					// sent back to the client here.
			}
		}
		else
		{
			$this->listFiles();
		}
		return $this;
	}




	public function listFiles()
	{
		echo PkgsInfoModel::alloc()->init()->plists();
	}
}
