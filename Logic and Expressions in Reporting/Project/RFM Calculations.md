This file is listing the RFM calculations in Power BI

Using AdventureWorksDW (link: https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=tsql )

#### 1st step : Creating Basic Calculations

We need to Calculate the following Measures: 

* **Last Purchase Date** = LASTDATE(FactInternetSales[OrderDate])
* **Recency** = DATEDIFF([Last Purchase Date], CALCULATE ( MAX ( FactInternetSales[OrderDate] ), ALLSELECTED ( FactInternetSales ), FactInternetSales[OrderDate] <= NOW() ) +1, DAY)
* **Frequency** = DISTINCTCOUNT(FactInternetSales[SalesOrderNumber])
* **Monetary** = CALCULATE(
              SUM(FactInternetSales[SalesAmount]), 
              ALLEXCEPT(FactInternetSales, FactInternetSales[CustomerKey]) )

#### 2nd step : Building the Summary Table
        Custom RFM = 
      
      SUMMARIZE(
          FactInternetSales, 
          DimCustomer[CustomerKey], 
          "Last Purchase", [Last Purchase Date],
          "Recency", [Recency], 
          "Monetary", [Monetary value] ,
          "Frequency", [Freq],
          "LastDate", CALCULATE ( MAX ( FactInternetSales[OrderDate] ), ALLSELECTED ( FactInternetSales ), FactInternetSales[OrderDate] <= NOW() ) +1
      )
