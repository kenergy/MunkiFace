<?php



class PkgsModel extends AbstractModel
{
	public function packages()
	{
		return $this->recursivelyScanDirectory_relativePaths(
			$this->munkiDir() . "/pkgs/",
			YES
		);
	}

}
