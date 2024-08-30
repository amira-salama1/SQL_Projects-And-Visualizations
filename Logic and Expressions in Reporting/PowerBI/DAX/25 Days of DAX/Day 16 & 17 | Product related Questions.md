D16 How many products are out of stock = 

    CALCULATE(
    
        COUNT(Products[ProductID]), Products[UnitsInStock] = 0 
            )


D17 How many Products needs to be restocked = 

* Here is when the Products in Stock is less in Quantity than than the Reorder level, so so the Reorder level is a flag to not go below it.

        CALCULATE(
            
            COUNTA(Products[ProductID]), 
                
                FILTER(Products, Products[Stocked units] < Products[ReorderLevel]) )
