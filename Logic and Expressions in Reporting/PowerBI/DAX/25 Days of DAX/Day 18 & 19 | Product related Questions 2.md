D18 How many Units in an Order needs to be restocked =

    CALCULATE(
        
        COUNTA(Products[ProductID]), 
        
            FILTER(Products, Products[Stocked units] < Products[Units In Order]) )


D19 what is Discontinued Product value = 

    CALCULATE(SUMX(Products,
    
        Products[UnitsInStock]*Products[UnitPrice]), Products[Discontinued] = TRUE())
