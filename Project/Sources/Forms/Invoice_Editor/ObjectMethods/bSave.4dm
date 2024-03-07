
$templatename:="Invoice"

var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name=:1"; $templatename)

var $template : cs:C1710.Document_TemplatesEntity

If ($templates.length=0)
	$template:=ds:C1482.Document_Templates.new()
	$template.Name:=$templatename
Else 
	$template:=$templates.first()
End if 

$template.WPro:=WPArea
$template.save()
