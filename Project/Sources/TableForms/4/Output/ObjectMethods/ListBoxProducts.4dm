// Object Method: [PRODUCTS].Output.ListBoxProducts

Case of 
	: (Form event code:C388=On Selection Change:K2:29)
		UPDATE_DELETE_BUTTON("bDeleteProducts"; "$highlightedProducts")
		UPDATE_SUBSET_BUTTON("bShowSubsetProducts"; "$highlightedProducts"; Current form table:C627)
		//: (Form event=On Double Clicked)
		//If (Records in set("$highlightedProducts")>0)
		//COPY SET("$highlightedProducts";"$tempSet")
		//MODIFY RECORD([PRODUCTS];*)  // Modify the current selected product
		//COPY SET("$tempSet";"$highlightedProducts")
		//Products_Reorder 
		//End if 
End case 