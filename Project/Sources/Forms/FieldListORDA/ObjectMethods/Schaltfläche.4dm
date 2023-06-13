// get all fields and set them into form.selectedFields

$total:=Count list items:C380(*; "hlist_target")
Form:C1466.selectedFields:=New collection:C1472
For ($i; 1; $total)
	GET LIST ITEM:C378(*; "hlist_target"; $i; $vlItemRef; $vsItemText)
	GET LIST ITEM PARAMETER:C985(*; "hlist_target"; $vlItemRef; "ref"; $para)
	Form:C1466.selectedFields.push($para)
End for 