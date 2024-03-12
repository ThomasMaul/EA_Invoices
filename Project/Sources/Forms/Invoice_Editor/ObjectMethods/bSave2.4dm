
var $templatename : Text:="conditions"

var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name=:1"; $templatename)

var $template : cs:C1710.Document_TemplatesEntity

If ($templates.length=0)
	$template:=ds:C1482.Document_Templates.new()
	$template.Name:=$templatename
Else 
	$template:=$templates.first()
End if 

$template.WPro:=WPArea2

var $options : Object:=New object:C1471
$options[wk max picture DPI:K81:316]:=300
var $text : Text
WP EXPORT VARIABLE:C1319($template.WPro; $text; wk svg:K81:356; $options)
var $svgRoot : Text:=DOM Parse XML variable:C720($text; False:C215)
var $preview : Picture
SVG EXPORT TO PICTURE:C1017($svgRoot; $preview; Own XML data source:K45:18)
$template.image:=$preview
$template.save()
