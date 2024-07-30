Class constructor($context : Object; $Write : Object)
	If (Count parameters:C259<2)
		var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='Invoice'")
		If ($templates.length=0)
			//ALERT("Template Invoice is missing")
			// start with an empty one
			This:C1470.WP:=WP New:C1317()
		Else 
			var $template : cs:C1710.Document_Templates
			$template:=$templates.first()
			This:C1470.WP:=$template.WPro
		End if 
	Else 
		This:C1470.WP:=$write
	End if 
	This:C1470.context:=$context
	This:C1470.setContext()
	
Function updateTemplate($templatename : Text)
	var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name=:1"; $templatename)
	If ($templates.length=0)
		Form:C1466.WP:=WP New:C1317()
	Else 
		var $template : cs:C1710.Document_Templates
		$template:=$templates.first()
		This:C1470.WP:=$template.WPro
	End if 
	This:C1470.setContext()
	WPArea:=This:C1470.WP
	
Function updateInvoice($invoice : cs:C1710.INVOICESEntity)
	This:C1470.context.invoice:=$invoice
	This:C1470.setContext()
	
Function setContext($wp : Object)
	If (Count parameters:C259=0)
		$wp:=This:C1470.WP
	End if 
	var $context : Object:=This:C1470.context  // just use the full invoice. We could add more data 
	WP SET DATA CONTEXT:C1786($wp; $context)
	WP COMPUTE FORMULAS:C1707($wp)
	
Function update()
	This:C1470.setContext()
	
Function getPageImages()->$pages : Collection
	var $wp : Object:=This:C1470.WP
	var $pageCount : Integer:=WP Get page count:C1412($wp)
	$pages:=New collection:C1472
	var $options : Object:=New object:C1471
	$options[wk max picture DPI:K81:316]:=300
	var $text : Text
	WP EXPORT VARIABLE:C1319($wp; $text; wk svg:K81:356; $options)
	var $svgRoot : Text:=DOM Parse XML variable:C720($text; False:C215)
	var $preview : Picture
	SVG EXPORT TO PICTURE:C1017($svgRoot; $preview; Own XML data source:K45:18)
	var $i : Integer
	For ($i; 1; $pageCount)
		$options[wk page index:K81:357]:=$i
		WP EXPORT VARIABLE:C1319($wp; $text; wk svg:K81:356; $options)
		$svgRoot:=DOM Parse XML variable:C720($text; False:C215)
		SVG EXPORT TO PICTURE:C1017($svgRoot; $preview; Own XML data source:K45:18)
		$pages.push(New object:C1471("page"; $i; "svg"; $preview))
	End for 
	
Function createPDF_noConditions($pfad : Text)
	var $wp : Object:=WP New:C1317(This:C1470.WP)
	WP EXPORT DOCUMENT:C1337($wp; $pfad; wk pdf:K81:315)
	
Function createPDF($pfad : Text)
	var $wp : Object:=WP New:C1317()
	
	var $col : Collection:=This:C1470.getPageImages()
	var $conditions : Picture
	var $conditionsentity : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='conditions'")
	
	var $page : Object
	For each ($page; $col)
		var $pic : Object:=WP Add picture:C1536($wp; $page.svg)
		WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $page.page)
		WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
	End for each 
	If ($conditionsentity.length>0)
		$conditions:=$conditionsentity.first().image
		If (Picture size:C356($conditions)>0)
			$pic:=WP Add picture:C1536($wp; $conditions)
			WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $col.length+1)
		End if 
	End if 
	
	// electronic invoice for Germany, France, Spain (Facture-X - Zugferd)
	If (True:C214)  // remove for other countries...
		var $xml : Text:=This:C1470.buildXML()
		If (False:C215)
			Folder:C1567(fk desktop folder:K87:19).file("test.xml").setText($xml)  // for debugging
		End if 
		var $options:={}
		var $fileInfo:={}
		var $target:="german"
		
		Case of 
				
			: ($target="french")
				
				$options.facturX:={}
				$options.facturX.profile:="BASIC"  // "guessed" from XML so, no need to fill
				$options.facturX.version:="1.0"  // "1.0" is default value
				
				$fileInfo.name:="factur-x.xml"  // default value for first file (factur-x/ZUGFeRD xml)
				$fileInfo.description:="Factur-X/ZUGFeRD Invoice"  // default value for first file ("factur-x/ZUGFeRD invoice")
				$fileInfo.mimeType:="text/xml"  // can be guessed as well
				$fileInfo.relationship:="Data"
				
				$fileInfo.data:=$xml  // just built above //this is mandatory
				
			: ($target="german")
				
				$options.facturX:={}
				$options.facturX.profile:="BASIC"  // "guessed" from XML so, no need to fill
				$options.facturX.version:="1.0"
				
				$fileInfo.name:="factur-x.xml"
				$fileInfo.description:="Factur-X/ZUGFeRD Invoice"
				$fileInfo.mimeType:="text/xml"
				$fileInfo.relationship:="Alternative"
				
				$fileInfo.data:=$xml  // just built above //this is mandatory
				
		End case 
		$options.files:=[$fileInfo]  // more files could be added, the first one is for facturX/ZUGFeDR
		
		WP EXPORT DOCUMENT:C1337($wp; $pfad; wk pdf:K81:315; $options)
	Else 
		WP EXPORT DOCUMENT:C1337($wp; $pfad; wk pdf:K81:315)
	End if 
	
	
	
	
