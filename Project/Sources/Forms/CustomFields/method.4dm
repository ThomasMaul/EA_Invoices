Case of 
	: (Form event code:C388=On Load:K2:1)
		var $settings:=ds:C1482.SETTINGS.all().first()
		var $customfields:=$settings.CustomFields_
		If ($customfields=Null:C1517)
			$customfields:={}
		End if 
		
		// { "name":"test", "fields":[{"name":"field1"}] }
		
		ARRAY TEXT:C222($LB_tableNames; 0)  // used in hierarchical list box
		ARRAY TEXT:C222($LB_Fields; 0)
		
		var $table : Object
		For each ($table; $customfields.Tables)
			If (ds:C1482[$table.name].CustomFields#Null:C1517)
				If (ds:C1482[$table.name].CustomFields.fieldType=Is object:K8:27)
					var $field : Object
					For each ($field; $table.fields)
						APPEND TO ARRAY:C911($LB_tableNames; $table.name)
						APPEND TO ARRAY:C911($LB_Fields; $field.name)
					End for each 
				End if 
			End if 
		End for each 
		
		// now build listbox
		var $NilPtr; $ColPtr; $headprt : Pointer
		LISTBOX INSERT COLUMN:C829(*; "LBcustomFields"; 1; "Tablename"; $NilPtr; "TableHeader"; $NilPtr)
		$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Tablename")
		OBJECT SET ENTERABLE:C238(*; "Tablename"; False:C215)
		//%W-518.1
		//%W-518.5
		ARRAY TEXT:C222($ColPtr->; 0)
		COPY ARRAY:C226($LB_tableNames; $ColPtr->)
		$headprt:=OBJECT Get pointer:C1124(Object named:K67:5; "TableHeader")
		OBJECT SET TITLE:C194($headprt->; "Table name")
		
		LISTBOX INSERT COLUMN:C829(*; "LBcustomFields"; 2; "Fieldname"; $NilPtr; "FieldnameHeader"; $NilPtr)
		$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Fieldname")
		ARRAY TEXT:C222($ColPtr->; 0)
		COPY ARRAY:C226($LB_Fields; $ColPtr->)
		//%W+518.1
		//%W+518.5
		$headprt:=OBJECT Get pointer:C1124(Object named:K67:5; "FieldnameHeader")
		OBJECT SET TITLE:C194($headprt->; "Field name")
		
		ARRAY POINTER:C280($ArrHierarch; 1)
		$ArrHierarch{1}:=OBJECT Get pointer:C1124(Object named:K67:5; "Tablename")
		LISTBOX SET HIERARCHY:C1098(*; "LBcustomFields"; True:C214; $ArrHierarch)
		
End case 