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




	public function init()
	{
		parent::init();
		$this->buildFullPathToModelRepo("pkgsinfo");
		return $this;
	}




	public function contentsOfFileUsingRelativePath($aPath)
	{
		$path = RTString::stringWithString($this->fullPathToModelRepo() . $aPath);
		$dict = RTDictionary::dictionaryWithContentsOfFile($path);
		return $dict;
	}


	public function plists()
	{
		if (self::$packages != null)
		{
			return self::$packages;
		}

		return $this->recursivelyScanDirectory($this->munkiDir() . "/pkgsinfo/");
	}
}
