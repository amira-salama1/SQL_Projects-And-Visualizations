D20 | Dynamically select Columns of Type Text

     let
      Source = Sql.Databases("ASALAMA\MSSQLSERVER01"),
      WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
      #"Dimension_Stock Item" = WideWorldImportersDW{[Schema="Dimension",Item="Stock Item"]}[Data],
  
      #"Select Columns" = Table.SelectColumns(#"Dimension_Stock Item", 
          Table.ColumnsOfType(#"Dimension_Stock Item", {type nullable text}))
    in
      #"Select Columns"
