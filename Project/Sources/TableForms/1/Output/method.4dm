// Form Method: [CLIENTS]Output
Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		FormSetInterface
		
		OBJECT SET ENABLED:C1123(*; "bShowSubsetClients"; False:C215)
		OBJECT SET ENABLED:C1123(*; "bDeleteClients"; False:C215)
		invoicesSubtotalLabel:=Get localized string:C991("Total Sales")
		Clients_Reorder
		LISTBOX_ADJUST_WIDTH("ListBoxClients")
		
End case 