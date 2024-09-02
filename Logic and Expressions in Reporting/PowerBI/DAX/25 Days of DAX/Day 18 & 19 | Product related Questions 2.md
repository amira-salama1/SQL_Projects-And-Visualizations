D18 How many Units in an Order needs to be restocked =

    CALCULATE(
        
        COUNTA(Products[ProductID]), 
        
            FILTER(Products, Products[Stocked units] < Products[Units In Order]) )
