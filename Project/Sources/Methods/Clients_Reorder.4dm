//%attributes = {"invisible":true}
// (P) Clients_Reorder
ORDER BY:C49([CLIENTS:1]; [CLIENTS:1]Name:2; >)

If (Length:C16(Get localized string:C991("reorder_label_reverse"))=0)
	infoClients:=String:C10(Records in selection:C76([CLIENTS:1]))+Get localized string:C991(" clients out of ")+String:C10(Records in table:C83([CLIENTS:1]))
Else 
	infoClients:=String:C10(Records in table:C83([CLIENTS:1]))+Get localized string:C991(" clients out of ")+String:C10(Records in selection:C76([CLIENTS:1]))
End if 

UPDATE_ALL_BUTTON("bAllClients"; Current form table:C627)

UPDATE_SUBSET_BUTTON("bShowSubsetClients"; "$highlightedClients"; Current form table:C627)

