//%attributes = {"invisible":true}
// (P) Products_Reorder
ORDER BY:C49([PRODUCTS:4]; [PRODUCTS:4]Reference:2; >)

If (Length:C16(Get localized string:C991("reorder_label_reverse"))=0)
	infoProducts:=String:C10(Records in selection:C76([PRODUCTS:4]))+Get localized string:C991(" products out of ")+String:C10(Records in table:C83([PRODUCTS:4]))
Else 
	infoProducts:=String:C10(Records in table:C83([PRODUCTS:4]))+Get localized string:C991(" products out of ")+String:C10(Records in selection:C76([PRODUCTS:4]))
End if 

UPDATE_ALL_BUTTON("bAllProducts"; Current form table:C627)

UPDATE_SUBSET_BUTTON("bShowSubsetProducts"; "$highlightedProducts"; Current form table:C627)