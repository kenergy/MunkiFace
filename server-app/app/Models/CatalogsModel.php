<?php



class CatalogsModel extends AbstractModel
{
	private $_catalogsDir;


	public function catalogs()
	{
		$this->_catalogsDir = $this->munkiDir() . "/catalogs/";
		return $this->recursivelyScanDirectory($this->_catalogsDir);
	}




	public function catalogsDirectory()
	{
		return $this->_manifestDir;
	}
}
