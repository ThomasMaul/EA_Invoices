//%attributes = {}
// (P) Settings_Manage

C_LONGINT:C283(<>ps_Settings)
<>ps_Settings:=New process:C317("Settings_ProcessInit"; 0; "Settings_Manage"; *)
BRING TO FRONT:C326(<>ps_Settings)