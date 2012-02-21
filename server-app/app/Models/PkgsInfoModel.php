<?php


/**
	Gathers information about the packages stored in the munki repo and makes
	that data accessible.
	This class does not yet provide the ability to write data back to those
	files.
 */
class PkgsInfoModel extends RTArray
{

	protected $_munkiDir;
	protected static $packages;


	public function plists()
	{
		if (self::$packages != null)
		{
			return self::$packages;
		}
		$this->_munkiDir
			= RTString::stringWithString(
				Settings::sharedSettings()->objectForKey("munki-repo") .
				"/pkgsinfo/"
		);
		self::$packages = RTMutableDictionary::dictionary();
		
		self::globPlistFromDir($this->_munkiDir, self::$packages);

		return self::$packages;
	}




	protected function globPlistFromDir($aDir, &$plists)
	{
		if (!is_dir($aDir))
		{
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
				$plist = new CFPropertyList($path);
				$plists->setObject_forKey($plist->toArray(), $relativeFile);
			}
		}
	}
}
