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
					File:C1566("/LOGS/Setup/Explorer/"+$tablename+".myPrefs").setText(JSON Stringify:C1217($object))
					
				: ($select=3)  // clear
					File:C1566("/LOGS/Setup/Explorer/"+$tablename+".myPrefs").delete()
					
				: ($select>4)
					$col:=Split string:C1554($popup; ";")
					var $title : Text:=$col[$select-1]
					LISTBOX INSERT COLUMN FORMULA:C970(*; "Listbox"; $event.column+1; $title; "this."+$title; Is text:K8:3; $title; $nullpointer)
					OBJECT SET TITLE:C194(*; $title; $title)
					Form:C1466.ORDA_listbox._columnwidths.insert($event.column; 50)
					Form:C1466.ORDA_listbox.resize()
			End case 
		End if 
		
	: ($event.code=On Selection Change:K2:29)
		If (Form:C1466.preview.data#Null:C1517)
			If (Form:C1466.preview.data.touched())
				C_COLLECTION:C1488($touchedAttributes)
				$touchedAttributes:=Form:C1466.preview.data.touchedAttributes()
				var $check : Boolean:=True:C214
				
				If ($check)
					CONFIRM:C162(Get localized string:C991("SaveChanges"))
					If (OK=1)
						C_OBJECT:C1216($status)
						$status:=Form:C1466.preview.data.save(dk auto merge:K85:24)
						Case of 
							: ($status.success)
								// nichts, also passt!
							: ($status.status=dk status automerge failed:K85:25)
								ALERT:C41(Get localized string:C991("SomebodyElseChanged"))
							: ($status.status=dk status locked:K85:21)
								var $user : Text:=$status.lockInfo.user_name+"/"+$status.lockInfo.host_name+"/"+$status.lockInfo.task_name
								CONFIRM:C162(Get localized string:C991("RecordLockedFrom")+$user; Get localized string:C991("LockedWait"); Get localized string:C991("LockedCancel"))
								If (OK=1)
									LISTBOX SELECT ROW:C912(*; "Listbox"; Num:C11(Form:C1466.preview.Position); lk replace selection:K53:1)
									Form:C1466.SelectedElement:=Form:C1466.preview.data
								Else 
								End if 
						End case 
					End if 
				End if 
			End if 
		End if 
		Form:C1466.preview.data:=Form:C1466.SelectedElement
		Form:C1466.preview.Position:=Form:C1466.SelectedPosition
		EXECUTE METHOD IN SUBFORM:C1085("preview"; Formula:C1597(ORDA_Listbox_Method("preview")))
		
	: ($event.code=On Double Clicked:K2:5)
		If (Form:C1466.SelectedElement.getKey(dk key as string:K85:16)#"")
			ORDA_Listbox_Method("doubleclick")
		End if 
		
End case 