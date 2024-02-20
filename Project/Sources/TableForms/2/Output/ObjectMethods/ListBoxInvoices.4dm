// Object Method [INVOICES].Output.ListBoxInvoices

Case of 
	: (Form event code:C388=On Selection Change:K2:29)
		UPDATE_DELETE_BUTTON("bDeleteInvoices"; "$highlightedInvoices")
		UPDATE_SUBSET_BUTTON("bShowSubsetInvoices"; "$highlightedInvoices"; Current form table:C627)
	: (Form event code:C388=On Double Clicked:K2:5)
		//COPY SET("$highlightedInvoices";"$tempSet")
		//MODIFY RECORD([INVOICES];*)  // Modify the current selected invoice
		//COPY SET("$tempSet";"$highlightedInvoices")
		//Invoices_Reorder 
End case 