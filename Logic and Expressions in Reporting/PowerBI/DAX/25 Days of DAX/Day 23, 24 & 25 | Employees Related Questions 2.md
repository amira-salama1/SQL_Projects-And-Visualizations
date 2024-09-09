

D 23 Top Sales By Emp = 

    CALCULATE(SELECTEDVALUE(Employees[Full Name]), 

      TOPN(1, Employees,
         
         CALCULATE([Total sales], 'Calendar'[Year] = YEAR(TODAY() ) ),  DESC) )
