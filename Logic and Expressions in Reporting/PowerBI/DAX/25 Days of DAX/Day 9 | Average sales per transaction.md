Day 9 | Average sales per transaction For Customer "Romero Y Tomillo" ??

This where you want to get the Total Sales per Order ID then Average those.

solution:

Average Order Value For Specific Customer = 

CALCULATE(

  AVERAGEX(VALUES(Orders[OrderID]), [Total sales]), LEFT(Customers[CompanyName] ,6) = "Romero" )  



