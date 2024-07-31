Day 6 : what is the Average Orders Size? 

  I was tricked by the answer that it had $ sign to it, so I was confused, the order size is the Average of the count of orders per order ID.

Solution:

Create a summarized table to get the count of each product per Order 

  * Avg Order Size =
  
     AVERAGEX(SUMMARIZE(Orders, Orders[OrderID], "Count ProductID", COUNTA(Products[ProductID])), 
    [Count ProductID])


Day 7 : What is the Value ($) for the unshipped Orders ?

Solution:

Unshipped Orders Value = CALCULATE([Total sales], ISBLANK(Orders[ShippedDate]))
