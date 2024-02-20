Case of 
	: (Form event code:C388=On Load:K2:1)
		vBarCode:="*"+[INVOICES:2]InvoiceNumber:2+"*"
		vDueDate:=[INVOICES:2]Date:4+[INVOICES:2]PaymentDelay:13
End case 
