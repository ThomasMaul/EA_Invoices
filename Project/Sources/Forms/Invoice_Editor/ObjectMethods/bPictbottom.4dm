ARRAY TEXT:C222($arr; 0)
$path:=Select document:C905(1; ".png;.jpg"; "Select Picture"; Use sheet window:K24:11; $arr)
If (OK=1)
	$path:=$arr{1}
	READ PICTURE FILE:C678($path; $image)
	If (OK=1)
		$obj:=WP Get element by ID:C1549(WPArea; "LogoBottom")
		If ($obj#Null:C1517)
			WP DELETE PICTURE:C1701($obj)
		End if 
		
		WP GET ATTRIBUTES:C1345(WPArea; wk page width:K81:262; $width)
		
		$obImage:=WP Add picture:C1536(WPArea; $image)
		$obImage.id:="LogoBottom"
		WP SET ATTRIBUTES:C1342($obImage; wk anchor vertical align:K81:239; wk bottom:K81:98; wk anchor horizontal align:K81:237; wk left:K81:95; wk anchor horizontal offset:K81:236; "0 pt"; wk anchor layout:K81:227; wk behind text:K81:240; wk anchor origin:K81:235; wk paper box:K81:215; \
			wk anchor page:K81:231; wk anchor all:K81:229; wk width:K81:45; $width)
	End if 
End if 