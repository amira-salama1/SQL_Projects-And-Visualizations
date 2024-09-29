D15 | Top 10 Longest Deliveries 

    Table.AddRankColumn(  #"Sorted Rows",
      "Rank",
      {"Avg Days to Deliver", Order.Descending},
      [RankKind = RankKind.Dense]
          )
