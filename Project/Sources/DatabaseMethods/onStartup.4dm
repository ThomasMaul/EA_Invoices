If (Records in table:C83([CLIENTS:1])=0)  // Test if the database is empty
	CONFIRM:C162("Your database is empty."+Char:C90(Carriage return:K15:38)+"Do you want to import some sample data?"; "Yes, please!"; "No, thanks")
	If (Ok=1)
		FillData
	End if 
End if 

Clients_Manage