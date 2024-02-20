// (*) Object method [CLIENTS].Input.bAddInvoice

SAVE RECORD:C53([CLIENTS:1])
ADD RECORD:C56([INVOICES:2]; *)
If (Ok=1)
	RELATE MANY:C262([CLIENTS:1])
	If (Records in selection:C76([INVOICES:2])>0)
		_O_DISABLE BUTTON:C193(*; "bCancelClient")
		//OBJECT SET VISIBLE(*;"bCancelClient";False)
	End if 
	Invoices_Reorder
End if 

