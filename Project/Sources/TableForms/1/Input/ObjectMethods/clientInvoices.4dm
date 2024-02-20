// Object Method [CLIENTS].Input.clientInvoices

Case of 
	: (Form event code:C388=On Selection Change:K2:29)
		UPDATE_DELETE_BUTTON("bDeleteInvoice"; "$highlightedInvoices")
	: (Form event code:C388=On Double Clicked:K2:5)
		COPY SET:C600("$highlightedInvoices"; "$tempSet")
		USE SET:C118("$highlightedInvoices")
		MODIFY RECORD:C57([INVOICES:2]; *)
		RELATE MANY:C262([CLIENTS:1])
		If (Records in selection:C76([INVOICES:2])>0)
			//DISABLE BUTTON(*;"bCancelClient")
			//OBJECT SET VISIBLE(*;"bCancelClient";False)
		End if 
		Invoices_Reorder
		COPY SET:C600("$tempSet"; "$highlightedInvoices")
End case 