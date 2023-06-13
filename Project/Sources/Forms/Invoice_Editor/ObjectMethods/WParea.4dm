WP UpdateWidget("WPtoolbar"; "WParea")

If (FORM Event:C1606.code=On Drop:K2:12)
	If (Form:C1466.drop#Null:C1517)
		$formula:=Formula from string:C1601(Form:C1466.drop.field)
		$pos:=Drop position:C608  // text position
		$range:=WP Selection range:C1340(*; "WParea")  // area, such as header or body
		$range2:=WP Text range:C1341($range; $pos; $pos)  // text postion inside that area
		WP INSERT FORMULA:C1703($range2; $formula; wk replace:K81:177)  // finally insert
	End if 
End if 