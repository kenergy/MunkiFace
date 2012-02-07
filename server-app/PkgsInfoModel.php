<?php



class PkgsInfoModel extends RTArray
{


	public static function plists()
	{
		$munkiDir
			= Settings::sharedSettings()->objectForKey("munki-repo") .
			"/pkgsinfo/";
		$packages = array();
		
		self::globPlistFromDir($munkiDir, $packages);

		return parent::arrayWithArray($packages);
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
				$plists[] = RTDictionary::dictionaryWithContentsOfFile($path);
			}
		}
	}
}
