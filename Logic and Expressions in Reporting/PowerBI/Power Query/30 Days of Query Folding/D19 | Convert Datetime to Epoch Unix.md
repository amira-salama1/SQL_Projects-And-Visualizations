Day 19:

Database: AdventureWorksDW2017 

Entity: FactResellerSales 

Instructions: 

Select [SalesOrderNumber], [OrderDate], [ResellerKey], [EmployeeKey] 
and a computed column  [UnixTimestamp] which is the [OrderDate] 
converted to its epoch unix time stamp equivalent.


      let
      Source = Sql.Databases("ASALAMA\MSSQLSERVER01"),
      AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
      dbo_FactResellerSales = AdventureWorksDW2017{[Schema="dbo",Item="FactResellerSales"]}[Data],
      #"Removed Other Columns" = Table.SelectColumns(dbo_FactResellerSales,{"ResellerKey", "EmployeeKey", "SalesOrderNumber", "OrderDate"}),
      #"Added Custom" = Table.AddColumn(#"Removed Other Columns", "UnixTimeStamp", each Duration.TotalSeconds([OrderDate] - 
        #datetime(1970,1,1,0,0,0) )),
      #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"SalesOrderNumber", "OrderDate", "ResellerKey", "EmployeeKey", "UnixTimeStamp"}),
      #"Removed Duplicates" = Table.Distinct(#"Reordered Columns", {"EmployeeKey"})
      in
      #"Removed Duplicates"
