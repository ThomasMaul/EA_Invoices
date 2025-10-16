// handles Custom Field logic

property defaults : Object  // cached content of settings table

shared singleton Class constructor
	This:C1470.update()
	
	
Function update()
	var $settings:=ds:C1482.SETTINGS.all().first()
	This:C1470.defaults:=OB Copy:C1225($settings.CustomFields_; ck shared:K85:29)
	If (This:C1470.defaults=Null:C1517)
		This:C1470.defaults:={}
	End if 
	// { "name":"test", "fields":[{"name":"field1"}] }
	
	
Function buildContent($tablename : Text; $custom : Object)->$result : Object
/* stored in format:
{
"Twitter": "@abc",
"Customer Group": "Special"
}
	
or null or empty
	
to return in format:
{"fields": [{"name": "Twitter", "value": "@abc"},
{"name": "Customer Group", "value": "Special"}
{"name": "unused property", "value": ""}
]
*/
	
	// change format
	var $col : Collection:=[]
	var $property : Text
	If ($custom#Null:C1517)
		For each ($property; $custom)
			$col.push(New object:C1471("name"; $property; "value"; $custom[$property]))
		End for each 
	End if 
	
	// We also need to add missing defined attributes from settings field
	If (This:C1470.defaults.Tables#Null:C1517)
		var $subcol : Collection:=This:C1470.defaults.Tables.query("name=:1"; $tablename)
		If ($subcol.length>0)
			var $field : Object
			For each ($field; $subcol[0].fields)
				If ($col.query("name=:1"; $field.name).length=0)
					$col.push(New object:C1471("name"; $field.name; "value"; ""))
				End if 
			End for each 
		End if 
	End if 
	
	return {fields: $col}
	
Function setContent($tablename : Text; $custom : Object)->$result : Object
	// reverse of buildContent
	// remove empty properties
	If ($custom=Null:C1517) || (OB Is empty:C1297($custom) || ($custom.fields=Null:C1517))
		return {}
	End if 
	
	var $col : Collection:=$custom.fields
	var $ob : Object
	For each ($ob; $col)
		If ($ob.value#"")
			$result[$ob.name]:=$ob.value
		End if 
	End for each 
	
Function onDataChange()
	var $tablenum; $i2; $index : Integer
	var $new; $fieldname; $name : Text
	var $tableptr; $fieldptr; $ColPtr : Pointer
	var $hasfield : Boolean
	var $value : Variant
	
	If (Form event code:C388=On Data Change:K2:15)
		$tableptr:=Current form table:C627
		$hasfield:=False:C215
		$tablenum:=Table:C252($tableptr)
		For ($i2; 1; Last field number:C255($tableptr))
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
			// get field name and field value
			$index:=OBJECT Get pointer:C1124(Object named:K67:5; "customF_LB")->
			$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "CLB_Name")
			$name:=$ColPtr->{$index}
			$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "CLB_Value")
			$value:=$ColPtr->{$index}
			
			If ($value#"")
				OB SET:C1220($fieldptr->; $name; $value)
			Else 
				$new:=$fieldptr->
				OB REMOVE:C1226($new; $name)
				$fieldptr->:=$new
			End if 
		End if 
	End if 
	
Function onLoad()
	// call in detail form, On load form method
	// for every table using custom fields
	
	// note: code below copied from 4D Worldtour for 4D v14 presenting objec tfield. Written bevor object notation arrived...
	
	ARRAY TEXT:C222($customF_Name; 0)
	ARRAY TEXT:C222($customF_Value; 0)
	var $oldstatus; $hasfield : Boolean
	var $tablename; $fieldname; $curname; $curfieldname; $curfieldvalue : Text
	var $item; $i; $i2; $pos; $tablenum : Integer
	var $tableptr; $fieldptr : Pointer
	var $settingsfield : Object
	
	// ************** Adjust this line to your application ****************
	$settingsfield:=ds:C1482.SETTINGS.all().first().CustomFields_
	
	If ($settingsfield#Null:C1517)
		$tableptr:=Current form table:C627
		$hasfield:=False:C215
		$tablenum:=Table:C252($tableptr)
		For ($i2; 1; Last field number:C255($tableptr))
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
			ARRAY OBJECT:C1221($tablesarray; 0)
			OB GET ARRAY:C1229($settingsfield; "Tables"; $tablesarray)
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
	
Function _test()
	// use none existing table name to avoid errors based on settings tables
	var $result:=This:C1470.buildContent("xxx"; {Twitter: "@abc"; CustomerGroup: "Special"})
	var $compare:=[{name: "Twitter"; value: "@abc"}; \
		{name: "CustomerGroup"; value: "Special"}]
	If (Not:C34($result.fields.equal($compare)))
		ALERT:C41("error 1 "+Current method name:C684)
		TRACE:C157
	End if 
	
	$result:=This:C1470.buildContent("CLIENTS"; {Twitter: "@abc"; CustomerGroup: "Special"})
	$compare:=[{name: "Twitter"; value: "@abc"}; \
		{name: "CustomerGroup"; value: "Special"}; \
		{name: "VAT code"; value: ""}; \
		{name: "test"; value: ""}]
	If (Not:C34($result.fields.equal($compare)))
		ALERT:C41("error 2 "+Current method name:C684)
		TRACE:C157
	End if 
	