//%attributes = {}
If (<>runningOnWin)
	OBJECT SET VISIBLE:C603(*; "@.mac"; False:C215)
Else 
	OBJECT SET VISIBLE:C603(*; "@.win"; False:C215)
End if 
