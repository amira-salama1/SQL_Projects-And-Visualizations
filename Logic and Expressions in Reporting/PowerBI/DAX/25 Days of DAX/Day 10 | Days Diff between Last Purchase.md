Day 10 | How many Days Differnece between Last Purchase date of North/South Customer and Today's Date ??

Solution: I Did that without the Variable, and abviousely each date will be relative according to which date you're calculating from!

North_South Last Purchase = 

CALCULATE(

  DATEDIFF(LASTDATE(Orders[OrderDate]),TODAY(), DAY) , Customers[CompanyName] = "North/South" )
