<?php



class ManifestsModel extends AbstractModel
{
	public function manifests()
	{
		return $this->recursivelyScanDirectory(
			Settings::sharedSettings()->objectForKey("munki-repo") . "/manifests/"
		);
	}

}
