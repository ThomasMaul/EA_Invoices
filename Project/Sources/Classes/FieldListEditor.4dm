// helper class to create a field list

Class constructor($class : 4D:C1709.DataClass; $hlist : Integer)
	This:C1470.virt_fieldllist:=Null:C1517
	If ($class=Null:C1517)
		var $col : Collection:=OB Keys:C1719(ds:C1482)
		If ($col.length>0)
			This:C1470.table:=ds:C1482[$col[0]]
		Else 
			ASSERT:C1129(False:C215; "Cannot work in structure without tables")
			return 
		End if 
	Else 
		This:C1470.table:=$class
	End if 
	
	This:C1470.fieldlist:=This:C1470._getDSClassDetails(This:C1470.table)
	This:C1470.hlist:=$hlist
	This:C1470.hlCol:=New collection:C1472
	This:C1470._getTableHList(This:C1470.fieldlist; This:C1470.hlist)
	
	
	
Function _getTableHList($fieldlist : Collection; $hlistref : Integer; $level : Integer; $tablename : Text; $structureTablename : Text)
	var $menuref : Text:=Create menu:C408
	var $field : Object
	var $id : Integer
	
	For each ($field; $fieldlist)
		Case of 
			: ($field.type=Is alpha field:K8:1)
				$id:=1
			: ($field.type=Is text:K8:3)
				$id:=2
			: ($field.type=Is date:K8:7)
				$id:=3
			: ($field.type=Is time:K8:8)
				$id:=4
			: ($field.type=Is boolean:K8:9)
				$id:=5
			: ($field.type=Is integer:K8:5)
				$id:=6
			: ($field.type=Is longint:K8:6)
				$id:=7
			: ($field.type=Is integer 64 bits:K8:25)
				$id:=8
			: ($field.type=Is real:K8:4)
				$id:=9
			: ($field.type=Is BLOB:K8:12)
				$id:=11
			: ($field.type=Is picture:K8:10)
				$id:=12
			: (($field.type=Is object:K8:27) & ($field.kind="relatedEntity"))
				If ($level<3)
					$id:=13
				Else 
					$id:=-1
				End if 
			: ($field.type=Is object:K8:27)
				$id:=14
			: ($field.type=Is subtable:K8:11)
				$id:=-1
			: ($field.type=42)  // relation many
				If ($level<3)
					$id:=13
				End if 
			Else 
				$id:=-1
		End case 
		
		If (($id>=0) && ($id#11) && ($id#12) && ($id#14) && ($field.type#42))
			var $ref : Integer:=This:C1470.hlCol.length+1
			var $para : Text
			If ($level>0)
				$para:=$tablename+"."+$field.name
			Else 
				$para:=$field.name
			End if 
			This:C1470.hlCol.push(New object:C1471("id"; $ref; "name"; $field.displayName; "para"; $para))
			
			If (($id=13) && ($field.relatedDataClass#Null:C1517))  // relation many to one
				If (($field.relatedDataClass.getInfo().name#This:C1470.table.getInfo().name) && \
					($field.relatedDataClass.getInfo().name#$structureTablename))  // not going back to ourself...
					
					var $subfieldlist : Collection
					If ($tablename#"")
						$subfieldlist:=This:C1470._getDSClassDetails($field.relatedDataClass; $tablename+"."+$field.name)
					Else 
						$subfieldlist:=This:C1470._getDSClassDetails($field.relatedDataClass; $field.name)
					End if 
					var $subname : Text:=$field.name  //displayName
					If ($tablename#"")
						$subname:=$tablename+"."+$subname
					End if 
					var $sublist : Integer:=New list:C375
					This:C1470.hlCol.push(New object:C1471("id"; $ref; "name"; $field.displayName; "para"; $para))
					This:C1470._getTableHList($subfieldlist; $sublist; $level+1; $subname; $field.relatedDataClass.getInfo().name)
					
					APPEND TO LIST:C376($hlistref; $field.displayName; $ref; $sublist; True:C214)
					SET LIST ITEM PROPERTIES:C386($hlistref; $ref; False:C215; Plain:K14:1; "path:/RESOURCES/Images/Field_7.png")
					
				End if 
				
			Else 
				
				APPEND TO LIST:C376($hlistref; $field.displayName; $ref)
				SET LIST ITEM PARAMETER:C986($hlistref; $ref; "ref"; $para)
				
				If ($field.indexed)
					SET LIST ITEM PROPERTIES:C386($hlistref; $ref; False:C215; Bold:K14:2; "path:/RESOURCES/Images/Field_"+String:C10($field.type)+".png")
				Else 
					SET LIST ITEM PROPERTIES:C386($hlistref; $ref; False:C215; Plain:K14:1; "path:/RESOURCES/Images/Field_"+String:C10($field.type)+".png")
				End if 
			End if 
		End if 
	End for each 
	
	
	
Function _getTableMenu($fieldlist : Collection; $level : Integer; $tablename : Text; $structureTablename : Text)->$menuref : Text
	var $txt_suffix : Text:=Choose:C955((FORM Get color scheme:C1761="dark"); "_dark"; "")
	$menuref:=Create menu:C408
	var $id : Integer
	var $field : Object
	For each ($field; $fieldlist)
		Case of 
			: ($field.type=Is alpha field:K8:1)
				$id:=1
			: ($field.type=Is text:K8:3)
				$id:=2
			: ($field.type=Is date:K8:7)
				$id:=3
			: ($field.type=Is time:K8:8)
				$id:=4
			: ($field.type=Is boolean:K8:9)
				$id:=5
			: ($field.type=Is integer:K8:5)
				$id:=6
			: ($field.type=Is longint:K8:6)
				$id:=7
			: ($field.type=Is integer 64 bits:K8:25)
				$id:=8
			: ($field.type=Is real:K8:4)
				$id:=9
			: ($field.type=Is BLOB:K8:12)
				$id:=11
			: ($field.type=Is picture:K8:10)
				$id:=12
			: (($field.type=Is object:K8:27) & ($field.kind="relatedEntity"))
				If ($level<3)
					$id:=13
				Else 
					$id:=-1
				End if 
			: ($field.type=Is object:K8:27)
				$id:=14
			: ($field.type=Is subtable:K8:11)
				$id:=-1
			: ($field.type=42)  // relation many
				If ($level<3)
					$id:=13
				End if 
			Else 
				$id:=-1
		End case 
		var $subfieldlist : Collection
		var $subname : Text
		If (($id>=0) && ($id#11) && ($id#12) && ($id#14))
			If (($id=13) && ($field.relatedDataClass#Null:C1517))  // relation many to one
				If (($field.relatedDataClass.getInfo().name#This:C1470.table.getInfo().name) && \
					($field.relatedDataClass.getInfo().name#$structureTablename))  // not going back to ourself...
					If ($tablename#"")
						$subfieldlist:=This:C1470._getDSClassDetails($field.relatedDataClass; $tablename+"."+$field.name)
					Else 
						$subfieldlist:=This:C1470._getDSClassDetails($field.relatedDataClass; $field.name)
					End if 
					$subname:=$field.name  //displayName
					If ($tablename#"")
						$subname:=$tablename+"."+$subname
					End if 
					var $submenu : Text:=This:C1470._getTableMenu($subfieldlist; $level+1; $subname; $field.relatedDataClass.getInfo().name)
					This:C1470.popupsubmenu.push($submenu)
					INSERT MENU ITEM:C412($menuref; -1; $field.displayName; $submenu)
				End if 
			Else 
				INSERT MENU ITEM:C412($menuref; -1; $field.displayName)
				If ($level>0)
					SET MENU ITEM PARAMETER:C1004($MenuRef; -1; $tablename+"."+$field.name)
				Else 
					SET MENU ITEM PARAMETER:C1004($MenuRef; -1; $field.name)
				End if 
			End if 
			SET MENU ITEM ICON:C984($MenuRef; -1; "Path:/RESOURCES/Query/Field_"+String:C10($id)+$txt_suffix+".png")
			If ($field.indexed)
				SET MENU ITEM STYLE:C425($menuref; -1; Bold:K14:2)
			End if 
		End if 
	End for each 
	
	
Function _getDSClassDetails($class : 4D:C1709.DataClass; $relatedTableName : Text)->$fields : Collection
	var $fieldnames : Collection:=OB Keys:C1719($class)
	var $field : Text
	var $f : Object
	
	$fields:=New collection:C1472
	
	For each ($field; $fieldnames)
		$f:=$class[$field]
		var $data : Object:=New object:C1471("name"; $field; \
			"kind"; $f.kind; \
			"type"; $f.fieldType; \
			"indexed"; $f.indexed; \
			"relatedDataClass"; ds:C1482[String:C10($f.relatedDataClass)])
		
		var $searchforName : Text
		If (This:C1470.virt_fieldllist#Null:C1517)
			If ($relatedTableName#"")
				$searchforName:=$relatedTableName+"."+$field
			Else 
				$searchforName:=$field
			End if 
			var $virt : Collection:=This:C1470.virt_fieldllist.query("structure=:1"; $searchforName)
			If ($virt.length>0)
				$data.displayName:=$virt[0].display
				$fields.push($data)
			End if 
		Else 
			$data.displayName:=$data.name
			$fields.push($data)
		End if 
	End for each 
	
	