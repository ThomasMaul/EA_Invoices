shared singleton Class constructor
	
	// collection of functions to be called via Call Form or similar
	// avoiding to have too many project method
	// in a "real" application, you have one class per form, holding form.xxx attributes and functions for that form
	
Function selectInvoice($invoiceID : Integer)
	If ($invoiceID#0)
		Form:C1466.clickedEntity:=ds:C1482.INVOICES.get($invoiceID)
		Form:C1466.editEntity:=Form:C1466.clickedEntity
		FORM GOTO PAGE:C247(2)
	End if 
	
	