<?php



class CatalogsModel extends RTObject
{

	protected $_data;


	public function init()
	{
		parent::init();
		$munkiDir
			= Settings::sharedSettings()->objectForKey("munki-repo") .
			"/catalogs/";
		$catalogs = array();
		
		self::globCatalogsFromDir($munkiDir, $catalogs);

		$this->_data = RTDictionary::dictionaryWithPHPArray($catalogs);
		if ($this->_data == null)
		{
			$this->_data = RTArray::arrayWithArray($catalogs);
		}
		return $this;
	}
	
	
	
	
	public static function catalogs()
	{
		return self::alloc()->init();
	}




	protected function globCatalogsFromDir($aDir, &$catalogs)
	{
		if (!is_dir($aDir))
		{
			echo "'" . $aDir . "' is not a directory";
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
				self::globCatalogsFromDir($path . "/", $catalogs);
			}
			else
			{
				$tmp = RTDictionary::dictionaryWithContentsOfFile($path);
				if ($tmp == null)
				{
					$plist = new CFPropertyList($path);
					$tmp = RTArray::arrayWithArray($plist->toArray());
				}

				if ($tmp != null)
				{
					$catalogs[$obj->description()] = $tmp->phpArray();
				}
			}
		}
	}




	public function description()
	{
		if ($this->_data == null)
		{
			return null;
		}
		return $this->_data->description();
	}
}
