

D 21 How Many Employees are Females %= 
    
    VAR AllEmpl = COUNTA(Employees[EmployeeID])
    
      RETURN
      
        DIVIDE(
        
          CALCULATE( COUNTA(Employees[EmployeeID]), Employees[Gender] = "Female") , AllEmpl) 



D22 How many empl > 60 = 

        CALCULATE(
                
                COUNTA(Employees[EmployeeID]) , Employees[Age] > 60 )
