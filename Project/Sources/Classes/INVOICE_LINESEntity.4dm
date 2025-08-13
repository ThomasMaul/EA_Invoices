Class extends Entity

Function get TotalWithTax->$result : Real
	$result:=This:C1470.Total+This:C1470.TotalTax
	
local Function event touched($event : Object)
	If (This:C1470.DiscountRate#0)
		This:C1470.Total:=Round:C94(This:C1470.ProductUnitPrice*This:C1470.Quantity*(1-(This:C1470.DiscountRate/100)); 2)
	Else 
		This:C1470.Total:=This:C1470.ProductUnitPrice*This:C1470.Quantity
	End if 
	
	// Calculate the total tax per line item
	This:C1470.TotalTax:=This:C1470.Total*(This:C1470.ProductTaxRate/100)
	
	