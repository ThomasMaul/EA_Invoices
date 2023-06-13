$helper:=cs:C1710.Helper_Invoices.new(Form:C1466.editEntity)

PRINT SETTINGS:C106
If (OK=1)
	$helper.print_color()
End if 