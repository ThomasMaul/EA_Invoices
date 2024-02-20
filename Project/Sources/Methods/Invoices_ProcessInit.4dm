//%attributes = {"invisible":true}
// (P) Invoices_ProcessInit

C_LONGINT:C283($ref)
SET MENU BAR:C67("Main")
$ref:=Open form window:C675([INVOICES:2]; "Output"; Plain form window:K39:10; 120; 140)
SET WINDOW TITLE:C213(Get localized string:C991("INVOICES"))
ALL RECORDS:C47([INVOICES:2])
DIALOG:C40([INVOICES:2]; "Output")
CLOSE WINDOW:C154($ref)