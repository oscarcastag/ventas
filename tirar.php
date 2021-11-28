<?php
$file = "./tirar.sh";

exec ($file, $output);

foreach($output as $outputline) {
    echo $outputline;
}


 







?>
