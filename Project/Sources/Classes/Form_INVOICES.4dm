property data : cs:C1710.INVOICESEntity
property Position : Integer

Function loadEvent()
	
	
	
	If (Form:C1466.data.ProForma)
		OBJECT SET VISIBLE:C603(*; "inv_Payement@"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "invoiceNumber"; True:C214)
		OBJECT SET ENTERABLE:C238(*; "invoiceDate"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "invoiceDelay"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "invoiceProformaNumber"; False:C215)
		OBJECT SET VISIBLE:C603(*; "inv_Payement@"; Bool:C1537(Form:C1466.data.Paid))
	End if 
	
	OBJECT SET FORMAT:C236(*; "@_cur"; Localized string:C991("currency"))
	
	//Function doDoubleClick()
	//alert("Just as test: "+this.data.CustomerName)
	
	
	