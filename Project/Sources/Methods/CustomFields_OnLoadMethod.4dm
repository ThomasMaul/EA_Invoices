//%attributes = {}
// call in detail form, On load form method
// for every table using custom fields

ARRAY TEXT:C222($customF_Name; 0)
ARRAY TEXT:C222($customF_Value; 0)
C_BOOLEAN:C305($oldstatus; $hasfield)
C_TEXT:C284($tablename; $fieldname; $curname; $curfieldname; $curfieldvalue)
C_LONGINT:C283($item; $i; $i2; $pos; $tablenum)
C_POINTER:C301($Settingstable; $settingsfield; $tableptr; $fieldptr)

// ************** Adjust this three lines to your application ****************
ALL RECORDS:C47([SETTINGS:5])
$Settingstable:=->[SETTINGS:5]
$settingsfield:=->[SETTINGS:5]CustomFields_:3

If (OB Is defined:C1231($settingsfield->))
	
	$tableptr:=Current form table:C627
	$hasfield:=False:C215
	$tablenum:=Table:C252($tableptr)
	For ($i2; 1; Get last field number:C255($tableptr))
		If (Is field number valid:C1000($tablenum; $i2))
			$fieldname:=Field name:C257($tablenum; $i2)
			If ($fieldname="CustomFields")
				If (Type:C295(Field:C253($tablenum; $i2)->)=Is object:K8:27)
					$hasfield:=True:C214
					$fieldptr:=Field:C253($tablenum; $i2)
				End if 
			End if 
		End if 
	End for 
	If ($hasfield)
		
		// start fresh, we don't know yet if there are custom fields used at all for this record
		LISTBOX DELETE COLUMN:C830(*; "customF_LB"; 1; 2)
		
		// check if there should be custom fields
		$oldstatus:=Read only state:C362($Settingstable->)
		READ ONLY:C145($Settingstable->)
		ALL RECORDS:C47($Settingstable->)
		If (Not:C34($oldstatus))
			READ WRITE:C146($Settingstable->)
		End if 
		ARRAY OBJECT:C1221($tablesarray; 0)
		C_OBJECT:C1216($object)
		$object:=$settingsfield->
		OB GET ARRAY:C1229($object; "Tables"; $tablesarray)
		$tablename:=Table name:C256(Current form table:C627)
		$item:=0
		For ($i; 1; Size of array:C274($tablesarray))
			$curname:=OB Get:C1224($tablesarray{$i}; "name"; Is text:K8:3)
			If ($curname=$tablename)
				$item:=$i
			End if 
		End for 
		If ($item>0)  // found
			ARRAY OBJECT:C1221($fieldsarray; 0)
			OB GET ARRAY:C1229($tablesarray{$item}; "fields"; $fieldsarray)
			If (Size of array:C274($fieldsarray)>0)
				For ($i; 1; Size of array:C274($fieldsarray))
					$curfieldname:=OB Get:C1224($fieldsarray{$i}; "name"; Is text:K8:3)
					APPEND TO ARRAY:C911($customF_Name; $curfieldname)
					APPEND TO ARRAY:C911($customF_Value; "")
				End for 
			End if 
		End if 
		
		// check if there are custom fields saved, not in default list
		// assign values for found fields
		ARRAY TEXT:C222($arrNames; 0)
		ARRAY LONGINT:C221($arrTypes; 0)
		OB GET PROPERTY NAMES:C1232($fieldptr->; $arrNames; $arrTypes)
		For ($i; 1; Size of array:C274($arrNames))
			$curfieldvalue:=OB Get:C1224($fieldptr->; $arrNames{$i}; Is text:K8:3)
			$pos:=Find in array:C230($customF_Name; $arrNames{$i})
			If ($pos<1)
				APPEND TO ARRAY:C911($customF_Name; $arrNames{$i})
				APPEND TO ARRAY:C911($customF_Value; $curfieldvalue)
				$pos:=Size of array:C274($customF_Name)
			End if 
			$customF_Value{$pos}:=$curfieldvalue
		End for 
		
		
		// add to list box
		If (Size of array:C274($customF_Name)>0)
			OBJECT SET VISIBLE:C603(*; "customF_LB"; True:C214)
			
			C_POINTER:C301($NilPtr; $ColPtr)
			LISTBOX INSERT COLUMN:C829(*; "customF_LB"; 1; "CLB_Name"; $NilPtr; "CLB_NameHeader"; $NilPtr)
			$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "CLB_Name")
			//%W-518.1
			//%W-518.5
			ARRAY TEXT:C222($ColPtr->; 0)
			COPY ARRAY:C226($customF_Name; $ColPtr->)
			
			LISTBOX INSERT COLUMN:C829(*; "customF_LB"; 2; "CLB_Value"; $NilPtr; "CLB_ValueHeader"; $NilPtr)
			$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "CLB_Value")
			ARRAY TEXT:C222($ColPtr->; 0)
			COPY ARRAY:C226($customF_Value; $ColPtr->)
			//%W+518.1
			//%W+518.5
		End if 
	End if 
End if 