How Many Customers ordered the Current Year (2021)

OK, so this is more like: Count customer with their first Purchase this Year!

Solution: Count Rows, Filter & Summarize

Cust Order Cnt in Current Year = 

    Var Jan1st = DATE(2021,01,01)
  
      RETURN
    
        COUNTROWS(
      
          FILTER(
        
            SUMMARIZE(Orders, Customers[CustomerID], "First Date" , MIN(Orders[OrderDate])) , [First Date] >= Jan1st))
