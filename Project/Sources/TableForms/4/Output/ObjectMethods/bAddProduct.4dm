// (*) [PRODUCTS].Output.bAddProduct
CREATE SET:C116(Current form table:C627->; "$tempoProducts")  //Save the current displayed liste of products
COPY SET:C600("$highlightedProducts"; "$tempSet")  //Save the current highlighted products

FORM SET INPUT:C55(Current form table:C627->; "Input")  // Set the Input form

ADD RECORD:C56(Current form table:C627->; *)
If (OK=1)  // A new product was added
	ADD TO SET:C119(Current form table:C627->; "$tempoProducts")  // Add this product to the current displayed liste of products
	COPY SET:C600("$tempSet"; "$highlightedProducts")  //Restore the current highlighted products
	If (Records in set:C195("$highlightedProducts")=0)
		ADD TO SET:C119(Current form table:C627->; "$highlightedProducts")  // Highlite the recent added product
	End if 
	USE SET:C118("$tempoProducts")  //Restore the current displayed liste of products
	Products_Reorder  // Sort the current displayed liste of products
End if 

