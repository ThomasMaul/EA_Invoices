//%attributes = {}
If (Is Windows:C1573)
	OBJECT SET VISIBLE:C603(*; "@.mac"; False:C215)
Else 
	OBJECT SET VISIBLE:C603(*; "@.win"; False:C215)
End if 
