If (FORM Event:C1606.code=On Data Change:K2:15)
	$ptr:=OBJECT Get pointer:C1124(Object current:K67:2)
	If (Not:C34(Is nil pointer:C315($ptr)))
		If (Value type:C1509($ptr->)=Text array:K8:16)
			If ($ptr->#0)
				$table:=Form:C1466.listbox.getDataClass()
				$ds:=$table.getDataStore()
				//%W-533.3    // we checked above that the ptr goes to a text array
				$tablename:=$ptr->{$ptr->}
				//%W+533.3 
				Form:C1466.listbox:=$ds[$tablename].all()
				$table:=$ds[$tablename]
				Databrowser_SetListbox
				
				Databrowser_SetFieldPopup($table)
			End if 
		End if 
	End if 
End if 