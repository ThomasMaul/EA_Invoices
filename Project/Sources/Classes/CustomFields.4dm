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
	