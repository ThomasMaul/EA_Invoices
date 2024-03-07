//%attributes = {}
// this is called when updating field lists
// it allows to overwrite data selection

#DECLARE($table : Text; $data : 4D:C1709.EntitySelection)->$result : 4D:C1709.EntitySelection

$result:=$data

If ($table="INVOICE_LINES")
	//if($data.data.
	$result:=$data.invoice_lines
End if 