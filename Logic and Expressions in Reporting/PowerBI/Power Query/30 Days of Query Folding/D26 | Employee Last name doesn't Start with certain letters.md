D26: 
Select some columns where Employee Last name doesn't start with (A to E)

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

A better Approach than writing each letter, if the letters are in a row:

    List.Select(
		dbo_DimEmployee[LastName], 
		each not List.Contains({"A".."E"}, Text.Start(_, 1))
