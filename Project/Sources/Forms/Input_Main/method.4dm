Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		ds:C1482.startTransaction()
		var $name : Text:="Form_"+Form:C1466.tablename
		If (cs:C1710[$name]#Null:C1517)
			Form:C1466.preview:=cs:C1710[$name].new()
		Else 
			Form:C1466.preview:=New object:C1471
		End if 
		Form:C1466.preview.data:=Form:C1466.SelectedElement  // pass the selected element
		
		var $tableptr : Pointer:=Formula from string:C1601("->["+Form:C1466.tablename+"]").call()
		OBJECT SET SUBFORM:C1138(*; "Preview"; $tableptr->; "Input_ORDA")
		
		If (Form:C1466.preview.data.isNew())
			OBJECT SET VISIBLE:C603(*; "but_@"; False:C215)
			OBJECT SET ENABLED:C1123(*; "but_@"; False:C215)  // even unvisible, it could have a shortcut
		End if 
		
		If (Form:C1466.preview.loadEvent#Null:C1517)
			Form:C1466.preview.loadEvent()
		End if 
End case 