// Object method [CLIENTS].Output.ListBoxClients

Case of 
	: (Form event code:C388=On Selection Change:K2:29)
		UPDATE_DELETE_BUTTON("bDeleteClients"; "$highlightedClients")
		UPDATE_SUBSET_BUTTON("bShowSubsetClients"; "$highlightedClients"; Current form table:C627)
		//: (Form event=On Double Clicked)
		//COPY SET("$highlightedClients";"$tempSet")
		//MODIFY RECORD([CLIENTS];*)  // Modify the current selected client
		//COPY SET("$tempSet";"$highlightedClients")
		//Clients_Reorder   // Sort the current displayed liste of clients
End case 