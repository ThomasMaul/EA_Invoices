If ([INVOICES:2]ProForma:12)
	ALERT:C41(Get localized string:C991("You can not change an invoice into a pro forma!"))
	[INVOICES:2]ProForma:12:=False:C215
Else 
	CONFIRM:C162(Get localized string:C991("The pro forma changes into an invoice that will not be modifiable anymore. Continue?"); \
		Get localized string:C991("Yes"); \
		Get localized string:C991("No"))
	If (Ok=0)
		[INVOICES:2]ProForma:12:=True:C214
	Else 
		[INVOICES:2]Date:4:=Current date:C33
		OBJECT SET ENTERABLE:C238([INVOICES:2]ProformaNumber:14; False:C215)
		OBJECT SET ENTERABLE:C238([INVOICES:2]Date:4; False:C215)
		OBJECT SET ENTERABLE:C238([INVOICES:2]PaymentDelay:13; False:C215)
		[INVOICES:2]InvoiceNumber:2:="INV"+String:C10(Invoices_GetNumber; "00000")
		OBJECT SET VISIBLE:C603(*; "inv_LabelPaid"; True:C214)
		OBJECT SET VISIBLE:C603(*; "inv_Paid"; True:C214)
		_O_DISABLE BUTTON:C193(*; "bDeleteInvoice")
		_O_DISABLE BUTTON:C193(*; "bAddInvoiceLine")
		_O_DISABLE BUTTON:C193(*; "bDeleteInvoiceLine")
		_O_DISABLE BUTTON:C193(*; "bCancelInvoice")
		//OBJECT SET VISIBLE(*;"bDeleteInvoice";False)
		//OBJECT SET VISIBLE(*;"bAddInvoiceLine";False)
		//OBJECT SET VISIBLE(*;"bDeleteInvoiceLine";False)
		//OBJECT SET VISIBLE(*;"bCancelInvoice";False)
	End if 
End if 