<?php



class PkgsInfoModel extends RTArray
{

	protected $_munkiDir;


	public function plists()
	{
		$this->_munkiDir
			= RTString::stringWithString(
				Settings::sharedSettings()->objectForKey("munki-repo") .
				"/pkgsinfo/"
		);
		$packages = array();
		
		self::globPlistFromDir($this->_munkiDir, $packages);

		//return parent::arrayWithArray($packages);
		return RTDictionary::dictionaryWithPHPArray($packages);
	}




	protected function globPlistFromDir($aDir, &$plists)
	{
		if (!is_dir($aDir))
		{
			echo $aDir . " is not a directory <br />";
			return;
		}

		$contents = RTArray::arrayWithArray(scandir($aDir));
		for($i = 0; $i < $contents->count(); $i++)
		{
			$obj = $contents->objectAtIndex($i);
			$path = RTString::stringWithString($aDir . $obj);
			if ($obj->hasPrefix("."))
			{
				continue;
			}
			if (is_dir($path))
			{
				self::globPlistFromDir($path . "/", $plists);
			}
			else
			{
				$relativeFile = $path->stringByReplacingOccurrencesOfString_withString(
					$this->_munkiDir,
					RTString::string()
				);
				$relativeFile = $relativeFile->description();
				$plists[$relativeFile] = RTDictionary::dictionaryWithContentsOfFile($path);
			}
		}
	}
}
