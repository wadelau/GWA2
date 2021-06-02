<?php
/*
 * put text as watermark onto the image
 * xenxin@ufqi.com
 * Fri May 28 10:55:20 CST 2021
 *
 */

if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__.'/inc/webapp.class.php');

class WaterMark extends WebApp{

	//- variables
	private $itype = "";
	private $imgPath = "";
	private $markString = "gMIS";

	//- construct
	function __construct($imgPath=""){
		$this->imgPath = $imgPath;
		//- call parent?
		parent::__construct($args);
	}

	//-
	function addString($markStr=""){
		if($markStr != ""){ $this->markString = $markStr; }		
		$this->itype = $this->_getType($this->imgPath);
		
		if($this->itype == "" || $this->imgPath == ''){
			debug("mod/watermark: unsupported type:".$this->itype." for img:".$this->imgPath);
			return $this->imgPath;	
		}
		else{
			$imgt = $this->itype;
			$imgf = $this->imgPath;
			// Load the stamp and the photo to apply the watermark to
			$img = null;
			if($imgt == 'jpg'){
				$im = imagecreatefromjpeg($imgf);
			}
			else if($imgt == 'png'){
				$im = imagecreatefrompng($imgf);
			}
			else if($imgt == 'gif'){
				$im = imagecreatefromgif($imgf);
			}
			else if($imgt == 'webp'){
				$im = imagecreatefromwebp($imgf);
			}
			else if($imgt == 'bmp'){
				$im = imagecreatefromwbmp($imgf);
			}
			if(!$im){
				debug("mod/watermark: addStr type:".$imgt." for img:".$imgf." failed im:$im");
			}
			else{
				debug("mod/watermark: addStr type:".$imgt." for img:".$imgf." im:$im");
				// First we create our stamp image manually from GD
				$stamp = imagecreatetruecolor(160, 50);
				#imagefilledrectangle($stamp, 0, 0, 99, 69, 0x0000FF);
				#imagefilledrectangle($stamp, 9, 9, 90, 60, 0xFFFFFF);
				
				$black = imagecolorallocate($stamp, 0, 0, 0);
				imagecolortransparent($stamp, $black);
				$col_ellipse = imagecolorallocate($stamp, 90, 90, 90);
				imagefilledellipse($stamp, 80, 25, 160, 50, $col_ellipse);

				imagestring($stamp, 20, 10, 15, $this->markString, 0xFFFFFF);
				#imagestring($stamp, 3, 20, 40, '(c) 2021-99 gMIS', 0x0000FF);
				// Set the margins for the stamp and get the height/width of the stamp image
				$imsx = imagesx($im); $imsy = imagesy($im);
				$marge_right = $imsx / 4;
				$marge_bottom = $imsy / 4;
				$sx = imagesx($stamp);
				$sy = imagesy($stamp);
				// Merge the stamp onto our photo with an opacity of 50%
				if($imsx < ($sx+$marge_right)){
					imagecopymerge($im, $stamp, 0, 0, 0, 0, $sx, $sy, 50);
				}
				else{
					imagecopymerge($im, $stamp, ($imsx - $sx - $marge_right), ($imsy - $sy - $marge_bottom), 0, 0, $sx, $sy, 50);
				}
				// Save the image to file and free memory
				if($imgt == 'jpg'){
					imagejpeg($im, $imgf);
				}
				else if($imgt == 'png'){
					imagepng($im, $imgf);
				}
				else if($imgt == 'gif'){
					imagegif($im, $imgf);
				}
				else if($imgt == 'webp'){
					imagewebp($im, $imgf);
				}
				else if($imgt == 'bmp'){
					imagewbmp($im, $imgf);
				}
				imagedestroy($im);
			}	
		}
		return $this->imgPath;	
	}

	//-
	function _getType(){
		$type = "";
		$tmpFileNameArr = explode(".", strtolower($this->imgPath));
		$tmpFileExt = end($tmpFileNameArr);
		if(strpos($tmpFileExt, 'jpg') !== false){ $type = "jpg"; }
		else if(strpos($tmpFileExt, 'jpeg') !== false){ $type = "jpg"; }
		else if(strpos($tmpFileExt, 'gif') !== false){ $type = "gif"; }
		else if(strpos($tmpFileExt, 'bmp') !== false){ $type = "bmp"; }
		else if(strpos($tmpFileExt, 'webp') !== false){ $type = "webp"; }
		else if(strpos($tmpFileExt, 'png') !== false){ $type = "png"; }
		else{ $type = ""; }
		debug("mod/watermark: getType type:".$type." for img:".$this->imgPath." ext:$tmpFileExt");

		return $type;
	}

}

?>
