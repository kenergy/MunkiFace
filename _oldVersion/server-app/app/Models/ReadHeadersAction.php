<?php
require_once dirname(__FILE__) . "/AbstractModel.php";

class ReadHeadersAction extends AbstractModel
{
	public function readHeaders()
	{
		if ($this->targetIsFile())
		{
			throw new Exception("Class 'ReadHeadersAction' cannot scan a file '"
				. $this->fullPathToTarget() . "'", MFInvalidTargetForActionError);
		}

		return $this->recursivelyScanTarget();
	}
}
