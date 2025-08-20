If (FORM Event:C1606.code=On Double Clicked:K2:5)
	var $formdata:=cs:C1710.Form_Input_Main.new()
	$formdata.tablename:=Form:C1466.Selected.getDataClass().getInfo().name
	$formdata.SelectedElement:=Form:C1466.Selected
	var $win:=Open form window:C675("Input_Main")
	DIALOG:C40("Input_Main"; $formdata; *)
End if 