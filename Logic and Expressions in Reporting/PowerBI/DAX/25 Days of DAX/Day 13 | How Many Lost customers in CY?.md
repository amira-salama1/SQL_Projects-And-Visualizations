
Day 13 | How many lost customers/ Inactive customers in the Current year?

  So, our flag here or criteria, is to calculate the latest purchase date, then filter on that to get the Count of Inactive customers in the current year!

D13_Lost_Customers = 

    VAR cy = DATE(YEAR(TODAY()), 01,01)
    
      RETURN
      
        COUNTROWS(

            FILTER(
            
                SUMMARIZE(Orders, Customers[CustomerID], "Last Purchase", 
                
                      LASTNONBLANKVALUE(Orders[CustomerID],MAX(Orders[OrderDate]))), [Last Purchase] <= cy))
