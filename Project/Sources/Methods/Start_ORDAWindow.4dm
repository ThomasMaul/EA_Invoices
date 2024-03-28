//%attributes = {}
If (Is Windows:C1573)
	HIDE MENU BAR:C432
End if 
SET MENU BAR:C67("empty")
var $win : Integer:=Open form window:C675("ORDAListbox")
DIALOG:C40("ORDAListbox")
CLOSE WINDOW:C154($win)