// user enters a new product reference
// see if we find exactly this reference
var $products:=ds:C1482.PRODUCTS.query("Reference=:1"; Form:C1466.curLine.ProductReference)
Case of 
	: ($products.length=1)
		// we found them, we do that later
	: ($products.length=0)
		// if not, let's try with wildcard
		$products:=ds:C1482.PRODUCTS.query("Reference=:1"; Form:C1466.curLine.ProductReference+"@")
	Else 
		// we might already have more than 1, user entered wildcard
End case 

Case of 
	: ($products.length=1)
		// we found them, we do that later
	: ($products.length=0)
		// we found none!
		BEEP:C151
		Form:C1466.curLine.ProductName:=""
		Form:C1466.curLine.Quantity:=0
		Form:C1466.curLine.Product_ID:=0
		EDIT ITEM:C870(*; "invoiceLineReference")
	Else 
		// more than one, so let's open a popup to select
		var $subdata:={data: $products; Selected: Null:C1517}
		var $mouseX; $mouseY; $button; $oldPos : Integer
		$oldPos:=FORM Event:C1606.row
		MOUSE POSITION:C468($mouseX; $mouseY; $button)
		var $win:=Open form window:C675([PRODUCTS:4]; "PopupForm"; Pop up form window:K39:11; $mouseX; $mouseY)
		DIALOG:C40([PRODUCTS:4]; "PopupForm"; $subdata)
		If ($subdata.Selected#Null:C1517)
			// take the selected
			Form:C1466.curLine.ProductReference:=$subdata.Selected.Reference
			Form:C1466.curLine.ProductName:=$subdata.Selected.Name
			If (Form:C1466.curLine.Quantity=0)  // keep already entered data when changing product
				Form:C1466.curLine.Quantity:=1
			End if 
			Form:C1466.curLine.Product_ID:=$subdata.Selected.ID
			Form:C1466.curLine.ProductUnitPrice:=$subdata.Selected.UnitPrice
			Form:C1466.curLine.ProductTaxRate:=$subdata.Selected.TaxRate
		Else 
			Form:C1466.curLine.ProductName:=""
			Form:C1466.curLine.ProductUnitPrice:=0
			Form:C1466.curLine.ProductTaxRate:=0
			EDIT ITEM:C870(*; "invoiceLineReference"; $oldPos)
		End if 
End case 

If ($products.length=1)
	// yep, let's go
	var $product:=$products.first()
	Form:C1466.curLine.ProductName:=$product.Name
	Form:C1466.curLine.Quantity:=0
	Form:C1466.curLine.Product_ID:=$product.ID
End if 

Form:C1466.data.updateTotals()