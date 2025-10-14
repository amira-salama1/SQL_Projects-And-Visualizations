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

  **Notes**:
  *  Last Purchase Date : is the Universal Last date given in the Dataset & it acts as a pivot point to calculate how recent were the purchases

#### 2nd step : Building the Summary Table
        Custom RFM = 
      
      SUMMARIZE(
          FactInternetSales, 
          DimCustomer[CustomerKey], 
          "Last Purchase", [Last Purchase Date],
          "Recency", [Recency], 
          "Monetary", [Monetary value] ,
          "Frequency", [Freq],
          "LastDate", CALCULATE ( MAX ( FactInternetSales[OrderDate] ), 
                          ALLSELECTED ( FactInternetSales ), FactInternetSales[OrderDate] <= NOW() ) +1
      )

   Notes:
   * The summary table acts as a Pivot table with the Customer as the Dimension (row level detail one customer per row) and the RFM are the metrics for each row/Customer
