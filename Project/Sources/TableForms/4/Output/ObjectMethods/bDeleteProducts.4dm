// (*) [PRODUCTS].Output.bDeleteProducts

C_LONGINT:C283($i; $highlightedProduct)

$highlightedProduct:=Records in set:C195("$highlightedProducts")
If ($highlightedProduct>0)
	CONFIRM:C162("Do you really want to delete "+String:C10($highlightedProduct)+" products(s)?"; "Yes"; "No")
	If (Ok=1)
		CONFIRM:C162("Only the products(s) not referenced in invoices will be deleted. Continue?"; "Yes"; "No")
		If (Ok=1)
			CREATE SET:C116([PRODUCTS:4]; "$tempoProducts")  // Save the current set of products
			USE SET:C118("$highlightedProducts")
			FIRST RECORD:C50([PRODUCTS:4])
			For ($i; 1; Records in selection:C76([PRODUCTS:4]))
				RELATE MANY:C262([PRODUCTS:4])
				If (Records in selection:C76([INVOICE_LINES:3])=0)
					DELETE RECORD:C58([PRODUCTS:4])  // Delete the selected product
				End if 
				NEXT RECORD:C51([PRODUCTS:4])
			End for 
			USE SET:C118("$tempoProducts")
			Products_Reorder  // Sort the current displayed liste of products
		End if 
	End if 
Else 
	ALERT:C41(Get localized string:C991("No product(s) selected"))
End if 

