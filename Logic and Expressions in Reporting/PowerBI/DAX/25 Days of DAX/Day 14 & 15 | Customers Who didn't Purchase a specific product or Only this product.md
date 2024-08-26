D14 Customer's Who Didn't Purchase "Queso Cabrales" 

* Solution

D14 Customers Who Didn't Purchase a specific Product = 

    CALCULATE( 
    
        DISTINCTCOUNT(Customers[CustomerID]) -
        
            CALCULATE(
            
                    DISTINCTCOUNT(Orders[CustomerID]), FILTER(Products, Products[ProductName] = "Queso Cabrales")) )



D15 the Count of Customers who only purchased a specific Product:

* Solution

D 15 Customers who Purchased Only a Certain Product = 

    COUNTROWS(
    
        VAR QC_Cust = CALCULATETABLE(VALUES(Orders[OrderID]), FILTER(Orders, Orders[ProductID]= 11))
        
        VAR ONE_Time_Cust =
        
            SUMMARIZE(
            
                FILTER(
                    SUMMARIZE(Orders, Orders[OrderID], "OrderCount", COUNT(Orders[ProductID] )), [OrderCount] = 1 ), Orders[OrderID])
            
            RETURN
            
                INTERSECT(ONE_Time_Cust, QC_Cust))
