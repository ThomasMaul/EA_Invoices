//%attributes = {"invisible":true}
// (P) Products_ProcessInit

C_LONGINT:C283($ref)
SET MENU BAR:C67("Main")
$ref:=Open form window:C675([PRODUCTS:4]; "Output"; Plain form window:K39:10; 120; 140)
SET WINDOW TITLE:C213(Get localized string:C991("PRODUCTS"))
ALL RECORDS:C47([PRODUCTS:4])
DIALOG:C40([PRODUCTS:4]; "Output")
CLOSE WINDOW:C154($ref)