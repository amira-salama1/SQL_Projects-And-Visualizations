D8: Only Filter Rows for the Sales Fact table with Invoice Date = End of Month


    let
        Source = Sql.Databases("localhost"),
        WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
        Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data],
    
        #"Selected Rows" = Table.SelectRows(Fact_Sale, each [Invoice Date Key] = Date.EndOfMonth([Invoice Date Key])),
    
        #"Removed Other Columns" = Table.SelectColumns(#"Selected Rows", {
            "Sale Key", 
            "Customer Key", 
            "Invoice Date Key", 
            "Total Excluding Tax", 
            "Tax Amount", 
            "Profit"
        })
    
    in
         #"Removed Other Columns"
