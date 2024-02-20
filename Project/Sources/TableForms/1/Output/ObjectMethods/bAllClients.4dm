// [CLIENTS].Output.bAllClients
COPY SET:C600("$highlightedClients"; "$tempoClients")  // Save the current selected clients
ALL RECORDS:C47(Current form table:C627->)
Clients_Reorder  // Sort the current displayed liste of clients
COPY SET:C600("$tempoClients"; "$highlightedClients")
