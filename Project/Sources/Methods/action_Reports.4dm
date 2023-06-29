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
	
	// special behavior for invoices
	If (Form:C1466.dataClassName="Invoices")
		$pop:=Get localized string:C991("INVOICES")+";"+Get localized string:C991("INVOICE_LINES")
		$popup:=Pop up menu:C542($pop)
		If ($popup=2)
			$data.table:="INVOICE_LINES"
			$data.data:=$data.data.Lines_Fm_Invoices
		End if 
	End if 
	
	$win:=Open form window:C675("ViewProReport")
	DIALOG:C40("ViewProReport"; $data; *)
	
End if 