Case of 
	: (Form event code:C388=On Load:K2:1)
		// Object method [CLIENTS]GraphForm Button
		C_PICTURE:C286(graphArea)
		C_LONGINT:C283($vGraphType; $vIndX)
		C_LONGINT:C283($i; $vInterval; $vCrtMonth; $vCrtYear)
		C_DATE:C307($vFirstDate; $vLastDate; $vCrtDate)
		_O_C_STRING:C293(5; $vCrtMonthYear)
		
		$vInterval:=6
		$vGraphType:=4
		
		_O_ARRAY STRING:C218(5; X; $vInterval)
		ARRAY REAL:C219($Clients; $vInterval)
		
		RELATE MANY SELECTION:C340([INVOICES:2]Client_ID:3)
		$vCrtMonth:=Month of:C24(Current date:C33(*))
		$vCrtYear:=Year of:C25(Current date:C33(*))
		If ($vCrtMonth=12)
			$vLastDate:=Add to date:C393(!00-00-00!; $vCrtYear+1; 1; 1)
		Else 
			$vLastDate:=Add to date:C393(!00-00-00!; $vCrtYear+1; $vCrtMonth+1; 1)
		End if 
		Case of 
			: (($vCrtMonth-$vInterval)<0)
				$vFirstDate:=Add to date:C393(!00-00-00!; $vCrtYear-1; 12-$vInterval+$vCrtMonth+1; 1)
			: (($vCrtMonth-$vInterval)=0)
				$vFirstDate:=Add to date:C393(!00-00-00!; $vCrtYear; 1; 1)
			Else 
				$vFirstDate:=Add to date:C393(!00-00-00!; $vCrtYear; $vCrtMonth-$vInterval+1; 1)
		End case 
		QUERY SELECTION:C341([INVOICES:2]; [INVOICES:2]ProForma:12=False:C215; *)
		QUERY SELECTION:C341([INVOICES:2];  & ; [INVOICES:2]Date:4>=$vFirstDate; *)
		QUERY SELECTION:C341([INVOICES:2];  & ; [INVOICES:2]Date:4<$vLastDate)
		If (Records in selection:C76([INVOICES:2])>0)
			$vCrtDate:=$vFirstDate
			For ($i; 1; $vInterval)
				X{$i}:=String:C10(Month of:C24($vCrtDate); "00")+"/"+Substring:C12(String:C10(Year of:C25($vCrtDate)); 3; 2)
				$vCrtDate:=Add to date:C393($vCrtDate; 0; 1; 0)
			End for 
			For ($i; 1; Records in selection:C76([INVOICES:2]))
				$vCrtMonthYear:=String:C10(Month of:C24([INVOICES:2]Date:4); "00")+"/"+Substring:C12(String:C10(Year of:C25([INVOICES:2]Date:4)); 3; 2)
				$vIndX:=Find in array:C230(X; $vCrtMonthYear)
				$Clients{$vIndX}:=$Clients{$vIndX}+[INVOICES:2]Subtotal:5
				NEXT RECORD:C51([INVOICES:2])
			End for 
		Else 
			ALERT:C41(Get localized string:C991("No invoices in the past 6 months"))
		End if 
		
		GRAPH:C169(graphArea; $vGraphType; X; $Clients)
		GRAPH SETTINGS:C298(graphArea; 0; 0; 0; 0; False:C215; False:C215; True:C214; Get localized string:C991("Turnover"))
End case 