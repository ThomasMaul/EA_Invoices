property data : cs:C1710.INVOICESEntity
property Position : Integer
property curLine : cs:C1710.INVOICE_LINESEntity
property itemList : cs:C1710.INVOICE_LINESSelection  //copy of the relation to allow to add lines

Function loadEvent()
	This:C1470.itemList:=This:C1470.data.invoice_lines
	
	
	If (This:C1470.data.ProForma)
		OBJECT SET VISIBLE:C603(*; "inv_Payement@"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "invoiceNumber"; True:C214)
		OBJECT SET ENTERABLE:C238(*; "invoiceDate"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "invoiceDelay"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "invoiceProformaNumber"; False:C215)
		OBJECT SET VISIBLE:C603(*; "inv_Payement@"; Bool:C1537(This:C1470.data.Paid))
	End if 
	
	OBJECT SET FORMAT:C236(*; "@_cur"; Localized string:C991("currency"))
	
	// invoice table shows invoice item table, so we need a transaction to cancel modifications
	ds:C1482.startTransaction()
	
	
	
	
	// just as example: this will automatic overwrite default behavior, just remove comments
	//Function doDoubleClick()
	//alert("Just as test: "+this.data.CustomerName)
	
	
	