C_LONGINT:C283($tablenum; $i; $i2)
C_POINTER:C301($TablePtr; $FieldPtr)
C_TEXT:C284($lastTable; $fieldname)
C_BOOLEAN:C305($hasfield)

If (Form event code:C388=On Clicked:K2:4)
	$TablePtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Tablename")
	$FieldPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Fieldname")
	
	C_OBJECT:C1216($customFieldsAllTables; $custFields; $Fielddata)
	ARRAY OBJECT:C1221($tableobjectarray; 0)
	ARRAY OBJECT:C1221($fieldsobjectarray; 0)
	$lastTable:=""
	For ($i; 1; Size of array:C274($TablePtr->))
		If ($lastTable#$TablePtr->{$i})
			If ($lastTable#"")
				OB SET:C1220($custFields; "name"; $lastTable)
				If (Size of array:C274($fieldsobjectarray)#0)
					OB SET ARRAY:C1227($custFields; "fields"; $fieldsobjectarray)
				End if 
				APPEND TO ARRAY:C911($tableobjectarray; $custFields)
				CLEAR VARIABLE:C89($custFields)
				ARRAY OBJECT:C1221($fieldsobjectarray; 0)
			End if 
			$lastTable:=$TablePtr->{$i}
		End if 
		
		If ($FieldPtr->{$i}#"")
			CLEAR VARIABLE:C89($Fielddata)
			OB SET:C1220($Fielddata; "name"; $FieldPtr->{$i})
			APPEND TO ARRAY:C911($fieldsobjectarray; $Fielddata)
		End if 
		
	End for 
	If (Size of array:C274($fieldsobjectarray)#0)
		OB SET ARRAY:C1227($custFields; "fields"; $fieldsobjectarray)
	End if 
	OB SET:C1220($custFields; "name"; $lastTable)
	APPEND TO ARRAY:C911($tableobjectarray; $custFields)
	
	C_OBJECT:C1216($helperobject)
	OB SET ARRAY:C1227($helperobject; "Tables"; $tableobjectarray)
	
	$tableptr:=Current form table:C627
	$hasfield:=False:C215
	$tablenum:=Table:C252($tableptr)
	For ($i2; 1; Get last field number:C255($tableptr))
		If (Is field number valid:C1000($tablenum; $i2))
			$fieldname:=Field name:C257($tablenum; $i2)
			If ($fieldname="CustomFields_")
				If (Type:C295(Field:C253($tablenum; $i2)->)=Is object:K8:27)
					$hasfield:=True:C214
					$fieldptr:=Field:C253($tablenum; $i2)
				End if 
			End if 
		End if 
	End for 
	If ($hasfield)
		$fieldptr->:=$helperobject
	End if 
	
End if 