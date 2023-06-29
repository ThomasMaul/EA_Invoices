Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		ARRAY TEXT:C222($tables; 0)
		For each ($table; ds:C1482)
			APPEND TO ARRAY:C911($tables; $table)
		End for each 
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; "tablelist")
		If (Not:C34(Is nil pointer:C315($ptr)))
			If (Value type:C1509($ptr->)=Text array:K8:16)
				//%W-518.1  
				COPY ARRAY:C226($tables; $ptr->)
				$ptr->:=1
				
				Form:C1466.listbox:=ds:C1482[$tables{1}].all()
				Databrowser_SetListbox
				
				Databrowser_SetFieldPopup(ds:C1482[$tables{1}])
				
			End if 
		End if 
		
End case 