D14 Customer's Who Didn't Purchase "Queso Cabrales" 

* Solution

D14 Customers Who Didn't Purchase a specific Product = 

    CALCULATE( 
    
        DISTINCTCOUNT(Customers[CustomerID]) -
        
            CALCULATE(
            
                    DISTINCTCOUNT(Orders[CustomerID]), FILTER(Products, Products[ProductName] = "Queso Cabrales")) )
