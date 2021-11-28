<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta id="viewport" name="viewport" content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
        <title>LA ROCA SOFTWARE SA IPHONE KIT</title>
        <link rel="stylesheet" href="stylesheets/iphone.css" />
        <link rel="apple-touch-icon" href="images/apple-touch-icon.png" />
        <!-- for profile image -->
        <style type="text/css" media="screen">
                li.picture { background: #fff url(images/minid-profile.png) no-repeat !important; }
        </style>
        <!-- end line customization -->
</head>
<body>
<?php
$aleatorio=rand();
settype ($aleatorio,"string");
$aleatorio=rand();
settype ($aleatorio,"string");
$cadena = "test.p";

//$file = "sh ./corres.sh $cadena";
$file =
"
export TERM=xterm
export DLC=/var/lib/minishift/openshift.local.pv/pv0080/dlc102b
export PATH=%DLC:$DLC/bin:$DLC/oebpm/server/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/dlc/dba/procomdb
/var/lib/minishift/openshift.local.pv/pv0080/dlc102b/bin/_progres -b -p test.p
";
$programa = $cadena;
echo $file."<br>";

exec($file, $output);

//$output[0]                    = "";
//$output[1]                    = "";

foreach($output as $outputline){
    echo("$outputline");
}
?>

</BODY>
</HTML>
