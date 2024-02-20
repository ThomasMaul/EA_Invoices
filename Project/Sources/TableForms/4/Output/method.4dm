// Form Method: [PRODUCTS]Output

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		FormSetInterface
		
		OBJECT SET ENABLED:C1123(*; "bShowSubsetProducts"; False:C215)
		OBJECT SET ENABLED:C1123(*; "bDeleteProducts"; False:C215)
		Products_Reorder
		LISTBOX_ADJUST_WIDTH("ListBoxProducts")
		
End case 