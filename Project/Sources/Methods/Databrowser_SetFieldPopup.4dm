//%attributes = {}
C_OBJECT:C1216($1; $table)
$table:=$1

ARRAY TEXT:C222($fieldlist; 0)
APPEND TO ARRAY:C911($fieldlist; "All index fields")
APPEND TO ARRAY:C911($fieldlist; "-")
For each ($field; $table)
	$fieldobject:=$table[$field]
	If ($fieldobject.kind="storage")
		If (($fieldobject.fieldType#Is BLOB:K8:12) & ($fieldobject.fieldType#Is object:K8:27) & ($fieldobject.fieldType#Is picture:K8:10))
			APPEND TO ARRAY:C911($fieldlist; $field)
		End if 
	End if 
End for each 

$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; "fieldlist")
If (Not:C34(Is nil pointer:C315($ptr)))
	If (Value type:C1509($ptr->)=Text array:K8:16)
		//%W-518.1    // we checked that the pointer is a text array, so disable warning
		COPY ARRAY:C226($fieldlist; $ptr->)
		//%W+518.1
		$ptr->:=1
	End if 
End if 