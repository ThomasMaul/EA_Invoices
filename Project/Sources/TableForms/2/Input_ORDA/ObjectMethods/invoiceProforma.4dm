If (Form:C1466.data.ProForma)
	ALERT:C41(Localized string:C991("You can not change an invoice into a pro forma!"))
	Form:C1466.data.ProForma:=False:C215
Else 
	CONFIRM:C162(Localized string:C991("The pro forma changes into an invoice that will not be modifiable anymore. Continue?"); \
		Localized string:C991("Yes"); \
		Localized string:C991("No"))
	If (Ok=0)
		Form:C1466.data.ProForma:=True:C214
	Else 
		Form:C1466.data.Date:=Current date:C33
		OBJECT SET ENTERABLE:C238(*; "invoiceProformaNumber"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "invoiceDate"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "invoiceDelay"; False:C215)
		Form:C1466.data.InvoiceNumber:="INV"+String:C10(ds:C1482.SETTINGS.getNextInvoiceNumber(); "00000")
		OBJECT SET VISIBLE:C603(*; "inv_LabelPaid"; True:C214)
		OBJECT SET VISIBLE:C603(*; "inv_Paid"; True:C214)
	End if 
End if 