// [CLIENTS].Output.bExportClients

C_TEXT:C284($filename)
CREATE SET:C116(Current form table:C627->; "$tempoClients")
COPY SET:C600("$highlightedClients"; "$tempSet")  //Save the current highlighted clients
If (Records in set:C195("$highlightedClients")>0)
	CONFIRM:C162("Do you want to export all the clients in list or only the highlighted ones?"; "Highlighted only"; "All clients in list")
	If (Ok=1)
		USE SET:C118("$highlightedClients")
	End if 
End if 
FORM SET OUTPUT:C54(Current form table:C627->; "OutputExport")
$filename:="ExportClients_"+String:C10(Year of:C25(Current date:C33))+"-"+String:C10(Month of:C24(Current date:C33))+"-"+String:C10(Day of:C23(Current date:C33))+"_"+Replace string:C233(String:C10(Current time:C178); ":"; "")+".txt"
EXPORT TEXT:C167(Current form table:C627->; $filename)
SHOW ON DISK:C922($filename)
COPY SET:C600("$tempSet"; "$highlightedClients")  //Restore the current highlighted clients
USE SET:C118("$tempoClients")
Clients_Reorder  // Sort the current displayed liste of clients
