#!/usr/bin/env php
<?php
if ($argc != 2) {
   error_log("Usage: {$argv[0]} input-file");
   exit(1);
}

$total = 0;
foreach (file($argv[1]) as $line) {
   $code_length = strlen($line) - 1;
   eval('$mem_length = strlen(' . $line . ');');
   $total += $code_length - $mem_length;
}
print("$total\n");
?>
