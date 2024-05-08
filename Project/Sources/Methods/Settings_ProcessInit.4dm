//%attributes = {"invisible":true}
// (P) Settings_ProcessInit

C_LONGINT:C283($ref)
//SET MENU BAR("Main")
If (Is Windows:C1573)
	HIDE MENU BAR:C432
End if 
SET MENU BAR:C67("empty")
$ref:=Open form window:C675([SETTINGS:5]; "Input"; Plain form window:K39:10; 120; 140)
SET WINDOW TITLE:C213(Get localized string:C991("SETTINGS"))
ALL RECORDS:C47([SETTINGS:5])
MODIFY RECORD:C57([SETTINGS:5]; *)
CLOSE WINDOW:C154($ref)
UNLOAD RECORD:C212([SETTINGS:5])
