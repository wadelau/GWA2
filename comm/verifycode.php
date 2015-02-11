<?php

# verifycode generation
# wadelau@ufqi.com
# Tue Jul 24 18:37:49 CST 2012
# Thu Apr 18 15:18:19 CST 2013
# Thu Sep  5 09:17:54 CST 2013
# Mon Nov  4 09:03:36 CST 2013
# Mon Feb 17 08:40:23 CST 2014
# Thu Feb 20 11:02:01 CST 2014

session_start();

$letters = str_split('23456789ABCDEFGHJKLMNPRSTUVWXYabcdefghijkmnpqrstuvwxy');
$llen = count($letters) - 1;
$charc = 4;
$verifycode = '';
for($i=0; $i<$charc; $i++){
        $verifycode .= $letters[rand(0, $llen)];
        #error_log(__FILE__.":i:$i verifycode:".$verifycode);
}
$_SESSION['verifycode'] = $verifycode;
#error_log(__FILE__.": verifycode:".$verifycode);

$width = 90;
$height = 30;
$im = imagecreatetruecolor($width, $height);
$bg = imagecolorallocate($im, rand(135,255), rand(125,255), rand(115,255));
imagefill($im, rand(10,intval($width/2)), rand(10,intval($height/3)), $bg);
#imagefilledellipse($im, 80, 40, 80, 40, $bg);
#imagecolortransparent($im, $bg);

$codeArr = str_split($verifycode);
        $fontspace = rand(7,10);
$startPos = $startPos2 = rand(10, $width-($charc*$fontspace)) - 10;
$_x = array(1, 0, 1, 0, -1, -1, 1, 0, -1); # up to 8 chars 
$_y = array(0, -1, -1, 0, 0, -1, 1, 1, 1); 
$i = 0;
$bg = imagecolorallocate($im, rand(135,255), rand(125,255), rand(115,255));
imagefilledellipse($im, $startPos*3/2, 28, 80, 30, $bg);
$textcolor = imagecolorallocate($im, rand(50,200), rand(40,200), rand(30, 200));
foreach($codeArr as $k=>$v){
    $y = rand(0,intval($height/2)) + 1;
    $fontsize = rand(3,9);
    $fontspace = rand(6,11);
    imagestring($im, $fontsize, $startPos, $y, $v, $textcolor);
    if($i == rand(0,$charc-1)){
        imagestring($im, $fontsize, $startPos+$_x[$i], $y+$_y[$i], $v, $textcolor);
    }
    else{
        imagestring($im, $fontsize, $startPos, $y, $v, $textcolor);
    }
    #imagestring($im, (rand(2,7)), $startPos+$_x[$i], 1+rand(0,6)+$_y[$i], $v, $textcolor);
    #imagettftext($im, 20, 0, 10, 20, $textcolor, "", $v);
    $startPos += $fontspace;
    $i++;
}

$linecount = 1; # more lines and harder to recognize
for($j=0; $j<$linecount; $j++){
	#imageline($im, rand(1,$startPos2), rand(2, $height),  rand($startPos2, $width), rand(2, $height) , $textcolor);
	imagearc($im, rand(4,$startPos2)+40, rand(10, $height),  rand($startPos2, $width), rand(5, $height), 50, 15 , $textcolor);
	$textcolor = imagecolorallocate($im, rand(10,240), rand(0,240), rand(5, 240));
}
header('Content-Type: image/png');
imagepng($im);
imagedestroy($im);

exit();

?>
