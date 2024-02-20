C_BOOLEAN:C305($mod; $found; $hasfield)
C_TEXT:C284($json; $name; $nameinarray; $fieldname; $fieldnameinarray)
C_LONGINT:C283($i; $i2; $tablenum)
C_POINTER:C301($settingsfield; $tableptr)

Case of 
	: (Form event code:C388=On Load:K2:1)
		$tableptr:=Current form table:C627
		$hasfield:=False:C215
		$tablenum:=Table:C252($tableptr)
		For ($i2; 1; Get last field number:C255($tableptr))
			If (Is field number valid:C1000($tablenum; $i2))
				$fieldname:=Field name:C257($tablenum; $i2)
				If ($fieldname="CustomFields_")
					If (Type:C295(Field:C253($tablenum; $i2)->)=Is object:K8:27)
						$hasfield:=True:C214
						$settingsfield:=Field:C253($tablenum; $i2)
					End if 
				End if 
			End if 
		End for 
		
		If ($hasfield)
			$mod:=False:C215
			ARRAY OBJECT:C1221($tablearray; 0)
			ARRAY TEXT:C222($Choise_Fieldtype; 0)
			If (OB Is empty:C1297($settingsfield->))
				$json:=""
				
			Else 
				
				$json:=JSON Stringify:C1217($settingsfield->; *)
				OBJECT Get pointer:C1124(Object named:K67:5; "JSONdebug")->:=$json
				OB GET ARRAY:C1229($settingsfield->; "Tables"; $tablearray)
			End if 
			
			// { "name":"test", "fields":[{"name":"field1", "type":1}] }
			For ($i; 1; Get last table number:C254)
				If (Is table number valid:C999($i))
					$name:=Table name:C256($i)
					$found:=False:C215
					For ($i2; 1; Size of array:C274($tablearray))
						$nameinarray:=OB Get:C1224($tablearray{$i2}; "name")
						If ($nameinarray=$name)
							$found:=True:C214
							$i2:=Size of array:C274($tablearray)
						End if 
					End for 
					
					If (Not:C34($found))
						// check if table has field type Object name
						$hasfield:=False:C215
						For ($i2; 1; Get last field number:C255($i))
							If (Is field number valid:C1000($i; $i2))
								$fieldname:=Field name:C257($i; $i2)
								If ($fieldname="CustomFields")
									If (Type:C295(Field:C253($i; $i2)->)=Is object:K8:27)
										$hasfield:=True:C214
									End if 
								End if 
							End if 
						End for 
						If ($hasfield)
							CLEAR VARIABLE:C89($tableobject)
							C_OBJECT:C1216($tableobject)
							OB SET:C1220($tableobject; "name"; $name)
							APPEND TO ARRAY:C911($tablearray; $tableobject)
							$mod:=True:C214
						End if 
					End if 
					
				End if 
			End for 
			
			If ($mod)
				C_OBJECT:C1216($helperobject)
				OB SET ARRAY:C1227($helperobject; "Tables"; $tablearray)
				$settingsfield->:=$helperobject
				OBJECT Get pointer:C1124(Object named:K67:5; "JSONdebug")->:=JSON Stringify:C1217($settingsfield->)
			End if 
			
			// now build arrays to show in listbox
			ARRAY TEXT:C222($LB_tableNames; 0)
			ARRAY TEXT:C222($LB_Fields; 0)
			
			For ($i; 1; Size of array:C274($tablearray))
				$nameinarray:=OB Get:C1224($tablearray{$i}; "name")
				ARRAY OBJECT:C1221($fieldarray; 0)
				OB GET ARRAY:C1229($tablearray{$i}; "fields"; $fieldarray)
				If (Size of array:C274($fieldarray)=0)
					APPEND TO ARRAY:C911($LB_tableNames; $nameinarray)
					APPEND TO ARRAY:C911($LB_Fields; "")
				Else 
					For ($i2; 1; Size of array:C274($fieldarray))
						$fieldnameinarray:=OB Get:C1224($fieldarray{$i2}; "name")
						APPEND TO ARRAY:C911($LB_tableNames; $nameinarray)
						APPEND TO ARRAY:C911($LB_Fields; $fieldnameinarray)
					End for 
				End if 
			End for 
			
			// now build listbox
			C_POINTER:C301($NilPtr; $ColPtr; $headprt)
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
			
		End if 
End case 