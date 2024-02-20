// [PRODUCTS].Output.bPrintProducts

CREATE SET:C116(Current form table:C627->; "$tempoProducts")
COPY SET:C600("$highlightedProducts"; "$tempSet")  //Save the current highlighted products
If (Records in set:C195("$highlightedProducts")>0)
	CONFIRM:C162("Do you want to print all the products in list or only the highlighted ones?"; "Highlighted only"; "All products in list")
	If (Ok=1)
		USE SET:C118("$highlightedProducts")
	End if 
End if 
FORM SET OUTPUT:C54(Current form table:C627->; "OutputPrint")
PRINT SELECTION:C60(Current form table:C627->)

COPY SET:C600("$tempSet"; "$highlightedProducts")  //Restore the current highlighted products
USE SET:C118("$tempoProducts")
Products_Reorder
