If (Form:C1466.listselected#Null:C1517)
	$options:=New object:C1471
	$options[wk max picture DPI:K81:316]:=300
	WP EXPORT VARIABLE:C1319(WPArea; $text; wk svg:K81:356; $options)
	$svgRoot:=DOM Parse XML variable:C720($text; False:C215)
	SVG EXPORT TO PICTURE:C1017($svgRoot; $preview; Own XML data source:K45:18)
	//SET PICTURE TO PASTEBOARD($preview)
	
	Form:C1466.listselected.image:=$preview
	Form:C1466.listselected.save()
End if 