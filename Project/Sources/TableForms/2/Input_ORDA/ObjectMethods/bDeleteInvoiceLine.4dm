If (Form:C1466.curLine#Null:C1517)
	CONFIRM:C162("Do you really want to delete "+Form:C1466.curLine.ProductName+"?"; "Yes"; "No")
	If (Ok=1)
		Form:C1466.curLine.drop()
		Form:C1466.data.updateTotals()
	End if 
End if 

