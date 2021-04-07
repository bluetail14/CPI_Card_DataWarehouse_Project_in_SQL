AQ1

-- Cumulative amount ordered by location, year and order by month

Location name, contract year, contract month, sum of job amount ordered, cumulative sum of amount ordered

SELECT   Location_Name, Time_Year, Time_Month,
  SUM ( Quantity_Ordered * Unit_Price ) AS SumJobAmt,
  SUM ( SUM ( Quantity_Ordered * Unit_Price ) )
    OVER ( PARTITION BY Location_Name, Time_Year
      ORDER BY Time_Month
      ROWS UNBOUNDED PRECEDING ) AS CumSumAmt

FROM W_Job_f j, W_Location_d l, W_Time_d t

WHERE l.Location_ID = j.Location_Id
  AND j.Contract_Date = t.Time_ID
GROUP BY Location_Name, Time_Year, Time_Month;







AQ2

-- Moving average over current row and 11 preceding rows of average amount for location ordered by year and month

Location name, contract year, contract month, average of job amount ordered, Moving average of average amount ordered

SELECT Location_Name, Time_Year, Time_Month,
AVG( Quantity_Ordered * Unit_Price ) AS AvgJobAmount ,
  AVG( AVG( Quantity_Ordered * Unit_Price ) )

OVER (PARTITION BY Location_Name
ORDER BY Time_Year, Time_Month
ROWS 11 PRECEDING) AS MovAvgAmount

FROM W_Job_f j, W_Location_d l, W_Time_d t
WHERE l.Location_ID = j.Location_Id
  AND j.Contract_Date = t.Time_ID

GROUP BY Location_Name, Time_Year, Time_Month






AQ3

-- Rank locations by descending sum of annual profit in descending order of annual sum of profit; Restart ranks for each year

Location name, contract year, contract month, sum of profit

SELECT X1.Location_Name, X1.Time_Year,
       SUM(SumInvoiceAmt - TotalCosts) AS SumLocProfit,
       RANK() OVER ( PARTITION BY X1.Time_Year
        ORDER BY ( SUM(SumInvoiceAmt - TotalCosts) ) DESC ) AS RankProfitSum

FROM LocCostSummary X1, LocRevenueSummary X2

WHERE X1.Job_Id = X2.Job_Id

GROUP BY X1.Location_Name, X1.Time_Year;



AQ4

-- Rank locations by descending annual profit margin; Restart ranks for each year

SELECT X1.Location_Name, X1.Time_Year,
       SUM (SumInvoiceAmt - TotalCosts) / SUM(SumInvoiceAmt) AS ProfitMargin,
       RANK() OVER ( PARTITION BY X1.Time_Year
        ORDER BY ( SUM (SumInvoiceAmt - TotalCosts) / SUM(SumInvoiceAmt) ) DESC )  AS RankProfitMargin
FROM LocCostSummary X1, LocRevenueSummary X2
WHERE X1.Job_Id = X2.Job_Id
GROUP BY X1.Location_Name, X1.Time_Year;



AQ5

--- Percent rank of job profit margins for locations

Job id, location name, contract year, contract month, profit margin

SELECT X1.Job_Id, X1.Location_Name, X1.Time_Year, X1.Time_Year,
       (SumInvoiceAmt - TotalCosts) / SumInvoiceAmt AS ProfitMargin,
       PERCENT_RANK() OVER (
        ORDER BY ( (SumInvoiceAmt - TotalCosts) / SumInvoiceAmt ) )
         AS PercentRankProfitMargin

 FROM LocCostSummary X1, LocRevenueSummary X2
 WHERE X1.Job_Id = X2.Job_Id;



AQ6
--- Top performers of percent rank of job profit margins for locations

Job id, location name, contract year, contract month, profit margin

SELECT Job_Id, Location_Name, Time_Year, Time_Month,
       ProfitMargin, PercentRankProfitMargin

 FROM (
  SELECT X1.Job_Id, X1.Location_Name, X1.Time_Year, X1.Time_Month,
         (SumInvoiceAmt - TotalCosts) / SumInvoiceAmt AS ProfitMargin,
         PERCENT_RANK() OVER (
         ORDER BY ( (SumInvoiceAmt - TotalCosts) / SumInvoiceAmt ) )
          AS PercentRankProfitMargin
  FROM LocCostSummary X1, LocRevenueSummary X2

WHERE X1.Job_Id = X2.Job_Id ) X
 WHERE PercentRankProfitMargin > 0.95;


