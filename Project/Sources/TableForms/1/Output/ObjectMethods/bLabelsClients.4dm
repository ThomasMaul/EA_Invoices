// [CLIENTS].Output.bLabelsClients

CREATE SET:C116(Current form table:C627->; "$tempoClients")
If (Records in set:C195("$highlightedClients")>0)
	CONFIRM:C162("Do you want to print all the clients in list or only the highlighted ones?"; "Highlighted only"; "All clients in list")
	If (Ok=1)
		USE SET:C118("$highlightedClients")
	End if 
End if 

PRINT LABEL:C39(Current form table:C627->; Char:C90(1))

USE SET:C118("$tempoClients")
Clients_Reorder  // Sort the current displayed liste of clients
