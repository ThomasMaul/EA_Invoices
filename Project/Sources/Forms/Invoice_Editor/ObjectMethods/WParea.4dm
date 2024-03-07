WP UpdateWidget("WPtoolbar"; "WParea")

If (FORM Event:C1606.code=On Drop:K2:12)
	If (Form:C1466.drop#Null:C1517)
		var $formula : 4D:C1709.Function:=Formula from string:C1601(Form:C1466.drop.field)
		var $pos : Integer:=Drop position:C608  // text position
		var $range : Object:=WP Selection range:C1340(*; "WParea")  // area, such as header or body
		var $range2 : Object:=WP Text range:C1341($range; $pos; $pos)  // text postion inside that area
		WP INSERT FORMULA:C1703($range2; $formula; wk replace:K81:177)  // finally insert
	End if 
End if 