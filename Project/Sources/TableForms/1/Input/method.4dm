// Form method [CLIENTS]Input
Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		FormSetInterface
		
		If (Length:C16(Get localized string:C991("reorder_label_reverse"))=0)
			infoInvoices:=String:C10(Records in selection:C76([INVOICES:2]))+Get localized string:C991(" invoices out of ")+String:C10(Records in table:C83([INVOICES:2]))
		Else 
			infoInvoices:=String:C10(Records in table:C83([INVOICES:2]))+Get localized string:C991(" invoices out of ")+String:C10(Records in selection:C76([INVOICES:2]))
		End if 
		
		OBJECT SET ENABLED:C1123(*; "bDeleteClient"; (Records in selection:C76([INVOICES:2])=0))
		OBJECT SET ENABLED:C1123(*; "bDeleteInvoice"; False:C215)
		OBJECT SET HELP TIP:C1181([CLIENTS:1]Email:11; [CLIENTS:1]Email:11)
		
		Invoices_Reorder
		
		OBJECT SET FORMAT:C236(*; "@_cur"; Get localized string:C991("currency"))
		LISTBOX_ADJUST_WIDTH("clientInvoices")
		
		//If (Picture size([CLIENTS]Logo)=0)
		//[CLIENTS]Logo:=ToolCreateLogo 
		//End if 
		CustomFields_OnLoadMethod
End case 