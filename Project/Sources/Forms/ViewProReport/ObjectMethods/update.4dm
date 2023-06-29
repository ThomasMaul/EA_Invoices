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
	$sheetcount+=1
	$datasheet:=$0
End if 

$currentsheet:=VP Get current sheet("ViewProArea")
$newcurrentsheet:=-1
If ($currentsheet=$datasheet)
	If (($sheetcount>1) && ($datasheet=$currentsheet))
		If ($currentsheet>0)
			$newcurrentsheet:=0
		Else 
			$newcurrentsheet:=1
		End if 
		VP SET CURRENT SHEET("ViewProArea"; $newcurrentsheet)
	Else 
		ALERT:C41("data of the current sheet cannot be updated, as the table will be locked")
		return 
	End if 
End if 

$win:=Open form window:C675("FieldListORDA")
$data:=New object:C1471("table"; ds:C1482[Form:C1466.table])
If ((Form:C1466.selectedFields#Null:C1517) && (Form:C1466.selectedFields.length>0))
	$data.selectedFields:=Form:C1466.selectedFields
Else 
	// try to get field names from spreadsheet
	$tables:=VP Get tables("ViewProArea"; $datasheet)
	If ($tables.indexOf(Form:C1466.table)>=0)
		$range:=VP Get table range("ViewProArea"; Form:C1466.table; vk table data range:K89:157; $datasheet)
		$count:=Num:C11($range.ranges[0].columnCount)
		$col:=New collection:C1472
		var $attributes : Object
		For ($i; 0; $count-1)
			$attributes:=VP Get table column attributes("ViewProArea"; Form:C1466.table; $i; $datasheet)
			$col.push($attributes.name)
		End for 
	End if 
	Form:C1466.selectedFields:=$col
	$data.selectedFields:=Form:C1466.selectedFields
End if 
DIALOG:C40("FieldListORDA"; $data)
CLOSE WINDOW:C154($win)

If (OK=0)
	return 
End if 

If (Form:C1466.masterform.selectedSubset.length>0)  // if some records are selected, we use those, else all
	Form:C1466.data:=Form:C1466.masterform.selectedSubset
Else 
	Form:C1466.data:=Form:C1466.masterform.displayedSelection
End if 

Form:C1466.data:=VPReportCallback(Form:C1466.table; Form:C1466.data)

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

VP SET ROW COUNT("ViewProArea"; Form:C1466.tabledata.table.length+1; $datasheet)
VP SET DATA CONTEXT("ViewProArea"; Form:C1466.tabledata; $datasheet)

VP COLUMN AUTOFIT(VP Cells("ViewProArea"; 0; 0; Form:C1466.selectedFields.length; Form:C1466.tabledata.table.length; $datasheet))

If ($newcurrentsheet>=0)
	VP SET CURRENT SHEET("ViewProArea"; $currentsheet)  // back to previous current sheet
End if 
CALL FORM:C1391(Current form window:C827; "VPReportUpdate")
