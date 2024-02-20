// Object Method [INVOICE_LINES]Input.productChoice
C_TEXT:C284($text)

Case of 
	: (Form event code:C388=On Getting Focus:K2:7)
		productChoice:=[INVOICE_LINES:3]ProductReference:4
		If (productChoice#"")
			QUERY:C277([PRODUCTS:4]; [PRODUCTS:4]Reference:2="@"+productChoice+"@"; *)
			QUERY:C277([PRODUCTS:4];  | ; [PRODUCTS:4]Name:3="@"+productChoice+"@")
			ORDER BY:C49([PRODUCTS:4]; [PRODUCTS:4]Reference:2; >)
		Else 
			ALL RECORDS:C47([PRODUCTS:4])
		End if 
		infoProducts:=String:C10(Records in selection:C76([PRODUCTS:4]))+" products out of "+String:C10(Records in table:C83([PRODUCTS:4]))
		ORDER BY:C49([PRODUCTS:4]; [PRODUCTS:4]Reference:2; >)
		//OBJET FIXER VISIBLE(*;"productsList";Lire texte edite#"")
		OBJECT SET VISIBLE:C603(*; "productsList"; True:C214)
		
		
	: (Form event code:C388=On After Keystroke:K2:26)
		$text:=Get edited text:C655
		QUERY:C277([PRODUCTS:4]; [PRODUCTS:4]Reference:2="@"+$text+"@"; *)
		QUERY:C277([PRODUCTS:4];  | ; [PRODUCTS:4]Name:3="@"+$text+"@")
		ORDER BY:C49([PRODUCTS:4]; [PRODUCTS:4]Reference:2; >)
		infoProducts:=String:C10(Records in selection:C76([PRODUCTS:4]))+" products out of "+String:C10(Records in table:C83([PRODUCTS:4]))
		OBJECT SET VISIBLE:C603(*; "productsList"; True:C214)
		
	: (Form event code:C388=On Losing Focus:K2:8)
		If (Records in selection:C76([PRODUCTS:4])=1)
			productChoice:=[PRODUCTS:4]Reference:2
			[INVOICE_LINES:3]Product_ID:3:=[PRODUCTS:4]ID:1
			[INVOICE_LINES:3]ProductReference:4:=[PRODUCTS:4]Reference:2
			[INVOICE_LINES:3]ProductName:5:=[PRODUCTS:4]Name:3
			[INVOICE_LINES:3]ProductUnitPrice:7:=[PRODUCTS:4]UnitPrice:5
			[INVOICE_LINES:3]ProductTaxRate:9:=[PRODUCTS:4]TaxRate:6
		Else 
			productChoice:=""
			[INVOICE_LINES:3]Product_ID:3:=0
			[INVOICE_LINES:3]ProductReference:4:=""
			[INVOICE_LINES:3]ProductName:5:=""
			[INVOICE_LINES:3]ProductUnitPrice:7:=0
			[INVOICE_LINES:3]ProductTaxRate:9:=0
		End if 
		Invoices_CalculateLineTotals
End case 
