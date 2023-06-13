//%attributes = {}
If (False:C215)  // use Quick Report
	USE ENTITY SELECTION:C1513(Form:C1466.displayedSelection)
	QR REPORT:C197((Form:C1466.dataClassPtr)->; Char:C90(1))
Else 
	// use 4D View Pro
	$data:=New object:C1471("table"; Form:C1466.dataClassName; "masterform"; Form:C1466)
	If (Form:C1466.selectedSubset.length>0)  // if some records are selected, we use those, else all
		$data.data:=Form:C1466.selectedSubset
	Else 
		$data.data:=Form:C1466.displayedSelection
	End if 
	$win:=Open form window:C675("ViewProReport")
	DIALOG:C40("ViewProReport"; $data; *)
	
End if 