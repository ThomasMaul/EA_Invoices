Class extends DataStoreImplementation



// used by ORDAListbox
Function useAll($class : 4D:C1709.DataClass)->$all : 4D:C1709.EntitySelection
	If ($class.useAll#Null:C1517)
		//%W-550.2
		$all:=$class.useAll()
		//%W+550.2
	Else 
		$all:=$class.all()
	End if 
	
Function calcWindowTitle($sel : 4D:C1709.EntitySelection)->$title : Text
	var $class : 4D:C1709.DataClass:=$sel.getDataClass()
	
	If ($class.calcWindowTitle#Null:C1517)
		//%W-550.2
		$title:=$class.calcWindowTitle($sel)
		//%W+550.2
	Else 
		$title:=$class.getInfo().name+"   -   "+String:C10($sel.length)+" von "+String:C10($class.all().length)
	End if 
	
	
	