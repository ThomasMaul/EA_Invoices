//%attributes = {}
var $datasheet : Integer:=-1
var $sheetcount : Integer:=VP Get sheet count("ViewProArea")
var $i : Integer
For ($i; 0; $sheetcount)
	var $name : Text:=VP Get sheet name("ViewProArea"; $i)
	If ($name="data")
		$datasheet:=$i
		break
	End if 
End for 
If ($datasheet<0)
	ALERT:C41("Data Sheet missing, please Insert Data first")
	return 
End if 

var $tables : Collection:=VP Get tables("ViewProArea"; $datasheet)
If ($tables.indexOf(Form:C1466.table)<0)
	ALERT:C41("Data table missing, please Insert Data first")
	return 
End if 

var $range : Object:=VP Get table range("ViewProArea"; Form:C1466.table; vk table data range:K89:157; $datasheet)
If ($range=Null:C1517)
	ALERT:C41("Data table missing, please Insert Data first")
	return 
End if 

ASSERT:C1129(($range.ranges.length=1); "Internal Error, exactly one range expected")
var $count : Integer:=Num:C11($range.ranges[0].columnCount)

var $col : Collection:=New collection:C1472
var $attributes : Object
var $dataclass : 4D:C1709.DataClass:=Form:C1466.data.getDataClass()
For ($i; 0; $count-1)
	$attributes:=VP Get table column attributes("ViewProArea"; Form:C1466.table; $i; $datasheet)
	//If ($dataclass[$attributes.name]#Null)  // check if that is a valid 4D field
	$col.push($attributes.name)
	//End if 
End for 

var $filter : Text:=$col.join(",")

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

var $entity : 4D:C1709.Entity
var $field : Text

For each ($entity; Form:C1466.tabledata.table)
	For each ($field; $entity)
		var $type : Integer:=Value type:C1509($entity[$field])
		If ($type=4)
			If ($entity[$field]=!00-00-00!)
				$entity[$field]:=""
			End if 
		End if 
	End for each 
End for each 

VP SET ROW COUNT("ViewProArea"; Form:C1466.tabledata.table.length+1; $datasheet)
VP SET DATA CONTEXT("ViewProArea"; Form:C1466.tabledata; $datasheet)

var $js : Text:="Utils.currentSheet.pivotTables.get(\"PivotTable1\").updateSource()"
var $long : Integer:=WA Evaluate JavaScript:C1029(*; "ViewProArea"; $js; Is longint:K8:6)


