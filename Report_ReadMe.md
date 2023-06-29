# Using 4D View Pro as Report Engine

## Benefits:
- support Pivot Table
- support conditional formats (red for negative, etc)
- support charts, barcodes, minicharts
- fully customizable
- export as Excel document - "standard" report format for many larger companies
- export as SVG or PDF

## Concept:
As with Quick Report, use your existing GUI to select table, select records, filter, sort, etc.
The current content of the listbox is synced with 4D View Pro area, allowing the end user to design reports as needed.
When the end user modifies the list box selection, the report can be synced in parallel, updating the report quickly, without the need to reopen all.

## Example:
in the 4D Invoice example, just open Products, Invoices or Clients, select some records then click the "Reports" button. Invoices is most interesting, as it has relations to Clients. When you click Report on Invoices, it opens a popup to allow to either build the report on Invoices, or directly on Invoice Items, allowing to use the relation from Invoice Items to Products and from Invoice Items to Invoices and Clients.
Such more complex tables are the perfect example for pivot tables...

This opens a new window (in the same process) showing a 4D View Pro Area.
Now click "Insert Data", which opens a field list editor.
Pick some fields, by double click, drag&drop or using the > button.
Feel free to arrange by drag&drop the selected list.
Note that you can use Many to One relations (up to 3 level).

When you click "Insert", the selected fields for the selected records are inserted as 4D View Pro table in a sheet named "data". Feel free to use all table functions from the spreadsheet.
By example create on another sheet a pivot table or other calculations.

You can click "Insert Data" again to enhance/reduce your selected field list, even if the user saved the document and reopened it later (as long as the field names don't change).

Click back to the Invoice example window and select some other records from the list or run a query. Then click on "Update" to refresh the table. If you are using a pivot table, the table is automatically refreshed if it is displayed in the current displayed sheet. If another sheet was displayed, switch sheet, select your pivot table and click the Refresh button in the ribbon bar.

### Example Workflow
After creating your spreadsheet based on data from the application, save it as 4D View Pro document (using the ribbon bar to save it on disk or using code to save it as record). Next time when the user needs the report with updated data, just reopen it and click update (or run that function by code) to get the new data.


## Installation:
To use the code in your own application, you need to be in 4D v19 R8 or v20 and in project mode. You need to copy 2 forms, two classes and some picture files.

Most easiest way to copy a form, with all form property settings, form method, objects, object methods, etc, is to copy the folder using the OS Finder/Explorer. (If you don't like that, you can also copy the form content, but don't forget the form method)

Copy from Invoices into your application (in the same subfolder):
EA_Invoices/Project/Sources/Forms/ViewProReport (the folder)
EA_Invoices/Project/Sources/Forms/FieldListORDA (the folder)

Copy class "FieldListEditor"

Copy the two functions (or the whole class if you don't use it so far) from class "DataStore" flattenCollection and _flattenCollObject.

Copy the two methods VPReportUpdate and VPReportCallback.
Adapt the code of VPReportCallback to your need, for minimum usage it can be just $result:=$data (doing nothing). This method allows to use another table, as in the Invoice example it allows to show invoice items for the selected invoices (often useful for pivot table reporting).

Finally insert into your user interface a button (or reuse one) to start the report.
Example code:

```4D
	$data:=New object("table"; Form.dataClassName; "masterform"; Form)
	If (Form.selectedSubset.length>0)  // if some records are selected, we use those, else all
		$data.data:=Form.selectedSubset
	Else 
		$data.data:=Form.displayedSelection
	End if 
	$win:=Open form window("ViewProReport")
	DIALOG("ViewProReport"; $data; *)
```

pass in "table" the name of the currently displayed table, by example here "INVOICES". The invoice example always store that in Form.dataClassName, so it is easy to re-use.
You can get that generic from an entity or entity selection by example with:
$displayedSelection.getDataClass().getInfo().name

In "masterform" pass the current Form object, assuming that the main form already has a Form object with the assigned displayed entity selection and selected entity selection (usually a list box). In the example above the list box has assigned "Form.displaySelection" and "Form.selectedSubset" for the current selected items.