AQ7

-- Rank sales class by sum of return quantity in descending order; Partition rank by year of the date sent

Sales class description, year of date sent, sum of return quantity

SELECT Sales_Class_Desc, Time_Year,
  SUM ( quantity_shipped - invoice_quantity ) as ReturnSum ,
  RANK() over ( PARTITION BY Time_Year
    ORDER BY SUM ( quantity_shipped - invoice_quantity ) DESC )
     AS RankReturnSum

 FROM W_InvoiceLine_F i, W_TIME_D t, W_Sales_Class_D s

WHERE quantity_shipped > invoice_quantity
              AND i.Invoice_Sent_Date = t.Time_ID
              AND  i.Sales_Class_ID = s.Sales_Class_ID
 GROUP BY Sales_Class_Desc, Time_Year;

AQ8

--- Ratio to report of sum of return quantity; Restart ratios for each date sent year
Sales class description, year of date sent, sum of return quantity

SELECT X1.Time_Year, Sales_Class_Desc, SumReturnQty,
       SumReturnQty/SumYearReturnQty AS RatioReturnSum

FROM
  ( SELECT Time_Year, Sales_Class_Desc,
           CAST(SUM ( quantity_shipped - invoice_quantity )
            AS DOUBLE PRECISION) AS SumReturnQty
    FROM W_InvoiceLine_F i,  W_Time_D t, W_Sales_Class_D sc
    WHERE i.Invoice_Sent_Date = t.Time_ID
   AND  i.Sales_Class_Id = sc.Sales_Class_Id
    AND quantity_shipped > invoice_quantity
    GROUP BY Sales_Class_Desc, Time_Year ) X1,
  ( SELECT Time_Year,
           CAST(SUM ( quantity_shipped - invoice_quantity )
            AS DOUBLE PRECISION) AS SumYearReturnQty

 FROM W_InvoiceLine_F i, W_Time_D t
WHERE  i.Invoice_Sent_Date = t.Time_ID
   AND quantity_shipped > invoice_quantity

    GROUP BY Time_Year ) X2

 WHERE X1.Time_Year = X2.Time_Year
 ORDER BY X1.Time_Year, SumReturnQty;

AQ9
--- Rank locations by sum of business days delayedin descending order of sum of business days delayed; Use both ranking functions; Restart rankings on year of shipped by date

Location name, year of date shipped by, sum of difference in business days

SELECT Location_Name, W_Time_D.Time_Year,
       SUM(BusDaysDiff) as SumDelayDays,
  RANK() OVER ( PARTITION BY W_Time_D.Time_Year
    ORDER BY SUM(BusDaysDiff) DESC) AS RankSumDelayDays,
  DENSE_RANK() OVER ( PARTITION BY W_Time_D.Time_Year
    ORDER BY SUM(BusDaysDiff) DESC) AS RankSumDelayDays
 FROM FirstShipmentDelays, W_Time_D
 WHERE W_Time_D.Time_Id = FirstShipmentDelays.Date_Ship_By
 GROUP BY Location_Name, W_Time_D.Time_Year;


AQ10

---Rank locations by delay rate for jobs in descending order of delay rate; Restart rankings on year of date promised

Location name, year of date promised,  count of delayed jobs, sum of difference in business days

SELECT Location_Name, W_Time_D.Time_Year,
       COUNT(*) AS NumJobs,
       SUM(BusDaysDiff) as SumDelayDays,
       SUM(Quantity_Ordered - SumDelayShipQty) / SUM(Quantity_Ordered)
        AS PromisedDelayRate,
  RANK() OVER ( PARTITION BY W_Time_D.Time_Year
    ORDER BY SUM(Quantity_Ordered - SumDelayShipQty) /
             SUM(Quantity_Ordered) DESC) AS RankDelayRate
 FROM LastShipmentDelays, W_Time_D
 WHERE W_Time_D.Time_Id = LastShipmentDelays.Date_Promised
 GROUP BY Location_Name, W_Time_D.Time_Year;
