//%attributes = {"invisible":true}
C_TEXT:C284($1; $companyName)
C_PICTURE:C286($0)
C_TEXT:C284($logoRef)
C_TEXT:C284($rect)
C_LONGINT:C283($margin)
C_TEXT:C284($foregroundColor; $backgroundColor)
C_TEXT:C284($text)

$companyName:=$1
$companyName:=Substring:C12($companyName; 1; 4)

ARRAY TEXT:C222($_fonts; 5)
$_fonts{1}:="Comic Sans MS"
$_fonts{2}:="Palatino"
$_fonts{3}:="Tahoma"
$_fonts{4}:="Times New Roman"
$_fonts{5}:="Verdana"

ARRAY TEXT:C222($_foregroundColor; 3)
$_foregroundColor{1}:="rgb(200,20,10)"
$_foregroundColor{2}:="rgb(10,120,10)"
$_foregroundColor{3}:="rgb(20,10,200)"

$logoRef:=SVG_New(150; 150)

$foregroundColor:="rgb("+String:C10(200+(Random:C100%30))+","+String:C10(200+(Random:C100%30))+","+String:C10(200+(Random:C100%30))+")"
$backgroundColor:=$foregroundColor
$rect:=SVG_New_rect($logoRef; 0; 0; 150; 150; 0; 0; $foregroundColor; $backgroundColor; 0)

$foregroundColor:=$_foregroundColor{Random:C100%3+1}
$backgroundColor:="rgb("+String:C10(220+(Random:C100%30))+","+String:C10(220+(Random:C100%30))+","+String:C10(220+(Random:C100%30))+")"

$margin:=10+(Random:C100%20)
$rect:=SVG_New_rect($logoRef; $margin; $margin; (150-(2*$margin)); (150-(2*$margin)); 0; 0; $foregroundColor; $backgroundColor; Random:C100%4+3)

$margin:=40
// parentSVGObject --> $vLogoRef
// text --> $vCompanyName
// x --> $vMargin = 40
// y --> $vMargin = 40
// textWidth --> 150-(2*$vMargin)
// textHeight --> 150
// font --> $_Fonts{1+(Random%3)}
// size --> 30+(Random%10)
// style --> 0 = Plain
// alignement --> 3 = Center
$text:=SVG_New_textArea($logoRef; $companyName; $margin; $margin; 150-(2*$margin); 150; $_fonts{1+(Random:C100%5)}; 20+(Random:C100%5); 0; 3)

$0:=SVG_Export_to_picture($logoRef)