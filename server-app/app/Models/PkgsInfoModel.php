<?php


/**
	Gathers information about the packages stored in the munki repo and makes
	that data accessible.
	This class does not yet provide the ability to write data back to those
	files.
 */
class PkgsInfoModel extends AbstractModel
{

	protected static $packages;


	public function plists()
	{
		if (self::$packages != null)
		{
			return self::$packages;
		}

		return $this->recursivelyScanDirectory(
			Settings::sharedSettings()->objectForKey("munki-repo") . "/pkgsinfo/"
		);
	}
}
