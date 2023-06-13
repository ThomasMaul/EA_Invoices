// create sheet "data" if not exists, use that sheet later for data

$datasheet:=-1
$sheetcount:=VP Get sheet count("ViewProArea")
For ($i; 0; $sheetcount)
	$name:=VP Get sheet name("ViewProArea"; $i)
	If ($name="data")
		$datasheet:=$i
		break
	End if 
End for 
If ($datasheet<0)
	VP ADD SHEET("ViewProArea"; 0; "data")
	$datasheet:=$0
End if 

If (Form:C1466.data.length>5000)
	CONFIRM:C162("Aktuelle Auswahl: "+String:C10(Form:C1466.data.length)+". Wirklich Report für so viele?"; "Ja"; "Auf 1000 verkleinern")
	If (OK=0)
		Form:C1466.data:=Form:C1466.data.slice(0; 4999)
	End if 
End if 


$win:=Open form window:C675("FieldListORDA")
$data:=New object:C1471("table"; ds:C1482[Form:C1466.table])
If (Form:C1466.selectedFields#Null:C1517)
	$data.selectedFields:=Form:C1466.selectedFields
End if 
DIALOG:C40("FieldListORDA"; $data)
CLOSE WINDOW:C154($win)

If (OK=0)
	return 
End if 

If ($data.selectedFields.length>0)
	Form:C1466.selectedFields:=$data.selectedFields
	$col:=Form:C1466.data.toCollection($data.selectedFields)
	ds:C1482.flattenCollection($col; True:C214)
	Form:C1466.tabledata:=New object:C1471("table"; $col)
	
Else 
	// nothing !!   Form.tabledata:=New object("table"; Form.data.toCollection())
End if 

For each ($entity; Form:C1466.tabledata.table)
	For each ($field; $entity)
		$type:=Value type:C1509($entity[$field])
		If ($type=4)
			If ($entity[$field]=!00-00-00!)
				$entity[$field]:=""
			End if 
		End if 
	End for each 
End for each 

$entity:=Form:C1466.tabledata.table.first()
If ($entity#Null:C1517)
	$columns:=OB Keys:C1719($entity).length
Else 
	$columns:=1
End if 



//$rowCount:=VP Get row count("ViewProArea"; $datasheet)

VP SET ROW COUNT("ViewProArea"; Form:C1466.tabledata.table.length+1; $datasheet)

VP SET DATA CONTEXT("ViewProArea"; Form:C1466.tabledata; $datasheet)

/*
var $options : cs.ViewPro.TableOptions
$options:=cs.ViewPro.TableOptions.new()
$options.tableColumns:=New collection()
$options.tableColumns.push(cs.ViewPro.TableColumns.new("name"; "First name"; "dataField"; "firstName"))
$options.tableColumns.push(cs.ViewPro.TableColumns.new("name"; "Last name"; "dataField"; "lastName"))
$options.tableColumns.push(cs.ViewPro.TableColumns.new("name"; "Email"; "dataField"; "email"))
*/

$tables:=VP Get tables("ViewProArea"; $datasheet)
If ($tables.indexOf(Form:C1466.table)>=0)
	For each ($t; $tables)
		VP REMOVE TABLE("ViewProArea"; $t; $datasheet)
	End for each 
End if 
$tables:=VP Get tables("ViewProArea"; $datasheet)
If ($tables.length=0)  // else table is locked in SpreadJS
	VP CREATE TABLE(VP Cell("ViewProArea"; 0; 0; $datasheet); Form:C1466.table; "table")
End if 

VP COLUMN AUTOFIT(VP Cells("ViewProArea"; 0; 0; $columns; Form:C1466.tabledata.table.length; $datasheet))