//$WPRange:=WP Text range(WParea; wk start text; wk end text)
$wprange:=WP Selection range:C1340(*; "WParea")
$WPTable:=WP Insert table:C1473($WPRange; wk append:K81:179; wk exclude from range:K81:181; 4; 4)
WP SET ATTRIBUTES:C1342($WPTable; wk datasource:K81:367; Formula:C1597(This:C1470.data.Lines_Fm_Invoices))