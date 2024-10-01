D15 | Top 10 Longest Deliveries 

so in the Challenge the Author mentioned to include the Cities with the same rank (Dense Rank) of Longest deliveries.

    Table.AddRankColumn(  #"Sorted Rows",
      "Rank",
      {"Avg Days to Deliver", Order.Descending},
      [RankKind = RankKind.Dense]
          )

The Whole code here after joining the Fast Sales & Fact Order:

     let
    Source = Table.NestedJoin(#"Fact Order (2)", {"Order Key"}, #"Fact Sale", {"Sale Key"}, "Fact Sale", JoinKind.Inner),
    #"Expanded Fact Sale" = Table.ExpandTableColumn(Source, "Fact Sale", {"City Key", "Delivery Date Key"}, {"Fact Sale.City Key", "Fact Sale.Delivery Date Key"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Expanded Fact Sale",{"Order Key", "City Key", "Fact Sale.City Key", "Order Date Key", "Fact Sale.Delivery Date Key"}),
    #"Added Custom" = Table.AddColumn(#"Reordered Columns", "Custom", each Duration.TotalDays([Fact Sale.Delivery Date Key]-[Order Date Key])),
    #"Removed Other Columns" = Table.SelectColumns(#"Added Custom",{"City Key", "Custom"}),
    #"Grouped Rows" = Table.Group(#"Removed Other Columns", {"City Key"}, {{"Count", each List.Average([Custom]), type number}}),
    #"Rounded Up" = Table.TransformColumns(#"Grouped Rows",{{"Count", Number.RoundUp, Int64.Type}}),
    #"Renamed Columns" = Table.RenameColumns(#"Rounded Up",{{"Count", "Avg Days to Deliver"}}),
    #"Sorted Rows" = Table.Sort(#"Renamed Columns",{{"Avg Days to Deliver", Order.Descending}}),


    #"Added Custom1" = Table.AddRankColumn(  #"Sorted Rows",
    "Rank",
    {"Avg Days to Deliver", Order.Descending},
    [RankKind = RankKind.Dense]
        ),
    #"Filtered Rows" = Table.SelectRows(#"Added Custom1", each [Rank] >= 1 and [Rank] <= 10),
    #"Merged Queries" = Table.NestedJoin(#"Filtered Rows", {"City Key"}, #"Dimension City", {"City Key"}, "Dimension City", JoinKind.Inner),
    #"Expanded Dimension City" = Table.ExpandTableColumn(#"Merged Queries", "Dimension City", {"City"}, {"Dimension City.City"}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Expanded Dimension City",{"City Key", "Dimension City.City", "Avg Days to Deliver", "Rank"}),
    #"Sorted Rows1" = Table.Sort(#"Reordered Columns1",{{"Avg Days to Deliver", Order.Descending}}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Sorted Rows1",{"City Key", "Dimension City.City", "Avg Days to Deliver"})
    in
    #"Removed Other Columns1"   
