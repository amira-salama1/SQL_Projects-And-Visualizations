D18 How many Units in an Order needs to be restocked =

    CALCULATE(
        
        COUNTA(Products[ProductID]), 
        
            FILTER(Products, Products[Stocked units] < Products[Units In Order]) )


D19 what is Discontinued Product value = 

    CALCULATE(SUMX(Products,
    
        Products[UnitsInStock]*Products[UnitPrice]), Products[Discontinued] = TRUE())




D20 Top 1 Supplier Stock Value = 

    CALCULATE(SELECTEDVALUE(Suppliers[CompanyName]), 
        
        TOPN(1,
            
            SUMMARIZE(Products, Suppliers[CompanyName], "UnitsStock", 
            
                    SUMX(Products, Products[UnitPrice]*Products[Stocked units])), [UnitsStock], DESC))



