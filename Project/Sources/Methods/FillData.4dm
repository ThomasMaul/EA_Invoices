//%attributes = {"invisible":true}
// (P) FillData

C_TEXT:C284($currentLanguage)
C_TEXT:C284($resourcesFolder)
C_TEXT:C284($clientsFile; $productsFile)
C_BOOLEAN:C305($importOk)
C_TIME:C306($doc)
C_LONGINT:C283($random; $numberOfProducts; $i; $j; $k; $productID; $productNumber; $vPlatform)
_O_C_STRING:C293(40; $clientName; $clientAddress1; $clientCity; $clientState; $clientCountry)
_O_C_STRING:C293(10; $clientZipCode)
_O_C_STRING:C293(20; $clientPhone; $clientMobile; $clientFax)
_O_C_STRING:C293(80; $clientEmail; $clientContact)
_O_C_STRING:C293(1; $lf)
C_TEXT:C284($alphabet)
C_LONGINT:C283($diff)

//$currentLanguage:=Get database localization(Current localization)
//$resourcesFolder:=Get 4D folder(Current resources folder)
//$clientsFile:=$resourcesFolder+$currentLanguage+".lproj"+Folder separator+"Clients.txt"
$clientsFile:=Get localized document path:C1105("Clients.txt")

If (Test path name:C476($clientsFile)=Is a document:K24:1)
	$importOk:=True:C214
Else 
	$clientsFile:=Get 4D folder:C485(Current resources folder:K5:16)+"en.lproj"+Folder separator:K24:12+"Clients.txt"
	If (Test path name:C476($clientsFile)=Is a document:K24:1)
		$importOk:=True:C214
	Else 
		$importOk:=False:C215
	End if 
End if 

