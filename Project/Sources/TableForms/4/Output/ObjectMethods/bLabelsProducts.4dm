// [PRODUCTS].Output.bLabelsProducts

CREATE SET:C116(Current form table:C627->; "$tempoProducts")
If (Records in set:C195("$highlightedProducts")>0)
	CONFIRM:C162("Do you want to print all the products in list or only the highlighted ones?"; "Highlighted only"; "All products in list")
	If (Ok=1)
		COPY SET:C600("$highlightedProducts"; "$tempSet")  //Save the current highlighted products
		USE SET:C118("$highlightedProducts")
	End if 
End if 

PRINT LABEL:C39(Current form table:C627->; Char:C90(1))

COPY SET:C600("$tempSet"; "$highlightedProducts")  //Restore the current highlighted products
USE SET:C118("$tempoProducts")
Products_Reorder
