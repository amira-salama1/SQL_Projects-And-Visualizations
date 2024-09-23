Day 7 :

    let
        Source = Sql.Databases("localhost"),
        AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
        dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    
        //Selecting Columns not containing "KEY"
        #"Filtered_Columns" = List.Select (Table.ColumnNames(dbo_DimEmployee), 
            each not Text.Contains(_, "Key", Comparer.Ordinal) ),
    
        #"Selected_Columns" = Table.SelectColumns(dbo_DimEmployee, #"Filtered_Columns")
    in
        #"Selected_Columns"
