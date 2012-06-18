<?php

$res = mkdir("/Users/Shared/munki_repo/pkgsinfo/This is a test");
echo "\n\n" . ($res == TRUE ? "TRUE" : "FALSE") . "\n";
