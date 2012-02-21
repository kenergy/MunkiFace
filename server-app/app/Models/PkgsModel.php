<?php



class PkgsModel extends RTArray
{


	public static function packages()
	{
		$munkiDir
			= Settings::sharedSettings()->objectForKey("munki-repo") . "/pkgs/";
		$contents = RTArray::arrayWithArray(scandir($munkiDir));
		$packages = array();
		
		for($i = 0; $i < $contents->count(); $i++)
		{
			$obj = $contents->objectAtIndex($i);
			if ($obj->hasPrefix("."))
			{
				continue;
			}
			$packages[] = $munkiDir . $obj;
		}
		return parent::arrayWithArray($packages);
	}

}
