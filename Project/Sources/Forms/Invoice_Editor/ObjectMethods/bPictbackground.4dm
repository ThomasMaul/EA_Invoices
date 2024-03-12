var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='BusinessPaper'")
If ($templates.length#0)
	var $obj : Object:=WP Get element by ID:C1549(WPArea; "LogoBackground")
	If ($obj#Null:C1517)
		WP DELETE PICTURE:C1701($obj)
	End if 
	
	var $width : Integer
	WP GET ATTRIBUTES:C1345(WPArea; wk page width:K81:262; $width)
	
	var $obImage : Object:=WP Add picture:C1536(WPArea; $templates.first().image)
	$obImage.id:="LogoBackground"
	WP SET ATTRIBUTES:C1342($obImage; wk anchor horizontal align:K81:237; wk left:K81:95; \
		wk anchor layout:K81:227; wk behind text:K81:240; wk anchor origin:K81:235; wk paper box:K81:215; \
		wk anchor page:K81:231; wk anchor all:K81:229; wk width:K81:45; $width)
End if 
