<?php



class PkgsModel extends AbstractModel
{
	public function packages()
	{
		return $this->recursivelyScanDirectory(
			Settings::sharedSettings()->objectForKey("munki-repo") . "/pkgs/"
		);
	}

}
