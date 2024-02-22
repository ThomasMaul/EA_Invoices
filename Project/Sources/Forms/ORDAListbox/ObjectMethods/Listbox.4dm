var $event : Object:=FORM Event:C1606
Case of 
	: ($event.code=On Header Click:K2:40)
		If (Right click:C712)
			var $popup : Text:=Get localized string:C991("ColumnRightClick")
			var $table : 4D:C1709.DataClass:=Form:C1466.listbox.getDataClass()
			var $tablename : Text:=$table.getInfo().name
			var $nullpointer : Pointer
			
			// build list of missing fields...
			// first existing fields
			LISTBOX GET ARRAYS:C832(*; $event.objectName; $arrSpaNamen; $arrKopfNamen; $arrSpaVars; $arrKopfVars; $arrSpaSichtbar; $arrStile)
			var $field : Text
			For each ($field; $table)
				var $pos : Integer:=Find in array:C230($arrSpaNamen; $field)
				If ($pos<0)
					$popup:=$popup+$field+";"
				End if 
			End for each 
			
			var $select : Integer:=Pop up menu:C542($popup)
			
			Case of 
				: ($select=1)
					LISTBOX DELETE COLUMN:C830(*; $event.objectName; $event.column)
					
				: ($select=2)  // save
					var $object : Object:=New object:C1471("table"; $tablename)
					var $col : Collection:=New collection:C1472
					LISTBOX GET ARRAYS:C832(*; $event.objectName; $arrSpaNamen; $arrKopfNamen; $arrSpaVars; $arrKopfVars; $arrSpaSichtbar; $arrStile)
					var $i : Integer
					For ($i; 1; Size of array:C274($arrSpaNamen))
						var $formula : Text:=LISTBOX Get column formula:C1202(*; $arrSpaNamen{$i})
						var $width : Integer:=LISTBOX Get column width:C834(*; $arrSpaNamen{$i})
						$col.push(New object:C1471("pos"; $i; "formula"; $formula; "width"; $width; "title"; $arrKopfNamen{$i}))
					End for 
					$object.columns:=$col
					var $created : 4D:C1709.File:=File:C1566("/LOGS/Setup/Explorer/"+$tablename+".myPrefs").setText(JSON Stringify:C1217($object))
					
				: ($select=3)  // clear
					File:C1566("/LOGS/Setup/Explorer/"+$tablename+".myPrefs").delete()
					
				: ($select>4)
					$col:=Split string:C1554($popup; ";")
					var $title : Text:=$col[$select-1]
					LISTBOX INSERT COLUMN FORMULA:C970(*; "Listbox"; $event.column+1; $title; "this."+$title; Is text:K8:3; $title; $nullpointer)
					OBJECT SET TITLE:C194(*; $title; $title)
			End case 
		End if 
End case 