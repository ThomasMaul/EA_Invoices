//%attributes = {}
// (P) Clients_Manage

C_LONGINT:C283(<>ps_Clients)
<>ps_Clients:=New process:C317("Clients_ProcessInit"; 0; "Clients_Manage"; *)
BRING TO FRONT:C326(<>ps_Clients)