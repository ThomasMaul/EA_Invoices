//%attributes = {"invisible":true}
C_TEXT:C284($1; $objectName)

If (Count parameters:C259#0)
	
	$objectName:=$1
	
	If (OBJECT Get type:C1300(*; $objectName)=Object type listbox:K79:8)
		C_LONGINT:C283($logicalWidth)
		ARRAY TEXT:C222($clNames; 0)
		ARRAY TEXT:C222($hdNames; 0)
		ARRAY POINTER:C280($clPtrs; 0)
		ARRAY POINTER:C280($hdPtrs; 0)
		ARRAY BOOLEAN:C223($rwVisibles; 0)
		ARRAY POINTER:C280($rwStyles; 0)
		LISTBOX GET ARRAYS:C832(*; $objectName; $clNames; $hdNames; $clPtrs; $hdPtrs; $rwVisibles; $rwStyles)
		//to avoid the annoying 1 pixel horizontal scroll
		C_TEXT:C284($lastColumnName)
		$lastColumnName:=$clNames{Size of array:C274($clNames)}
		LISTBOX SET COLUMN WIDTH:C833(*; $lastColumnName; 0)
	End if 
	
End if 