// Object Method [CLIENTS]Input.BDeleteClient
CONFIRM:C162(Get localized string:C991("Do you really want to delete this client?"); \
Get localized string:C991("Yes"); \
Get localized string:C991("No"))
If (Ok=1)
	DELETE RECORD:C58([CLIENTS:1])  // Delete the selected client
End if 