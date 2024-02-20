//%attributes = {}
// (P) Products_Manage

C_LONGINT:C283(<>ps_Products)
<>ps_Products:=New process:C317("Products_ProcessInit"; 0; "Products_Manage"; *)
BRING TO FRONT:C326(<>ps_Products)