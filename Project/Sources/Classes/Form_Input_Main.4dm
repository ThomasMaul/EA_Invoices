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
	
Function handleNavigationButtons($job : Text)
	If (Form:C1466.preview.data.touched())
		var $status : Object:=Form:C1466.preview.data.save(dk auto merge:K85:24)
		If ($status.success)
			ds:C1482.validateTransaction()
			CANCEL:C270
		Else 
			ALERT:C41("Error on saving: "+$status.statusText)
		End if 
	End if 
	
	var $next : cs:C1710.Entity
	Case of 
		: ($job="Next")
			$next:=Form:C1466.SelectedElement.next()
		: ($job="Previous")
			$next:=Form:C1466.SelectedElement.previous()
		: ($job="Last")
			$next:=Form:C1466.SelectedElement.last()
		: ($job="First")
			$next:=Form:C1466.SelectedElement.first()
	End case 
	
	If ($next#Null:C1517)
		Form:C1466.SelectedElement:=$next
		Form:C1466.preview.data:=$next
	End if 
	This:C1470.updateButtons()
	
	If (Form:C1466.preview.loadEvent#Null:C1517)
		Form:C1466.preview.loadEvent()  // start the next transaction
	End if 