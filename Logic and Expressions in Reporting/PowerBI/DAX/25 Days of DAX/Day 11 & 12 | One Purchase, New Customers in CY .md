Day 11:

How many Customers Purchased only Once ??

Solution CountRows + Filter + Summarize 

Customer Cnt with one orderID = 

    COUNTROWS( 

    FILTER(
    
        SUMMARIZE(Orders, Customers[CustomerID], "Distinct Cnt" , DISTINCTCOUNT(Orders[OrderID])),[Distinct Cnt]  = 1  ) )


Another attractive Solution: Using IF Flagging & SumX:

Cust who Ordered once -Alt = 

    SUMX( Customers,
    
            IF(CALCULATE(DISTINCTCOUNT(Orders[OrderID]) )= 1 , 1 ,  0 ))
