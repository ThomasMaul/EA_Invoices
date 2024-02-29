//%attributes = {}
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
	ALERT:C41("Data Sheet missing, please Insert Data first")
	return 
End if 

$tables:=VP Get tables("ViewProArea"; $datasheet)
If ($tables.indexOf(Form:C1466.table)<0)
	ALERT:C41("Data table missing, please Insert Data first")
	return 
End if 

$range:=VP Get table range("ViewProArea"; Form:C1466.table; vk table data range:K89:157; $datasheet)
If ($range=Null:C1517)
	ALERT:C41("Data table missing, please Insert Data first")
	return 
End if 

ASSERT:C1129(($range.ranges.length=1); "Internal Error, exactly one range expected")
$count:=Num:C11($range.ranges[0].columnCount)

$col:=New collection:C1472
var $attributes : Object
$dataclass:=Form:C1466.data.getDataClass()
For ($i; 0; $count-1)
	$attributes:=VP Get table column attributes("ViewProArea"; Form:C1466.table; $i; $datasheet)
	//If ($dataclass[$attributes.name]#Null)  // check if that is a valid 4D field
	$col.push($attributes.name)
	//End if 
End for 

$filter:=$col.join(",")

// update data
If (Form:C1466.masterform.Selection.length>0)  // if some records are selected, we use those, else all
	Form:C1466.data:=Form:C1466.masterform.Selection
Else 
	Form:C1466.data:=Form:C1466.masterform.listbox
End if 

Form:C1466.data:=VPReportCallback(Form:C1466.table; Form:C1466.data)

$col:=Form:C1466.data.toCollection($filter)
ds:C1482.flattenCollection($col; True:C214)
Form:C1466.tabledata:=New object:C1471("table"; $col)

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

VP SET ROW COUNT("ViewProArea"; Form:C1466.tabledata.table.length+1; $datasheet)
VP SET DATA CONTEXT("ViewProArea"; Form:C1466.tabledata; $datasheet)

$js:="Utils.currentSheet.pivotTables.get(\"PivotTable1\").updateSource()"
$long:=WA Evaluate JavaScript:C1029(*; "ViewProArea"; $js; Is longint:K8:6)


