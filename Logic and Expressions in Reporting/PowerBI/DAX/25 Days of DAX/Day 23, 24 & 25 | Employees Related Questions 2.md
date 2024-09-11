

D 23 Top Sales By Emp = 

    CALCULATE(SELECTEDVALUE(Employees[Full Name]), 

      TOPN(1, Employees,
         
         CALCULATE([Total sales], 'Calendar'[Year] = YEAR(TODAY() ) ),  DESC) )


D24 EMP Count with Sales > 100 K = 

    COUNTROWS(
        
        Var Sales_table = 

            CALCULATETABLE(
 
                 SUMMARIZE(Orders,  Employees[Full Name],'Calendar'[Year], "TotalSalesByEMP" , [Total sales]), 'Calendar'[Year] = YEAR(TODAY()))
     RETURN

    FILTER(Sales_table, [TotalSalesByEMP] > 100000))
