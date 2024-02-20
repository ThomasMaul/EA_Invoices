//%attributes = {}
// (P) Invoices_Manage

C_LONGINT:C283(<>ps_Invoices)
<>ps_Invoices:=New process:C317("Invoices_ProcessInit"; 0; "Invoices_Manage"; *)
BRING TO FRONT:C326(<>ps_Invoices)