//%attributes = {"invisible":true}
// (P) Clients_ProcessInit

C_LONGINT:C283($ref)
SET MENU BAR:C67("Main")
$ref:=Open form window:C675([CLIENTS:1]; "Output"; Plain form window:K39:10; 120; 140)
SET WINDOW TITLE:C213(Get localized string:C991("CLIENTS"))
ALL RECORDS:C47([CLIENTS:1])
DIALOG:C40([CLIENTS:1]; "Output")
CLOSE WINDOW:C154($ref)