Function print_white()
	// remove background, then print. Create a copy to do so
	var $wp : Object:=WP New:C1317(This:C1470.WP)
	This:C1470.setContext($wp)
	var $obj : Object:=WP Get element by ID:C1549($wp; "LogoBackground")
	WP DELETE PICTURE:C1701($obj)
	
	SET PRINT OPTION:C733(Spooler document name option:K47:10; "Invoice "+This:C1470.context.invoice.InvoiceNumber)
	WP PRINT:C1343($wp)
	
Function print_color()
	var $wp : Object:=WP New:C1317()
	var $col : Collection:=This:C1470.getPageImages()
	var $conditions : Picture
	var $conditionsentity : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='conditions'")
	If ($conditionsentity.length>0)
		$conditions:=$conditionsentity.first().image
	End if 
	
	var $pagecounter : Integer:=1
	var $page : Object
	var $pic : Object
	For each ($page; $col)
		$pic:=WP Add picture:C1536($wp; $page.svg)
		WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $pagecounter)
		$pagecounter+=1
		Case of 
			: ($pagecounter=2)  // first page...
				If (Picture size:C356($conditions)>0)
					WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
					$pic:=WP Add picture:C1536($wp; $conditions)
					WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $pagecounter)
				End if 
				$pagecounter+=1
				If ($page.page<$col.length)
					WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
				End if 
			: ($page.page<$col.length)
				WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)  // empty page
				$pagecounter+=1
				WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
		End case 
	End for each 
	
	SET PRINT OPTION:C733(Spooler document name option:K47:10; "Invoice "+This:C1470.context.invoice.InvoiceNumber)
	WP PRINT:C1343($wp)
	
	
