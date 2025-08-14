property tablename : Text
property SelectedElement : cs:C1710.Entity


Class constructor
	
Function updateButtons()
	var $next : cs:C1710.Entity:=Form:C1466.SelectedElement.next()
	OBJECT SET ENABLED:C1123(*; "but_NextClient"; ($next#Null:C1517))
	OBJECT SET VISIBLE:C603(*; "but_NextClient"; ($next#Null:C1517))
	
	var $prev : cs:C1710.Entity:=Form:C1466.SelectedElement.previous()
	OBJECT SET ENABLED:C1123(*; "but_PreviousClient"; ($prev#Null:C1517))
	OBJECT SET VISIBLE:C603(*; "but_PreviousClient"; ($prev#Null:C1517))
	