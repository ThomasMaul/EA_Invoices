Class constructor($pictpath : Text)
	This:C1470.pictpath:=$pictpath
	This:C1470.list:=New list:C375
	SET LIST PROPERTIES:C387(This:C1470.list; 0; 0; 38)
	This:C1470.buttons:=New collection:C1472
	
Function clear
	CLEAR LIST:C377(This:C1470.list; *)
	
Function assign($objectname : Text)
	OBJECT Get pointer:C1124(Object named:K67:5; $objectname)->:=This:C1470.list
	
	
Function add($name : Text; $id : Integer; $pictname : Text; $title : Text)
	var $newbutton : Object
	
	$newbutton:=New object:C1471("name"; $name; "id"; $id; "pictname"; $pictname)
	If (Count parameters:C259<4)
		$newbutton.title:=$name
	Else 
		If ($title#"")
			$newbutton.title:=$title
		Else 
			$newbutton.title:=$name
		End if 
	End if 
	var $pict : Picture
	If (Test path name:C476(This:C1470.pictpath+$pictname)=Is a document:K24:1)
		READ PICTURE FILE:C678(This:C1470.pictpath+$pictname; $pict)
	Else 
		READ PICTURE FILE:C678(This:C1470.pictpath+"Star_32.png"; $pict)
		$newbutton.pictname:="Star_32.png"
	End if 
	TRANSFORM PICTURE:C988($pict; Crop:K61:7; 0; 0; 32; 32)
	$newbutton.icon:=$pict
	
	If ($id>1000)  // subitem
		var $masterid : Integer:=$id\1000
		$newbutton.masterid:=$masterid
		C_TEXT:C284($text)
		C_LONGINT:C283($sublist; $ref)
		C_BOOLEAN:C305($xpand)
		SELECT LIST ITEMS BY REFERENCE:C630(This:C1470.list; $masterid)
		GET LIST ITEM:C378(This:C1470.list; *; $ref; $text; $sublist; $xpand)
		If ($sublist=0)
			$sublist:=New list:C375
			SET LIST ITEM:C385(This:C1470.list; $masterid; $text; $masterid; $sublist; True:C214)
		End if 
		APPEND TO LIST:C376($sublist; $name; $id)
		SET LIST ITEM ICON:C950($sublist; $id; $pict)
		SET LIST ITEM PARAMETER:C986($sublist; $id; "name"; $name)
	Else 
		APPEND TO LIST:C376(This:C1470.list; $name; $id)
		SET LIST ITEM ICON:C950(This:C1470.list; $id; $pict)
		SET LIST ITEM PARAMETER:C986(This:C1470.list; $id; "name"; $name)
	End if 
	
	This:C1470.buttons.push($newbutton)
	
Function startDrag()
	ARRAY LONGINT:C221($arrPos; 0)
	var $vlItemPos : Integer:=Selected list items:C379(This:C1470.list; $arrPos)
	If (Size of array:C274($arrPos)=1)
		GET LIST ITEM:C378(This:C1470.list; *; $ref; $text; $sublist; $xpand)
		var $value : Text:=JSON Stringify:C1217(New object:C1471("id"; $ref))
	Else 
		var $sel : Collection:=New collection:C1472
		var $i; $ref; $sublist : Integer
		var $text : Text
		var $xpand : Boolean
		For ($i; 1; Size of array:C274($arrPos))
			GET LIST ITEM:C378(This:C1470.list; $arrPos{$i}; $ref; $text; $sublist; $xpand)
			If ($ref<1000)  // for multiple selection, we only take top level
				$sel.push($ref)
			End if 
		End for 
		If ($sel.length=0)  // maybe there were only second level?
			For ($i; 1; Size of array:C274($arrPos))
				GET LIST ITEM:C378(This:C1470.list; $arrPos{$i}; $ref; $text; $sublist; $xpand)
				If ($ref>=1000)  // for multiple selection, we only take top level
					$sel.push($ref)
				End if 
			End for 
		End if 
		$value:=JSON Stringify:C1217(New object:C1471("ids"; $sel))
	End if 
	SET TEXT TO PASTEBOARD:C523($value)
	
Function acceptDrop()->$return : Integer
	$return:=0
	var $value : Text:=Get text from pasteboard:C524
	var $data : Object:=JSON Parse:C1218($value)
	If (($data.id#Null:C1517) | ($data.ids#Null:C1517))
		var $droppos : Integer:=Drop position:C608
		var $beforeref : Integer:=0
		If ($droppos=-1)
			$beforeref:=0
		Else 
			GET LIST ITEM:C378(Form:C1466.userlist; $droppos; $beforeref; $beforetext)
			// check for toplevel, we don't accept drop inside a sublevel
			var $parent : Integer:=List item parent:C633(Form:C1466.userlist; $beforeref)
			If ($parent#0)
				$beforeref:=$parent
			End if 
		End if 
		
		If ($data.id#Null:C1517)
			This:C1470._acceptDropSingleButton($data.id; $beforeref)
		Else 
			If ($data.ids#Null:C1517)
				var $sel : Collection:=$data.ids
				// we need to loop backwards, as we always insert before
				var $i : Integer
				For ($i; $sel.length-1; 0; -1)
					This:C1470._acceptDropSingleButton($sel[$i]; $beforeref)
				End for 
			End if 
		End if 
		
	Else 
		$return:=-1
	End if 
	
Function _acceptDropSingleButton($id : Integer; $parabeforeref : Integer)
	var $beforeref : Integer
	$beforeref:=$parabeforeref
	var $button : Object:=This:C1470.getButtonInfo($id)
	If ($button#Null:C1517)
		// subbutton/hierarchy
		var $buttons : Collection:=This:C1470.getSubButtonInfos($id)
		
		If ($buttons.length>0)
			var $sublist : Integer:=New list:C375
			var $subbutton : Object
			For each ($subbutton; $buttons)
				var $ref : Integer:=$subbutton.id
				If ($ref>0)
					$beforeref:=This:C1470.findNextButton($ref; $beforeref)
					This:C1470.deleteExistingEntryUserList($ref)
				Else 
					$ref:=-(Count list items:C380(Form:C1466.userlist; *))
				End if 
				var $name : Text:=$subbutton.name
				APPEND TO LIST:C376($sublist; $name; $ref)
				If ($subbutton.icon#Null:C1517)
					$pict:=$subbutton.icon
					SET LIST ITEM ICON:C950($sublist; $ref; $pict)
				End if 
				SET LIST ITEM PARAMETER:C986($sublist; $ref; "name"; $name)
			End for each 
		Else 
			$sublist:=0
		End if 
		
		$ref:=$id
		If (($ref>0) | ($ref<-1))
			//If ($beforeref#0)
			//$beforeref:=This.findNextButton($ref; $beforeref)
			//End if 
			This:C1470.deleteExistingEntryUserList($ref)
		Else 
			$ref:=-(Count list items:C380(Form:C1466.userlist; *))
		End if 
		$name:=$button.name
		If ($beforeref=0)
			If ($sublist=0)
				APPEND TO LIST:C376(Form:C1466.userlist; $name; $ref)
			Else 
				APPEND TO LIST:C376(Form:C1466.userlist; $name; $ref; $sublist; True:C214)
			End if 
		Else 
			If ($sublist=0)
				INSERT IN LIST:C625(Form:C1466.userlist; $beforeref; $name; $ref)
			Else 
				INSERT IN LIST:C625(Form:C1466.userlist; $beforeref; $name; $ref; $sublist; True:C214)
			End if 
		End if 
		
		If ($button.icon#Null:C1517)
			var $pict : Picture:=$button.icon
			SET LIST ITEM ICON:C950(Form:C1466.userlist; $ref; $pict)
		End if 
		SET LIST ITEM PARAMETER:C986(Form:C1466.userlist; $ref; "name"; $name)
	End if 
	
Function deleteExistingEntryUserList($ref : Integer)
	DELETE FROM LIST:C624(Form:C1466.userlist; $ref; *)
	
Function findNextButton($ref : Integer; $previous : Integer)->$next : Integer
	// finds next button in list, needed when button is to be deleted but used as before drop target
	var $continue : Boolean:=True:C214
	var $count : Integer:=Count list items:C380(Form:C1466.userlist; *)
	var $item : Integer:=1
	$next:=$previous
	While (($continue) & ($item<$count))
		var $vlItemRef : Integer
		var $vsItemText : Text
		GET LIST ITEM:C378(Form:C1466.userlist; $item; $vlItemRef; $vsItemText)
		$item:=$item+1
		If ($vlItemRef=$ref)
			GET LIST ITEM:C378(Form:C1466.userlist; $item; $vlItemRef; $vsItemText)
			$next:=$vlItemRef
		End if 
	End while 
	
	
Function getButtonInfo($id : Integer)->$button : Object
	If ($id<-1)
		$id:=-1
	End if 
	var $buttons : Collection:=This:C1470.buttons.query("id=:1"; $id)
	If ($buttons.length>0)
		$button:=$buttons[0]
	End if 
	
Function getSubButtonInfos($id : Integer)->$buttons : Collection
	$buttons:=This:C1470.buttons.query("masterid=:1"; $id)
	
Function storeSettings()->$userdata : Collection
	var $buttons : Collection:=New collection:C1472
	var $count : Integer:=Count list items:C380(Form:C1466.userlist; *)
	var $i : Integer
	For ($i; $count; 1; -1)
		GET LIST ITEM:C378(Form:C1466.userlist; $i; $beforeref; $beforetext; $sublist; $extended)
		If (($sublist#0) & (Not:C34($extended)))
			SET LIST ITEM:C385(Form:C1466.userlist; $beforeref; $beforetext; $beforeref; $sublist; True:C214)
		End if 
	End for 
	
	$count:=Count list items:C380(Form:C1466.userlist)
	For ($i; 1; $count; 1)
		GET LIST ITEM:C378(Form:C1466.userlist; $i; $beforeref; $beforetext; $sublist; $extended)
		var $parent : Integer:=List item parent:C633(Form:C1466.userlist; $beforeref)
		If ($parent#0)
			var $parentbutton : Collection:=$buttons.query("id=:1"; $parent)
			$parentbutton[0].sub.push(New object:C1471("order"; $i; "id"; $beforeref; "name"; $beforetext))
		Else 
			$buttons.push(New object:C1471("order"; $i; "id"; $beforeref; "name"; $beforetext; "sub"; New collection:C1472))
		End if 
	End for 
	This:C1470.buttons:=$buttons
	$userdata:=$buttons
	
Function setUserSettings($bisher : Collection)
	var $button : Object
	var $masterbuttons : Collection
	For each ($button; $bisher)
		var $sub : Integer:=0
		If ($button.name="Divider")
			$masterbuttons:=This:C1470.buttons.query("name=:1"; $button.name)
		Else 
			$masterbuttons:=This:C1470.buttons.query("id=:1"; $button.id)
		End if 
		If ($masterbuttons.length>0)
			If ($button.sub.length>0)
				$sub:=New list:C375
				var $subbutton : Object
				For each ($subbutton; $button.sub)
					var $name : Text:=$subbutton.name
					var $id : Integer:=$subbutton.id
					APPEND TO LIST:C376($sub; $name; $id)
					var $pict : Picture:=This:C1470.buttons.query("id=:1"; $id)[0].icon
					SET LIST ITEM ICON:C950($sub; $id; $pict)
					SET LIST ITEM PARAMETER:C986($sub; $id; "name"; $name)
				End for each 
				$name:=$button.name
				$id:=$button.id
				APPEND TO LIST:C376(Form:C1466.userlist; $name; $id; $sub; True:C214)
			Else   // no sublist
				$name:=$button.name
				$id:=$button.id
				APPEND TO LIST:C376(Form:C1466.userlist; $name; $id)
			End if 
			$pict:=$masterbuttons[0].icon
			SET LIST ITEM ICON:C950(Form:C1466.userlist; $id; $pict)
			SET LIST ITEM PARAMETER:C986(Form:C1466.userlist; $id; "name"; $name)
		Else   // button existiert nicht mehr?
			// erstmal nichts
		End if 
	End for each 
	
Function buttonsInit
	// init of all available button, used in setup dialog and in display
	var $file : 4D:C1709.File:=Folder:C1567(fk resources folder:K87:11).folder("Settings").folder("Toolbar").file("Buttons.json")
	If (Asserted:C1132($file.exists; "File /Settings/Toolbar/Buttons.json missing"))
		var $buttons : Object:=JSON Parse:C1218($file.getText())
		var $button : Object
		If (Asserted:C1132($buttons.Toolbar#Null:C1517; "Invalid File Content /Settings/Toolbar/Buttons.json"))
			For each ($button; $buttons.Toolbar)
				This:C1470.add($button.name; $button.id; $button.icon)
			End for each 
		End if 
	End if 
	
	
	