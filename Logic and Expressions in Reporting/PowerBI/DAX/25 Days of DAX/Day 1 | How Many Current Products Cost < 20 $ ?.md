
How Many Current Products Cost < 20 $ ?

OK, So Current products means that the Products is **NOT** Discountinued, also the Unit price field comes from the Product Table


Solution: 
DAX

    CurrentProducts = 
    
        CALCULATE(DISTINCTCOUNT(Products[ProductID]) , 
        
            FILTER(Products, Products[Unit Price] < 20 && Products[Discontinued] = FALSE())  )

