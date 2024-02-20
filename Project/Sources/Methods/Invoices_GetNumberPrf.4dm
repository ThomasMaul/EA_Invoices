//%attributes = {"invisible":true}
// (P) Invoices_GetNumberPrf

C_LONGINT:C283($0)

ALL RECORDS:C47([SETTINGS:5])
[SETTINGS:5]CrtProformaNumber:2:=[SETTINGS:5]CrtProformaNumber:2+1
$0:=[SETTINGS:5]CrtProformaNumber:2
SAVE RECORD:C53([SETTINGS:5])
UNLOAD RECORD:C212([SETTINGS:5])