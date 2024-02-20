// [CLIENTS].Output.bShowSubsetClients

COPY SET:C600("$highlightedClients"; "$tempoClients")  // Save the current selected clients
USE SET:C118("$highlightedClients")
Clients_Reorder  // Sort the current displayed liste of clients
COPY SET:C600("$tempoClients"; "$highlightedClients")
