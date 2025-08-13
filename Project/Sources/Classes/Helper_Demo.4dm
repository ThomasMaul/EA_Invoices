// this class helps to build the demo
// it provides automatic test data creation

property LogoPict : Picture
property ProductPict : Picture

Class constructor()
	var $pict : Picture
	
	var $path : Text:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Logo.jpg"
	READ PICTURE FILE:C678($path; $pict)
	This:C1470.LogoPict:=$pict
	
	$path:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Product.jpg"
	READ PICTURE FILE:C678($path; $pict)
	This:C1470.ProductPict:=$pict
	
	
Function buildDemoData()->$error
	$error:=""
	
	var $clientsFile:=Localized document path:C1105("Clients.txt")
	
	If (Test path name:C476($clientsFile)=Is a document:K24:1)
		var $importOk:=True:C214
	Else 
		$clientsFile:=Get 4D folder:C485(Current resources folder:K5:16)+"en.lproj"+Folder separator:K24:12+"Clients.txt"
		If (Test path name:C476($clientsFile)=Is a document:K24:1)
			$importOk:=True:C214
		Else 
			$importOk:=False:C215
		End if 
	End if 
	
	If ($importOk)
		ds:C1482.startTransaction()
		
		//MARK: Clients
		If (ds:C1482.PRODUCTS.getCount()=0)
			var $doccontent:=File:C1566($clientsFile; fk platform path:K87:2).getText()
			var $lines : Collection:=Split string:C1554($doccontent; Char:C90(10))
			var $line : Text
			For each ($line; $lines)
				var $cells : Collection:=Split string:C1554($line; Char:C90(9))
				If ($cells.length>=10)
					var $client:=ds:C1482.CLIENTS.new()
					$client.Name:=$cells[0]
					$client.Address1:=$cells[1]
					$client.City:=$cells[2]
					$client.State:=$cells[3]
					$client.ZipCode:=$cells[4]
					$client.Country:=$cells[5]
					$client.Phone:=$cells[6]
					$client.Mobile:=$cells[7]
					$client.Fax:=$cells[8]
					$client.Email:=$cells[9]
					$client.Contact:=$cells[10]
					var $random : Integer:=(Random:C100%(10-1+1))+1
					$client.WebSite:=Choose:C955((Random:C100%(10-1+1))+1; "It is one of the best"; \
						"Very honest"; "To recontact"; "To be more explicit"; "Very good and correct client"; \
						"It is one of the bigest"; "Very good client"; "Usually it is late in payments"; \
						"Nice to do business with him"; "Very interesting client")
					$client.WebSite:="www."+$client.Name+".com"
					$client.Logo:=This:C1470._CreateLogo()
					$client.save()
				End if 
			End for each 
		End if 
		
		//MARK:Products
		If (ds:C1482.PRODUCTS.getCount()=0)
			var $TypeStylo:=["Multifonction"; "Plume"; "Bille"; "Roller"]
			var $MarqueStylo:=["Potter"; "Weasley"; "Rogue"; "Voldermont"; "Granger"; "Dumbledore"]
			var $ColorStylo:=["Black"; "Red"; "Bright Red"; "Blue"; "Bright Blue"; "Yellow"; "Bright Yellow"; "Green"; "Bright Green"; "White"]
			
			var $productNumber:=0
			var $Type; $Marque; $Color : Text
			For each ($Type; $TypeStylo)
				For each ($Marque; $MarqueStylo)
					For each ($Color; $ColorStylo)
						$productNumber+=1
						var $product:=ds:C1482.PRODUCTS.new()
						$product.Reference:=Uppercase:C13(Substring:C12($Type; 1; 3)+Substring:C12($Marque; 1; 3)+Substring:C12($Color; 1; 3)+String:C10($productNumber; "0000"))
						$product.Name:="Stylo "+$Type+" "+$Marque+" "+$Color
						$product.UnitPrice:=((Random:C100%(10-1+1))+1)*5
						$product.TaxRate:=Storage:C1525.company.VAT_Rate  // Set in On Startup
						$product.Picture:=This:C1470._CreateProductPict()
						$product.save()
					End for each 
				End for each 
			End for each 
		End if 
		
		
		//MARK:General
		If (ds:C1482.SETTINGS.getCount()=0)
			var $settings:=ds:C1482.SETTINGS.new()
			
			$settings.CustomFields_:={Tables: [\
				{name: "CLIENTS"; fields: [{name: "VAT Code"}]}; \
				{name: "INVOICES"; fields: [{name: "Customer Order Code"}]}]}
			// as an example to activate custom fields
			$settings.save()
		End if 
		
		//MARK:Invoices
		If (ds:C1482.INVOICES.getCount()=0)
			var $products:=ds:C1482.PRODUCTS.all().extract("ID")  // collection with all product IDs, used to create invoice lines
			For each ($client; ds:C1482.CLIENTS.all())
				var $j : Integer
				For ($j; 1; ((Random:C100%(20-1+1))+1))  // between 1 and 20 Invoices per Client
					var $invoice:=ds:C1482.INVOICES.new()
					var $num:=ds:C1482.SETTINGS.getNextInvoiceNumber()
					If ($num=0)
						ALERT:C41("Settings Table locked, Creation of Invoice Number not possible, Creation of data canceled...")
						ds:C1482.cancelTransaction()
						return 
					End if 
					$invoice.InvoiceNumber:="INV"+String:C10($num)
					$invoice.Client_ID:=$client.ID
					$invoice.Date:=Current date:C33-60+((Random:C100%(59-1+1))+1)
					$invoice.PaymentDelay:=30
					$invoice.Paid:=(((Random:C100%(1-0+1))+1)=1)
					If ($invoice.Paid)
						var $diff:=Current date:C33-$invoice.Date
						$invoice.PaymentDate:=Current date:C33-$diff+((Random:C100%($diff-2+1))+1)
						$random:=(Random:C100%(3-1+1))+1
						$invoice.PaymentMethod:=Choose:C955($random; "By check"; "By credit card"; "By bank transfer")
						$invoice.PaymentReference:="ID: "+String:C10($client.ID; "0000")+String:C10($j; "0000")+String:C10($client.ID; "000")+String:C10($j; "000")
					End if 
					// Invoice Lines
					var $k : Integer
					For ($k; 1; ((Random:C100%(20-1+1))+1))
						var $invoiceLine:=ds:C1482.INVOICE_LINES.new()
						$invoiceLine.Invoice_ID:=$invoice.ID
						$product:=ds:C1482.PRODUCTS.get($products[(Random:C100%($products.length))])
						$invoiceLine.Product_ID:=$product.ID
						$invoiceLine.ProductReference:=$product.Reference
						$invoiceLine.ProductName:=$product.Name
						$invoiceLine.Quantity:=Random:C100%(10)+1
						$invoiceLine.ProductUnitPrice:=$product.UnitPrice
						$invoiceLine.DiscountRate:=Random:C100%(11)
						$invoiceLine.ProductTaxRate:=$product.TaxRate
						$invoiceLine.save()  // totals calculated in $invoiceLine event
					End for 
					
					$invoice.updateTotals()
					$invoice.save()
				End for 
			End for each 
		End if 
		
		//MARK:Document Templates tables
		If (ds:C1482.Document_Templates.getCount()=0)
			var $docpath : Text:=Get 4D folder:C485(Current resources folder:K5:16)+"en.lproj"+Folder separator:K24:12+"DocumentTemplates_Demo.4ie"
			var $formatpath : Text:=Get 4D folder:C485(Current resources folder:K5:16)+"en.lproj"+Folder separator:K24:12+"DocumentTemplates_DemoFormat.4si"
			If ((Test path name:C476($docpath)=Is a document:K24:1) && (Test path name:C476($formatpath)=Is a document:K24:1))
				var $projectText:=Document to text:C1236($formatpath)
				IMPORT DATA:C665($docpath; $projectText)
			End if 
		End if 
		
		ds:C1482.validateTransaction()
		
	Else 
		return "Unable to find the import files, the database remains empty"
	End if 
	
Function _CreateLogo() : Picture
	return This:C1470._ProduceRandomPict(This:C1470.LogoPict)
	
Function _CreateProductPict() : Picture
	return This:C1470._ProduceRandomPict(This:C1470.ProductPict)
	
Function _ProduceRandomPict($logo : Picture) : Picture
	var $width; $height : Integer
	PICTURE PROPERTIES:C457($Logo; $width; $height)
	TRANSFORM PICTURE:C988($Logo; Crop:K61:7; Random:C100%($width-256); Random:C100%($height-256); 256; 256)
	CONVERT PICTURE:C1002($Logo; ".jpg"; 0.5)
	return $Logo
	
	