D16 How many products are out of stock = 

    CALCULATE(
    
        COUNT(Products[ProductID]), Products[UnitsInStock] = 0 
            )

