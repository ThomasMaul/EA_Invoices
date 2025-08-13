
var $TablePtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Tablename")
var $FieldPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Fieldname")

// { "name":"test", "fields":[{"name":"field1"}] }
var $custFields:={Tables: []}

var $lastTable:=""
var $table:={}
var $fields:=[]
var $i : Integer
For ($i; 1; Size of array:C274($TablePtr->))
	If ($lastTable#$TablePtr->{$i})
		If ($lastTable#"")
			$table.name:=$lastTable
			$table.fields:=$fields
			$custFields.Tables.push($table)
			$table:={}
			$fields:=[]
		End if 
		$lastTable:=$TablePtr->{$i}
	End if 
	
	If ($FieldPtr->{$i}#"")
		$fields.push({name: $FieldPtr->{$i}})
	End if 
End for 

If ($fields.length>0)
	$table.name:=$lastTable
	$table.fields:=$fields
	$custFields.Tables.push($table)
End if 

var $settings:=ds:C1482.SETTINGS.all().first()
$settings.CustomFields_:=$custFields
var $status:=$settings.save(dk auto merge:K85:24)
If ($status.success=False:C215)
	ALERT:C41("Error saving custom fields: "+$status.statusText)
Else 
	CANCEL:C270  // close the window
End if 