If ($importOk)
	$doc:=Open document:C264($clientsFile)  // Open the CLIENTS import file
	If (Ok=1)
		_O_PLATFORM PROPERTIES:C365($vPlatform)
		// Start to fill the CLIENTS table
		Repeat 
			RECEIVE PACKET:C104($doc; $clientName; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientAddress1; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientCity; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientState; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientZipCode; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientCountry; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientPhone; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientMobile; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientFax; Char:C90(Tab:K15:37))
			RECEIVE PACKET:C104($doc; $clientEmail; Char:C90(Tab:K15:37))
			//If ($vPlatform=Windows)
			//RECEIVE PACKET($doc;$clientContact;Char(Carriage return))
			//RECEIVE PACKET($doc;$lf;Char(Line feed))
			//Else 
			RECEIVE PACKET:C104($doc; $clientContact; Char:C90(Line feed:K15:40))
			//End if 
			If (Ok=1)
				CREATE RECORD:C68([CLIENTS:1])
				[CLIENTS:1]Name:2:=$ClientName
				$clientName:=Replace string:C233($clientName; " "; "")
				[CLIENTS:1]Address1:3:=$clientAddress1
				[CLIENTS:1]City:5:=$clientCity
				[CLIENTS:1]State:6:=$clientState
				[CLIENTS:1]ZipCode:7:=$clientZipCode
				[CLIENTS:1]Country:17:=$clientCountry
				$random:=(Random:C100%(10-1+1))+1
				Case of 
					: ($random=1)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="It is one of the best"
					: ($random=2)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="Very honest"
					: ($random=3)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="To recontact"
					: ($random=4)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="To be more explicit"
					: ($random=5)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="Very good and correct client"
					: ($random=6)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="It is one of the bigest"
					: ($random=7)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="Very good client"
					: ($random=8)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="Usually it is late in payments"
					: ($random=9)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="Nice to do business with him"
					: ($random=10)
						[CLIENTS:1]WebSite:12:="www."+$clientName+".com"
						[CLIENTS:1]Comments:15:="Very interesting client"
				End case 
				[CLIENTS:1]Phone:8:=$clientPhone
				[CLIENTS:1]Mobile:9:=$clientMobile
				[CLIENTS:1]Fax:10:=$clientFax
				[CLIENTS:1]Email:11:=$clientEmail
				[CLIENTS:1]Logo:13:=ToolCreateLogo("logo")
				[CLIENTS:1]Contact:14:=$clientContact
				SAVE RECORD:C53([CLIENTS:1])
			End if 
		Until (Ok=0)
		UNLOAD RECORD:C212([CLIENTS:1])
		CLOSE DOCUMENT:C267($doc)
	Else 
		ALERT:C41("Unable to open the CLIENTS import file")
	End if 
	
	_O_ARRAY STRING:C218(40; $aTypeStylo; 4)
	$aTypeStylo{1}:="Multifonction"
	$aTypeStylo{2}:="Plume"
	$aTypeStylo{3}:="Bille"
	$aTypeStylo{4}:="Roller"
	_O_ARRAY STRING:C218(40; $aMarqueStylo; 6)
	$aMarqueStylo{1}:="Potter"
	$aMarqueStylo{2}:="Weasley"
	$aMarqueStylo{3}:="Rogue"
	$aMarqueStylo{4}:="Voldermont"
	$aMarqueStylo{5}:="Granger"
	$aMarqueStylo{6}:="Dumbledore"
	_O_ARRAY STRING:C218(40; $aColorStylo; 10)
	$aColorStylo{1}:="Black"
	$aColorStylo{2}:="Red"
	$aColorStylo{3}:="Bright Red"
	$aColorStylo{4}:="Blue"
	$aColorStylo{5}:="Bright Blue"
	$aColorStylo{6}:="Yellow"
	$aColorStylo{7}:="Bright Yellow"
	$aColorStylo{8}:="Green"
	$aColorStylo{9}:="Bright Green"
	$aColorStylo{10}:="White"
	
	$productNumber:=0
	For ($i; 1; Size of array:C274($aTypeStylo))
		For ($j; 1; Size of array:C274($aMarqueStylo))
			For ($k; 1; Size of array:C274($aColorStylo))
				$productNumber:=$productNumber+1
				CREATE RECORD:C68([PRODUCTS:4])
				[PRODUCTS:4]Reference:2:=Uppercase:C13(Substring:C12($aTypeStylo{$i}; 1; 3)+Substring:C12($aMarqueStylo{$j}; 1; 3)+Substring:C12($aColorStylo{$k}; 1; 3)+String:C10($productNumber; "0000"))
				[PRODUCTS:4]Name:3:="Stylo "+$aTypeStylo{$i}+" "+$aMarqueStylo{$j}+" "+$aColorStylo{$k}
				$random:=(Random:C100%(10-1+1))+1
				[PRODUCTS:4]UnitPrice:5:=$random*5
				[PRODUCTS:4]Picture:4:=ToolCreateLogo("product")
				[PRODUCTS:4]TaxRate:6:=19.6
				SAVE RECORD:C53([PRODUCTS:4])
			End for 
		End for 
	End for 
	
	// Create the [GENERAL] table
	If (Records in table:C83([SETTINGS:5])=0)
		CREATE RECORD:C68([SETTINGS:5])
		SAVE RECORD:C53([SETTINGS:5])
		UNLOAD RECORD:C212([SETTINGS:5])
	End if 
	
	// Start to fill the INVOICES table
	ARRAY LONGINT:C221($_productsID; 0)
	ALL RECORDS:C47([PRODUCTS:4])
	SELECTION TO ARRAY:C260([PRODUCTS:4]ID:1; $_productsID)
	
	ALL RECORDS:C47([CLIENTS:1])
	For ($i; 1; Records in selection:C76([CLIENTS:1]))
		For ($j; 1; ((Random:C100%(20-1+1))+1))
			CREATE RECORD:C68([INVOICES:2])
			[INVOICES:2]InvoiceNumber:2:="INV"+String:C10(Invoices_GetNumber; "00000")
			[INVOICES:2]Client_ID:3:=[CLIENTS:1]ID:1
			[INVOICES:2]Date:4:=Current date:C33-60+((Random:C100%(59-1+1))+1)
			[INVOICES:2]PaymentDelay:13:=30
			[INVOICES:2]Paid:8:=(((Random:C100%(1-0+1))+1)=1)
			If ([INVOICES:2]Paid:8)
				$diff:=Current date:C33-[INVOICES:2]Date:4
				[INVOICES:2]PaymentDate:9:=Current date:C33-$diff+((Random:C100%($diff-2+1))+1)
				$random:=(Random:C100%(3-1+1))+1
				Case of 
					: ($random=1)
						If ($currentLanguage="fr")
							[INVOICES:2]PaymentMethod:10:="Par chèque"
							[INVOICES:2]PaymentReference:11:="Numéro de chèque: "+String:C10($i; "0000")+String:C10($j; "0000")+String:C10($i; "000")+String:C10($j; "000")
						Else 
							[INVOICES:2]PaymentMethod:10:="By check"
							[INVOICES:2]PaymentReference:11:="Check number: "+String:C10($i; "0000")+String:C10($j; "0000")+String:C10($i; "000")+String:C10($j; "000")
						End if 
					: ($random=2)
						If ($currentLanguage="fr")
							[INVOICES:2]PaymentMethod:10:="Par carte bancaire"
							[INVOICES:2]PaymentReference:11:="Numéro de carte bancaire: "+String:C10($i; "0000")+String:C10($j; "0000")+String:C10($i; "0000")+String:C10($j; "0000")
						Else 
							[INVOICES:2]PaymentMethod:10:="By credit card"
							[INVOICES:2]PaymentReference:11:="Credit card number: "+String:C10($i; "0000")+String:C10($j; "0000")+String:C10($i; "0000")+String:C10($j; "0000")
						End if 
					: ($random=3)
						If ($currentLanguage="fr")
							[INVOICES:2]PaymentMethod:10:="Par transfert bancaire"
							[INVOICES:2]PaymentReference:11:="Compte bancaire: 00"+String:C10($i; "0000")+String:C10($j; "0000")+String:C10($i; "0000")+String:C10($j; "0000")
						Else 
							[INVOICES:2]PaymentMethod:10:="By bank transfer"
							[INVOICES:2]PaymentReference:11:="Bank account: 00"+String:C10($i; "0000")+String:C10($j; "0000")+String:C10($i; "0000")+String:C10($j; "0000")
						End if 
				End case 
			End if 
			For ($k; 1; ((Random:C100%(20-1+1))+1))
				CREATE RECORD:C68([INVOICE_LINES:3])
				[INVOICE_LINES:3]Invoice_ID:2:=[INVOICES:2]ID:1
				$productID:=(Random:C100%(Size of array:C274($_productsID)-1+1))+1  // Pick a random product
				[INVOICE_LINES:3]Product_ID:3:=$_productsID{$productID}
				QUERY:C277([PRODUCTS:4]; [PRODUCTS:4]ID:1=$_productsID{$productID})
				[INVOICE_LINES:3]ProductReference:4:=[PRODUCTS:4]Reference:2
				[INVOICE_LINES:3]ProductName:5:=[PRODUCTS:4]Name:3
				[INVOICE_LINES:3]Quantity:6:=(Random:C100%(10-1+1))+1
				[INVOICE_LINES:3]ProductUnitPrice:7:=[PRODUCTS:4]UnitPrice:5
				[INVOICE_LINES:3]DiscountRate:8:=((Random:C100%(10-0+1))+0)
				[INVOICE_LINES:3]ProductTaxRate:9:=[PRODUCTS:4]TaxRate:6
				Invoices_CalculateLineTotals
				SAVE RECORD:C53([INVOICE_LINES:3])
			End for 
			QUERY:C277([INVOICE_LINES:3]; [INVOICE_LINES:3]Invoice_ID:2=[INVOICES:2]ID:1)
			Invoices_CalculateTotals
			SAVE RECORD:C53([INVOICES:2])
		End for 
		SAVE RECORD:C53([CLIENTS:1])
		NEXT RECORD:C51([CLIENTS:1])
	End for 
	
Else 
	ALERT:C41("Unable to find the import files, the database remains empty")
End if 