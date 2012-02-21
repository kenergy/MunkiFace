<?php


class CatalogsController extends RTObject
{
	protected static $_catalogs;


	public function init()
	{
		parent::init();
		$model = PkgsInfoModel::alloc()->init()->plists();

		self::$_catalogs = RTMutableArray::anArray();

		foreach($model as $plist)
		{
			$catalogs = $plist["catalogs"];
			foreach($catalogs as $catalog)
			{
				if (!self::$_catalogs->containsObject($catalog))
				{
					self::$_catalogs->addObject($catalog);
				}
			}
		}

		echo json_encode(self::$_catalogs->phpArray());

		return $this;
	}
}
