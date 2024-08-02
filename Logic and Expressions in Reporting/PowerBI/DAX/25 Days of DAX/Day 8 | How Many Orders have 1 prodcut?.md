How Many Orders Have only a single Item/Product ?

Solution:

Orders with One Product 2 = 

COUNTROWS( 
   
   FILTER(

      SUMMARIZE(Orders, Orders[OrderID], "Count ProductID", COUNTA(Orders[ProductID])), [Count ProductID] = 1 ) )
