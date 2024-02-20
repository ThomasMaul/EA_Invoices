//%attributes = {"invisible":true}
// (P) OnStartup
C_BOOLEAN:C305(<>runningOnMac; <>runningOnWin)

C_LONGINT:C283($platform)

_O_PLATFORM PROPERTIES:C365($platform)
If ($platform=Mac OS:K25:2)
	<>runningOnMac:=True:C214
End if 
<>runningOnWin:=Not:C34(<>runningOnMac)


If (Records in table:C83([CLIENTS:1])=0)  // Test if the database is empty
	//CONFIRM("Your database is empty."+Char(Carriage return)+"Do you want to import some sample data?";"Yes, please!";"No, thanks")
	//If (Ok=1)
	FillData
	//End if 
End if 

Clients_Manage