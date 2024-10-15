D26:

    let
        Source = Sql.Databases("ASALAMA\MSSQLSERVER01"),
        AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
        dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
        #"Removed Other Columns" = Table.SelectColumns(dbo_DimEmployee,{"EmployeeKey", "FirstName", "LastName", "MiddleName"}),
        #"Reordered Columns" = Table.ReorderColumns(#"Removed Other Columns",{"EmployeeKey", "FirstName", "MiddleName", "LastName"}),
    
        #"Added Custom" = Table.AddColumn(#"Reordered Columns", "Custom", each Text.Range([LastName],0,1)),
    
        #"Filtered Rows" = Table.SelectRows(#"Added Custom", 
        each (List.Contains({"A","B","C","D","E"},[Custom]))
             = false)
    in
        #"Filtered Rows"
