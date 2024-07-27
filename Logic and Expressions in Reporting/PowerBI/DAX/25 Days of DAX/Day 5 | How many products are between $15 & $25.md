How many products Cost between (Inclusive) $15 & $25 ??

So this one is close to the Day 4, I used the same Formula with some modifications:

Products between Prices 15 and 25 = 

  CALCULATE(COUNTROWS(Products), FILTER(Products, [UnitPrice] >= 15 && [UnitPrice] <= 25))
