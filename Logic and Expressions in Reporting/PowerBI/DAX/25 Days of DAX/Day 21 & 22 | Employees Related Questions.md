

D 21 How Many Employees are Females %= 
    
    VAR AllEmpl = COUNTA(Employees[EmployeeID])
    
      RETURN
      
        DIVIDE(
        
          CALCULATE( COUNTA(Employees[EmployeeID]), Employees[Gender] = "Female") , AllEmpl) 
