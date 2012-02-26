<?php



class PkgsModel extends AbstractModel
{
	public function packages()
	{
		return $this->recursivelyScanDirectory(
			$this->munkiDir() . "/pkgs/");
	}

}
