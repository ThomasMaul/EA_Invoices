Case of 
	: (Form event code:C388=On Getting Focus:K2:7)
		OBJECT SET VISIBLE:C603(*; "productsList"; False:C215)
	: (Form event code:C388=On Data Change:K2:15)
		Invoices_CalculateLineTotals
End case 

