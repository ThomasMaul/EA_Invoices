//%attributes = {"invisible":true}
// (P) Invoices_GetNumber

C_LONGINT:C283($0)

ALL RECORDS:C47([SETTINGS:5])
[SETTINGS:5]CrtInvoiceNumber:1:=[SETTINGS:5]CrtInvoiceNumber:1+1
$0:=[SETTINGS:5]CrtInvoiceNumber:1
SAVE RECORD:C53([SETTINGS:5])
UNLOAD RECORD:C212([SETTINGS:5])
