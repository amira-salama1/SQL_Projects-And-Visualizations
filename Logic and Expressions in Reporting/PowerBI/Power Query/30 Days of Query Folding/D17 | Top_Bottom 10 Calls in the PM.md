D 17 | Select Top/Bottom  10 Calls using a custom column (TotalTime = Calls * AverageTimePerIssue) for the PM Calls Shift

    let
    Source = Sql.Databases("localhost"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_FactCallCenter = AdventureWorksDW2017{[Schema="dbo",Item="FactCallCenter"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(dbo_FactCallCenter,{"DateKey", "Shift", "Calls", "AverageTimePerIssue"}),
    #"Added Custom" = Table.AddColumn(#"Removed Other Columns", "Custom", each if Text.Contains( [Shift] , "PM" ) 
    then [Calls] * [AverageTimePerIssue] else 0),
        #"Renamed Columns" = Table.RenameColumns(#"Added Custom",{{"Custom", "TotalTime"}}),
        #"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each ([TotalTime] <> 0)),
        #"Add Asc Index" = Table.AddRankColumn(  #"Filtered Rows", 
            "RankAsc",
            {"TotalTime", Order.Ascending},
            [RankKind = RankKind.Dense]
                ),
    
        #"Add Desc Index" = Table.AddRankColumn(  #"Add Asc Index", 
            "RankDesc",
            {"TotalTime", Order.Descending},
            [RankKind = RankKind.Dense]
                ),
    
        #"Selected Rows" = Table.SelectRows(#"Add Desc Index", each ([RankAsc] >=1 and [RankAsc] <= 10)
        or ([RankDesc] >=1 and [RankDesc] <= 10)
        ),
        #"Removed Other Columns1" = Table.SelectColumns(#"Selected Rows",{"DateKey", "Shift", "Calls", "AverageTimePerIssue", "TotalTime"}),
        #"Sorted Rows" = Table.Sort(#"Removed Other Columns1",{{"TotalTime", Order.Ascending}})
    
        
    in
        #"Sorted Rows"
