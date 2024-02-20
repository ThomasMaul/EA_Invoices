Class constructor
	This:C1470.buttons:=New collection:C1472
	This:C1470.subformName:=""
	
Function add($button : cs:C1710.Toolbar_Button)
	// add a button instance to the toolbar
	
	$button.check()
	If ($button.order=0)
		$button.order:=This:C1470.buttons.length
	End if 
	This:C1470.buttons.push($button)
	
Function getSubform($objectname : Text)->$subform : Object
	// return the button bar as a subform to be embedded. $1 = name of subform area
	
	var $buttondistance : Integer:=10
	var $groupdistance : Integer:=5  // also in curWidth
	var $y_start : Integer:=2
	var $y_smallbuttondistance : Integer:=20
	
	If (This:C1470.buttons.length>0)
		If (String:C10(This:C1470.subformName)="")
			ASSERT:C1129($objectname#""; "Subform Object name must not be empty")
			This:C1470.subformName:=$objectname
		End if 
		
		var $left; $top; $right; $bottom : Integer
		OBJECT GET COORDINATES:C663(*; This:C1470.subformName; $left; $top; $right; $bottom)
		var $width : Integer:=$right-$left
		var $curWidth : Integer:=This:C1470._buttonsCurWidth()
		
		Case of 
			: ($curWidth<$width)  // we have more size, maybe we can grow something?
				This:C1470._enlargeWidthTo($width; $curWidth)
				
			: ($curWidth>$width)  // oops, smaller, we need to shrink
				This:C1470._reduceWidthTo($width; $curWidth)
		End case 
		
		var $page : Object:=New object:C1471()
		var $x : Integer:=$buttondistance
		var $y : Integer:=$y_start
		
		var $buttons : Collection:=This:C1470.buttons.orderBy("order asc")
		var $curGroup : Text:=""
		var $lastbuttonsmall : Boolean:=False:C215
		var $lastbuttonwidth : Integer:=0
		var $button : Object
		For each ($button; $buttons)
			// add vertical bar if new group
			var $newgroup : Text:=String:C10($button.group)
			If (($newgroup#"") & ($curGroup#"") & ($curGroup#$newgroup))
				var $line : Object
				$line:=New object:C1471("type"; "line"; "top"; 1; "left"; $x-5; "height"; 90; "stroke"; "#A8A8A8")
				$page[$newgroup]:=$line
				$x:=$x+$groupdistance
				$lastbuttonsmall:=False:C215
			End if 
			$curGroup:=$newgroup
			
			If (($button.status=2) & ($lastbuttonsmall))
				$x:=$x-$lastbuttonwidth
				$page[$button.name]:=$button.render($x; $y+$y_smallbuttondistance; ->$lastbuttonsmall)
				$lastbuttonsmall:=False:C215
			Else 
				$page[$button.name]:=$button.render($x; $y; ->$lastbuttonsmall)
			End if 
			
			$x:=$x+Num:C11($button.curWidth)+$buttondistance
			$lastbuttonwidth:=Num:C11($button.curWidth)+$buttondistance
		End for each 
		
		This:C1470.maxWidth:=$x
		
		// "method";"Toolbar_FormMethod";
		$subform:=New object:C1471("windowSizingX"; "variable"; "windowSizingY"; "variable"; "rightMargin"; 1; "bottomMargin"; 1; "windowMinWidth"; 0; "windowMinHeight"; 0; \
			"windowMaxWidth"; 32767; "windowMaxHeight"; 32767; \
			"events"; New collection:C1472("onResize"; "onLoad"); \
			"pages"; New collection:C1472(Null:C1517; New object:C1471("objects"; $page)); "destination"; "detailScreen")
		
		
	Else 
		$subform:=New object:C1471
	End if 
	
Function resize
	// respond do a resize of the displayed area, recalculates the toolbar and assign it
	
	var $sub : Object
	var $left; $top; $right; $bottom : Integer
	OBJECT GET COORDINATES:C663(*; This:C1470.subformName; $left; $top; $right; $bottom)
	var $x : Integer:=$right-$left
	If (Num:C11(This:C1470.maxWidth)#0)
		//If ((($x+5)<This.maxWidth) | (($x-5)>This.maxWidth))
		// now redraw buttons if not enough space
		$sub:=This:C1470.getSubform()
		var $hash : Text:=This:C1470._getHash($sub)
		If (String:C10(This:C1470.lastHash)#$hash)
			This:C1470.lastHash:=$hash
			OBJECT SET SUBFORM:C1138(*; String:C10(This:C1470.subformName); $sub)
		End if 
		//End if 
	End if 
	
Function _getHash($ob : Object)->$hash : Text
	var $json : Text
	// internal. Create a hash for the subform rendering, to check if content was changed (because resize) and new display is needed
	
	$json:=JSON Stringify:C1217($ob)
	$hash:=Generate digest:C1147($json; MD5 digest:K66:1)
	
Function _buttonsCurWidth->$width : Integer
	// internal. Calculates the current width of a button
	
	var $groupdistance : Integer:=10
	var $totalWidth : Integer:=0
	var $lastgroup : Text:=""
	var $groupcounter : Integer:=0
	var $button : Object
	For each ($button; This:C1470.buttons)
		$totalWidth:=$totalWidth+$button.widths[$button.status]
		If ($button.widths[$button.status]#0)
			$totalWidth:=$totalWidth+10  // distance between buttons
		End if 
		If ($lastgroup#String:C10($button.group))
			$lastgroup:=String:C10($button.group)
			$groupcounter:=$groupcounter+1
		End if 
	End for each 
	$width:=$totalWidth+($groupcounter*$groupdistance)
	
Function _reduceWidthTo($requestedWidth : Integer; $currentWidth : Integer)
	// internal. Try to reduce the width of a button to the requested size
	var $safetycounter : Integer:=1000
	
	// first remove title
	While (($currentWidth>=$requestedWidth) & ($safetycounter>0))
		// start with lowestest priority from right
		var $bigbuttons : Object:=This:C1470.buttons.query("status=0 and title # ''").orderBy("Prio desc, order desc")
		If ($bigbuttons.length=0)
			$safetycounter:=0
		Else 
			$bigbuttons[0].setStatus(1)
		End if 
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	
	// next try to use 16 icons
	$safetycounter:=1000
	While (($currentWidth>=$requestedWidth) & ($safetycounter>0))
		// start with lowestest priority from right
		$bigbuttons:=This:C1470.buttons.query("status<2 and icon16 # ''").orderBy("Prio desc, order desc")
		If ($bigbuttons.length=0)
			$safetycounter:=0
		Else 
			$bigbuttons[0].setStatus(2)
		End if 
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	
Function _enlargeWidthTo($requestedWidth : Integer; $currentWidth : Integer)
	// internal. Try to enlarge the button up to requested width
	var $safetycounter : Integer:=1000
	
	// try larger icon without title
	While (($currentWidth<=$requestedWidth) & ($safetycounter>0))
		// start with highest priority from left
		var $smallbuttons : Collection:=This:C1470.buttons.query("status>=2").orderBy("Prio asc, order asc")
		If ($smallbuttons.length=0)
			$safetycounter:=0
		Else 
			$smallbuttons[0].setStatus(1)  // make it big
		End if 
		
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		// double check
		If ($currentWidth>$requestedWidth)
			If ($smallbuttons.length#0)
				$smallbuttons[0].setStatus(2)  // make it small again...
			End if 
		End if 
		
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	
	$safetycounter:=1000
	// try to add title
	While (($currentWidth<=$requestedWidth) & ($safetycounter>0))
		// start with highest priority from left
		$smallbuttons:=This:C1470.buttons.query("status=1").orderBy("Prio asc, order asc")
		If ($smallbuttons.length=0)
			$safetycounter:=0
		Else 
			$smallbuttons[0].setStatus(0)  // make it big
		End if 
		
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		// double check
		If ($currentWidth>$requestedWidth)
			If ($smallbuttons.length#0)
				$smallbuttons[0].setStatus(1)  // make it small again...
			End if 
		End if 
		
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	
Function CreateButton($name : Text; $group : Integer; $prio : Integer; $separator : Boolean; $title : Text)->$button : cs:C1710.Toolbar_Button
	If ($title="")
		$title:=$name
	End if 
	