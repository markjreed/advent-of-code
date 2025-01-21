#!/usr/bin/env php
<?php
if ($argc != 2) {
   error_log("Usage: {$argv[0]} input-file");
   exit(1);
}

$part1 = $part2 = 0;
foreach (file($argv[1]) as $line) {
   $line = rtrim($line);
   $code_length = strlen($line);
   eval('$mem_length = strlen(' . $line . ');');
   $part1 += $code_length - $mem_length;
   $encoded_length = strlen(addslashes($line)) + 2;
   $part2 += $encoded_length - $code_length;
}
print("$part1\n$part2\n");
?>
