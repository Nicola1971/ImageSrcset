<?php
/**
 * ImageSrcset
 *
 * Create responsive image searchset with PHPThumb
 *
 * @author    Nicola Lambathakis http://www.tattoocms.it/
 * @category    snippet
 * @version    1.1
 * @license	 http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @installset base
 * @internal    @modx_category Images
 * @lastupdate  07-11-2024
 */

// [[ImageSrcset? &ImageWxl=`1140` &ImageHxl=`400` &input=`image.jpg` &class=`img-fluid` &alt=`myimage` &title=`myimage` &fetchpriority=`high` &loading=`eager`]]

$DataPrefix = (isset($DataPrefix)) ? $DataPrefix : '0'; // Append data- prefix to src and srcset
// Breakpoint sizes
$Bkpxl = (isset($Bkpxl)) ? $Bkpxl : '1200'; // Extra large (xl): ≥1200px
$Bkplg = (isset($Bkplg)) ? $Bkplg : '992'; // Large (lg) : ≥992px
$Bkpmd = (isset($Bkpmd)) ? $Bkpmd : '768'; // Medium (md): ≥768px
$Bkpsm = (isset($Bkpsm)) ? $Bkpsm : '576'; // Small (sm): ≥576px

// Images sizes for breakpoints
$ImageWxl = (isset($ImageWxl)) ? $ImageWxl : '1140'; // Extra large (xl)
$ImageHxl = (isset($ImageHxl)) ? $ImageHxl : '400'; // Extra large (xl)
$ImageWlg = (isset($ImageWlg)) ? $ImageWlg : '964'; // Large (lg)
$ImageWmd = (isset($ImageWmd)) ? $ImageWmd : '724'; // Medium (md)
$ImageWsm = (isset($ImageWsm)) ? $ImageWsm : '530'; // Small (sm)


// phpthumb parameters
$input = (isset($input)) ? $input : ''; // PhpThumb input image
$options = (isset($options)) ? $options : ''; // PhpThumb options
$ImageQ = (isset($ImageQ)) ? $ImageQ : '80'; // Image quality
$ImageZC = (isset($ImageZC)) ? $ImageZC : 'T'; // Image Zoom crop
$ImageF = (isset($ImageF)) ? $ImageF : 'webp'; // Image Format

//html attributes
$width = (isset($width)) ? $width : $ImageWxl; // Image width (default value from $ImageWxl)
$height = (isset($height)) ? $height : $ImageHxl; // Image Class (default value from $ImageHxl)
$class = (isset($class)) ? $class : ''; // Image Class
$alt = (isset($alt)) ? $alt : ''; // Image alt
$title = (isset($title)) ? $title : ''; // Image title
$fetchpriority = (isset($fetchpriority)) ? $fetchpriority : 'auto'; // fetchpriority attribute high/low/auto
$loading = (isset($loading)) ? $loading : 'eager'; // Loading attribute eager/lazy


$out = '';
$srcset = ''; // Inizializza srcset

// Genera il nuovo src con phpthumb 
$new_src = $modx->runSnippet("phpthumb", array(
    'input' => $input,
    'options' => 'aoe=1,w=' . $ImageWxl . ',h=' . $ImageHxl . ',q=' . $ImageQ . ',zc=' . $ImageZC . ',f=' . $ImageF, 
    'adBlockFix'=>'1'
));

// Imposta l'attributo src o data-src in base a $DataPrefix
if ($DataPrefix == '1') {
    $srcTag = 'data-src';
    $srcsetTag = 'data-srcset';
} else {
    $srcTag = 'src';
    $srcsetTag = 'srcset';
}

// Genera data-srcset o srcset 
$widths = [$ImageWsm, $ImageWmd, $ImageWlg, $ImageWxl];
foreach ($widths as $width) {
    // Calcola la nuova altezza mantenendo le proporzioni
    $height = ($width / $ImageWxl) * $ImageHxl;
    $srcset .= $modx->runSnippet("phpthumb", array(
        'input' => $input,
        'options'=>'aoe=1,w=' . $width . ',h=' . round($height) . ',q='.$ImageQ.',zc='.$ImageZC.',f='.$ImageF.'', 
        'adBlockFix'=>'1'  
    )) . " {$width}w, ";;
}

// Rimuove l'ultima virgola e imposta l'attributo srcset o data-srcset
$srcset = rtrim($srcset, ', ');

// Configura l'attributo sizes o data-sizes in base a $DataPrefix
if ($DataPrefix == '1') {
    $Sizes = 'data-sizes="auto"';
} else {
    // Definisce breakpoints per varie dimensioni dello schermo
    $Sizes = 'sizes="(min-width: ' . $Bkpxl . 'px) ' . $ImageWxl . 'px, (min-width: ' . $Bkplg . 'px) ' . $ImageWlg . 'px, (min-width: ' . $Bkpmd . 'px) ' . $ImageWmd . 'px, (min-width: ' . $Bkpsm . 'px) ' . $ImageWsm . 'px, 100vw"';
}

$out = '<img fetchpriority="' . $fetchpriority . '" width="' . $width . '" height="' . $height . '" alt="' . $alt . '" title="' . $title . '" class="' . $class . '"
    ' . $srcTag . '="' . $new_src . '" 
    ' . $srcsetTag . '="' . $srcset . '" 
    ' . $Sizes . '/>';

return $out;
