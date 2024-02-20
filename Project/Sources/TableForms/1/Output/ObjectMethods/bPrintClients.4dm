// [CLIENTS].Output.bPrintClients

CREATE SET:C116(Current form table:C627->; "$tempoClients")
COPY SET:C600("$highlightedClients"; "$tempSet")  //Save the current highlighted clients
If (Records in set:C195("$highlightedClients")>0)
	CONFIRM:C162("Do you want to print all the clients in list or only the highlighted ones?"; "Highlighted only"; "All clients in list")
	If (Ok=1)
		USE SET:C118("$highlightedClients")
	End if 
End if 
FORM SET OUTPUT:C54(Current form table:C627->; "OutputPrint")
PRINT SELECTION:C60(Current form table:C627->)

COPY SET:C600("$tempSet"; "$highlightedClients")  //Restore the current highlighted clients
USE SET:C118("$tempoClients")
Clients_Reorder  // Sort the current displayed liste of clients
