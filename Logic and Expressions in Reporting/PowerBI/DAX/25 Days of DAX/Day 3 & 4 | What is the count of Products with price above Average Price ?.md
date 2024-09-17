* What is the Average Unit Price for Our products?

        Avg Unit Price = 

                AVERAGE(Products[UnitPrice])

* What is the count of Products with price above Average Price ?

Products above Avg Price = 

        CALCULATE(COUNTROWS(Products), 
        
                FILTER(Products, [UnitPrice] > AVERAGE(Products[UnitPrice]) ))