Function buildXML()->$xmlText : Text
	var $file : 4D:C1709.File
	var $dom; $path; $parentPath; $ref; $parentRef; $valueString; $newStruct : Text
	var $col : Collection
	var $element; $item : Object
	var $itemID : Integer
	
	var $typeCode : Integer:=30
	var $dateTimeStringFormat : Integer:=102
	var $currencyCode : Text:="EUR"
	
	var $context : Object:=This:C1470.context
	
	$file:=File:C1566("/RESOURCES/Profiles/xml_BASIC.xml")
	$xmlText:=$file.getText()
	
	$dom:=DOM Parse XML variable:C720($xmlText)  //rsm:CrossIndustryInvoice
	
	// STATIC VALUES
	
	$col:=New collection:C1472()
	$col.push({xpath: "rsm:ExchangedDocument/ram:ID"; value: $context.invoice.InvoiceNumber})
	$col.push({xpath: "rsm:ExchangedDocument/ram:IncludedNote/ram:Content"; value: "Invoice"})  // you can add invoice comment or invoice notes here
	
	$valueString:=String:C10(Year of:C25($context.invoice.Date); "0000")+String:C10(Month of:C24($context.invoice.Date); "00")+String:C10(Day of:C23($context.invoice.Date); "00")
	$col.push({xpath: "rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString"; value: $valueString})
	
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name"; value: $context.seller.company})
	//$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"; value: $context.seller.ID}) // add if you need it
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode"; value: $context.seller.zip})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineOne"; value: $context.seller.street})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CityName"; value: $context.seller.city})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID"; value: $context.seller.country})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID"; value: $context.seller.vat})
	
	
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name"; value: $context.invoice.client.Name})
	//$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID"; value: $context.invoice.client.registerID})  // add if you need it
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode"; value: $context.invoice.client.ZipCode})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:LineOne"; value: $context.invoice.client.Address1})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CityName"; value: $context.invoice.client.City})
	Case of 
		: (($context.invoice.client.Country="Germany") | ($context.invoice.client.Country="Deutschland"))
			$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID"; value: "DE"})
		: (($context.invoice.client.Country="France") | ($context.invoice.client.Country="Frankreich"))
			$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID"; value: "FR"})
		Else 
			// for this example we just handle Germany and France, but in real live, you need to handle all european countries
			$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID"; value: "DE"})
	End case 
	If (True:C214)  // use fake VAT, in real live add the real one from customer record
		$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID"; value: "DE12345678"})  // add if you have it
	Else 
		$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID"; value: $context.invoice.client.VAT})  // add if you have it
	End if 
	
	//$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID"; value: $context.invoice.buyerIssuerAssignedID})// add if you have it
	//$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:IssuerAssignedID"; value: $context.invoice.contractIssuerAssignedID})// add if you have it
	
	var $dueDate : Date:=$context.invoice.Date+$context.invoice.PaymentDelay
	$valueString:=String:C10(Year of:C25($dueDate); "0000")+String:C10(Month of:C24($dueDate); "00")+String:C10(Day of:C23($dueDate); "00")
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms/ram:DueDateDateTime/udt:DateTimeString"; value: $valueString; attributeName: "format"; attributeValue: $dateTimeStringFormat})
	
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentReference"; value: $context.invoice.InvoiceNumber})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode"; value: $currencyCode})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode"; value: $typeCode})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:PayeePartyCreditorFinancialAccount/ram:IBANID"; value: $context.seller.iban})
	
	
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount"; value: $context.invoice.Subtotal})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount"; value: $context.invoice.Subtotal})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount"; value: $context.invoice.Tax; attributeName: "currencyID"; attributeValue: $currencyCode})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount"; value: $context.invoice.Total})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount"; value: 0})
	$col.push({xpath: "rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount"; value: $context.invoice.Total})
	
	
	var $tradeTaxis:=New collection:C1472
	
	For each ($element; $col)
		$ref:=DOM Find XML element:C864($DOM; $element.xpath)
		DOM SET XML ELEMENT VALUE:C868($ref; $element.value)
		If ($element.attributeName#Null:C1517)
			DOM SET XML ATTRIBUTE:C866($ref; $element.attributeName; $element.attributeValue)
		End if 
	End for each 
	
	
	// DYNAMIC VALUES (based on number of items)
	$itemID:=1
	For each ($item; $context.invoice.invoice_lines)
		
		$path:="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem["+String:C10($itemID)+"]"
		$ref:=DOM Find XML element:C864($DOM; $path)
		
		If (ok=0)
			$parentPath:="rsm:SupplyChainTradeTransaction"
			$parentRef:=DOM Find XML element:C864($DOM; $parentPath)
			
			$newStruct:=DOM Create XML Ref:C861("toBeRenamed")  //Error IF created straight as "ram:IncludedSupplyChainTradeLineItem")
			$ref:=DOM Insert XML element:C1083($parentRef; $newStruct; $itemID)
			DOM CLOSE XML:C722($newStruct)
			DOM SET XML ELEMENT NAME:C867($ref; "ram:IncludedSupplyChainTradeLineItem")  // rename now
			
			//$path:="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem["+String($itemID)+"]"
			//$ref:=DOM Find XML element($DOM; $path)
			
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:AssociatedDocumentLineDocument/ram:LineID")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:SpecifiedTradeProduct/ram:Name")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent")
			
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount")
			
		End if 
		
		
		$col:=New collection:C1472()
		$col.push({xpath: $path+"/ram:AssociatedDocumentLineDocument/ram:LineID"; value: String:C10($itemID)})
		//$col.push({xpath: $path+"/ram:SpecifiedTradeProduct/ram:GlobalID"; value: $item.globalID; attributeName: "schemeID"; attributeValue: $item.schemeID})  //***
		$col.push({xpath: $path+"/ram:SpecifiedTradeProduct/ram:Name"; value: $item.ProductName})
		var $price : Real:=Round:C94($item.Unit_Price-($item.Unit_Price*($item.Discount_Rate/100)); 2)  // with BASIC profile there is no field for discount, if you use COMFORT you can specify discount
		$col.push({xpath: $path+"/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount"; value: $price})
		
		var $unitCode : Text:="XPP"  // Pieces, LTR would be Liter
		$col.push({xpath: $path+"/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity"; value: $item.Quantity; attributeName: "unitCode"; attributeValue: $unitCode})  //***
		
		$col.push({xpath: $path+"/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode"; value: "VAT"})
		$col.push({xpath: $path+"/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode"; value: "S"})
		$col.push({xpath: $path+"/ram:SpecifiedLineTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent"; value: $item.ProductTaxRate})
		
		$col.push({xpath: $path+"/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount"; value: $item.Total})
		
		For each ($element; $col)
			$ref:=DOM Find XML element:C864($DOM; $element.xpath)
			DOM SET XML ELEMENT VALUE:C868($ref; $element.value)
			If ($element.attributeName#Null:C1517)
				DOM SET XML ATTRIBUTE:C866($ref; $element.attributeName; $element.attributeValue)
			End if 
		End for each 
		
		var $tax : Collection:=$tradeTaxis.query("percent = :1"; $item.ProductTaxRate)
		If ($tax.length=0)
			$tradeTaxis.push(New object:C1471("percent"; $item.ProductTaxRate; "basis"; $item.Total; "amount"; $item.TotalTax))
		Else 
			$tax[0].basis+=$item.Total
			$tax[0].amount+=$item.TotalTax
		End if 
		
		
		$itemID+=1
	End for each 
	
	
	// DYNAMIC VALUES (based on distinct tax rates)
	$itemID:=1
	For each ($item; $tradeTaxis)
		
		$path:="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax["+String:C10($itemID)+"]"
		$ref:=DOM Find XML element:C864($DOM; $path)
		If (ok=0)
			
			
			$parentPath:="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement"
			$parentRef:=DOM Find XML element:C864($DOM; $parentPath)
			
			$newStruct:=DOM Create XML Ref:C861("toBeRenamed")  //Error IF created straight as "ram:IncludedSupplyChainTradeLineItem")
			
			// the FIRST ApplicableTradeTax is at the FOURTH position in the ApplicableHeaderTradeSettlement
			// the SECOND ApplicableTradeTax is at the FIFTH position in the ApplicableHeaderTradeSettlement
			// This explains the $itemID+3 in the line below ($itemID shall be equal to 2)
			
			$ref:=DOM Insert XML element:C1083($parentRef; $newStruct; $itemID+3)  // +3 (see above)
			DOM CLOSE XML:C722($newStruct)
			DOM SET XML ELEMENT NAME:C867($ref; "ram:ApplicableTradeTax")  // rename now
			
			//$ref:=DOM Create XML element($DOM; $path)
			
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:CalculatedAmount")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:TypeCode")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:BasisAmount")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:CategoryCode")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:DueDateTypeCode")
			$ref:=DOM Create XML element:C865($DOM; $path+"/ram:RateApplicablePercent")
		End if 
		
		$col:=New collection:C1472()
		$col.push({xpath: $path+"/ram:CalculatedAmount"; value: $item.amount})
		$col.push({xpath: $path+"/ram:TypeCode"; value: "VAT"})
		$col.push({xpath: $path+"/ram:BasisAmount"; value: $item.basis})
		$col.push({xpath: $path+"/ram:CategoryCode"; value: "S"})
		$col.push({xpath: $path+"/ram:DueDateTypeCode"; value: 5})
		$col.push({xpath: $path+"/ram:RateApplicablePercent"; value: $item.percent})
		
		For each ($element; $col)
			$ref:=DOM Find XML element:C864($DOM; $element.xpath)
			DOM SET XML ELEMENT VALUE:C868($ref; $element.value)
		End for each 
		
		$itemID+=1
	End for each 
	
	DOM EXPORT TO VAR:C863($DOM; $xmlText)
	DOM CLOSE XML:C722($DOM)
	