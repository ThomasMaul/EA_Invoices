If (Records in table:C83([CLIENTS:1])=0)  // Test if the database is empty
	CONFIRM:C162("Your database is empty."+Char:C90(Carriage return:K15:38)+"Do you want to import some sample data?"; "Yes, please!"; "No, thanks")
	If (Ok=1)
		FillData
	End if 
End if 

If (False:C215)  // old code, classic interface
	Clients_Manage
	
Else 
	If (Is Windows:C1573)
		HIDE MENU BAR:C432
	End if 
	SET MENU BAR:C67("empty")
	var $win : Integer:=Open form window:C675("ORDAListbox")
	DIALOG:C40("ORDAListbox"; *)
	
End if 