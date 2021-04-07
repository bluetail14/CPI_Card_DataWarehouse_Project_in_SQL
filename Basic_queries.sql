BQ1.
-- Location and sales class summary of job quantity and amount

Location id, location name, sales class id, sales class description, year of job contract date, month of job contract date, base price of sales class, sum of quantity ordered, sum of job amount
SELECT l.Location_Id, Location_Name,
sc.Sales_Class_Id, Sales_Class_Desc, Base_Price,
Time_Year, Time_Month,
SUM ( Quantity_Ordered ) AS Sum_Job_Qty,
SUM ( Quantity_Ordered * Unit_Price ) AS Sum_Job_Amount

FROM W_Job_F j, W_Location_D l, W_Time_D , W_Sales_Class_D sc

WHERE l.Location_ID = j.Location_Id
   AND j.Contract_Date = Time_ID
   AND j.Sales_Class_Id = sc.Sales_Class_Id

GROUP BY l.Location_Id, Location_Name,
          sc.Sales_Class_Id, Sales_Class_Desc,
          Base_Price, Time_Year, Time_Month;

          BQ2.
          -- Location invoice revenue summary

          Job id, location id, location name, job unit price, job order quantity, year of contract date, month of contract date, sum of invoice amount, sum of invoice quantity
          SELECT j.job_Id, l.Location_Id, Location_Name, Quantity_Ordered, Unit_Price,
          Time_Year, Time_Month,
          SUM(Invoice_Quantity) AS SumInvQty,
          SUM(Invoice_Amount) AS SumInvAmt

          FROM W_Job_F j, W_Location_D l, W_InvoiceLine_F i, W_Time_D t

          WHERE  t.Time_Id = j.Contract_Date
                         AND l.Location_ID = j.Location_Id
                         AND l.Location_Id = i.Location_Id

          GROUP BY j.job_Id, Quantity_Ordered, Unit_Price, l.Location_Id, Location_Name,
          Time_Year, Time_Month;

          -- CREATE VIEW statement

          CREATE VIEW LocRevenueSummary AS
           SELECT j.job_Id, Quantity_Ordered, Unit_Price, l.Location_Id, Location_Name,
          Time_Year, Time_Month,
                  SUM (Invoice_Quantity) AS SumInvoiceQty,
                  SUM (Invoice_Amount) AS SumInvoiceAmt

            FROM W_Job_F j, W_Location_D l, W_InvoiceLine_F i, W_Time_D t
           WHERE t.Time_Id = j.Contract_Date
                         AND l.Location_ID = j.Location_Id
                         AND l.Location_Id = i.Location_Id

            GROUP BY j.job_Id, Quantity_Ordered, Unit_Price, l.Location_Id, Location_Name,
          Time_Year, Time_Month;

          BQ3.

          ---Location Subjob cost summary
          Job id, location id, location name, year of contract date, month of contract date, sum of labor cost, sum of material cost, sum of machine cost, sum of overhead costs, sum of total costs, sum of quantity produced, unit cost


          SELECT sj.Job_Id,
                 l.Location_ID , Location_Name,
                 t.Time_Year,  t.Time_Month,
                 SUM(Cost_Labor) AS SumLaborCosts,
                 SUM(Cost_Material) AS SumMaterialCosts,
                 SUM(Cost_Overhead) AS SumOverheadCosts,
                 SUM(Machine_Hours * Rate_Per_Hour) AS SumMachineCosts,
                 SUM(Quantity_Produced) AS SumQtyProduced,
                 SUM(Cost_Labor + Cost_Material + Cost_Overhead +
                      (Machine_Hours * Rate_Per_Hour) ) AS TotalCosts,
                 SUM( Cost_Labor + Cost_Material + Cost_Overhead + (Machine_Hours *
                      Rate_Per_Hour) ) / SUM(Quantity_Produced)  AS UnitCost

          FROM W_Job_F j, W_Sub_Job_F sj,  W_Location_D l, W_InvoiceLine_F i, W_Time_D t, W_Machine_Type_D m

          WHERE sj.Location_Id = l.Location_Id
             AND sj.Machine_Type_Id = m.Machine_Type_Id
             AND t.Time_Id = j.Contract_Date
             AND j.Job_Id = sj.Job_Id
          AND sj.Location_Id = i.Location_Id

           GROUP BY sj.Job_Id, l.Location_ID,
                    l.Location_Name, Time_Year, Time_Month;


          CREATE VIEW LocCostSummary AS

          SELECT sj.Job_Id,
                 l.Location_ID , Location_Name,
                 t.Time_Year,  t.Time_Month,
                 SUM(Cost_Labor) AS SumLaborCosts,
                 SUM(Cost_Material) AS SumMaterialCosts,
                 SUM(Cost_Overhead) AS SumOverheadCosts,
                 SUM(Machine_Hours * Rate_Per_Hour) AS SumMachineCosts,
                 SUM(Quantity_Produced) AS SumQtyProduced,
                 SUM(Cost_Labor + Cost_Material + Cost_Overhead +
                      (Machine_Hours * Rate_Per_Hour) ) AS TotalCosts,
                 SUM( Cost_Labor + Cost_Material + Cost_Overhead + (Machine_Hours *
                      Rate_Per_Hour) ) / SUM(Quantity_Produced)  AS UnitCost

          FROM W_Job_F j, W_Sub_Job_F sj,  W_Location_D l, W_InvoiceLine_F i, W_Time_D t, W_Machine_Type_D m

          WHERE sj.Location_Id = l.Location_Id
             AND sj.Machine_Type_Id = m.Machine_Type_Id
             AND t.Time_Id = j.Contract_Date
             AND j.Job_Id = sj.Job_Id
             AND sj.Location_Id = i.Location_Id

           GROUP BY sj.Job_Id, l.Location_ID,
                    l.Location_Name, Time_Year, Time_Month;
                    BQ4.
                    -- Return quantity and amount by location and sales class

                    Location id, location name, sales class id, sales class description, year of invoice sent date, month of invoice sent date, sum of quantity returned, sum of dollar amount of returns

                    SELECT  l.Location_Id, Location_Name,  sc.Sales_Class_Id, Sales_Class_Desc,  Time_Year,
                                  Time_Month,
                                  SUM ( Quantity_Shipped - Invoice_quantity ) as SumReturnQty,
                                  SUM ( (Quantity_Shipped - Invoice_quantity) *  (invoice_amount/invoice_quantity) ) AS SumReturnAmt

                    FROM W_Location_D l, W_InvoiceLine_F i, W_Sales_Class_D sc, W_Time_D t

                    WHERE      Quantity_shipped > Invoice_quantity
                                       AND t.TIME_Id = i.Invoice_Sent_Date
                                       AND l.Location_Id = i.Location_ID
                                       AND sc.Sales_Class_Id = i.Sales_Class_Id

                    GROUP BY  l.Location_Id, Location_Name,  sc.Sales_Class_Id, Sales_Class_Desc,  Time_Year,  Time_Month;
                    BQ5.
                    --- Last shipment delays involving date promised

                    Job id, location id, location name, sales class id, sales class description, time id of the date promised for the job, time id of the last shipment date, order quantity in the job, sum of shipped quantity after job promised date, difference in business days between last shipment date and promised date

                    SELECT W_Job_F.job_ID, W_Job_F.Location_ID, Location_Name,
                    W_Job_F.Sales_Class_ID, Sales_Class_Desc,
                      Date_Promised, Last_Shipment_Date,
                      Quantity_Ordered, SumDelayShipQty,
                      GetBusDaysDiff ( Date_Promised, Last_Shipment_Date ) AS BusDaysDiff

                    FROM W_Job_F , W_Location_D, W_Sales_Class_D,
                      (SELECT W_Sub_Job_F.Job_ID,
                        MAX(Actual_Ship_Date)   AS Last_Shipment_Date,
                        SUM ( Actual_Quantity ) AS SumDelayShipQty
                      FROM W_Job_Shipment_F, W_Sub_Job_F, W_Job_F
                      WHERE W_Sub_Job_F.Sub_Job_ID = W_Job_Shipment_F.Sub_Job_ID
                        AND W_Job_F.Job_Id = W_Sub_Job_F.Job_ID
                        AND Actual_Ship_Date > Date_Promised
                      GROUP BY W_Sub_Job_F.Job_ID
                      ) X1
                    WHERE Date_Promised < X1.Last_Shipment_Date
                      AND W_Job_F.Job_ID  = X1.Job_Id
                      AND W_Job_F.Location_Id = W_Location_D.Location_Id
                      AND W_Job_F.Sales_Class_Id = W_Sales_Class_D.Sales_Class_Id;

                    -- CREATE VIEW statement using the base query

                    CREATE VIEW LastShipmentDelays AS
                     SELECT W_Job_F.job_ID , W_Job_F.Location_ID, Location_Name,
                      W_Job_F.Sales_Class_ID, Sales_Class_Desc,
                      Date_Promised, Last_Shipment_Date,
                      Quantity_Ordered, SumDelayShipQty,
                      GetBusDaysDiff ( date_promised, Last_Shipment_Date ) AS BusDaysDiff
                    FROM W_Job_F , W_Location_D, W_Sales_Class_D,
                      (SELECT W_Sub_Job_F.Job_ID,
                        MAX(actual_ship_Date)   AS Last_Shipment_Date,
                        SUM ( actual_Quantity ) AS SumDelayShipQty
                      FROM W_Job_Shipment_F, W_Sub_Job_F, W_Job_F
                      WHERE W_SUB_Job_F.Sub_Job_ID = W_Job_Shipment_F.Sub_Job_ID
                        AND W_Job_F.Job_Id = W_Sub_Job_F.Job_ID
                        AND Actual_Ship_Date > Date_Promised
                      GROUP BY W_Sub_Job_F.Job_ID
                      ) X1
                    WHERE date_promised < X1.Last_Shipment_Date
                      AND W_Job_F.Job_ID  = X1.Job_Id
                      AND W_Job_F.Location_Id = W_Location_D.Location_Id
                      AND W_Job_F.Sales_Class_Id = W_Sales_Class_D.Sales_Class_Id;
                      BQ6.
                      --- First shipment delays involving shipped by date
                      Job id, Location id, location name, sales class id, sales class description, time id of the shipped by date of the job, time id of the first shipment date, difference in business days between first shipment date and contractual shipped by date
                      SELECT W_Job_F.job_ID, W_JOB_F.Location_ID, Location_Name,
                        W_Job_F.Sales_Class_ID, Sales_Class_Desc,  Date_Ship_By,
                        FirstShipDate, GetBusDaysDiff ( date_ship_By, FirstShipDate ) AS BusDaysDiff

                      FROM W_Job_F, W_Location_D, W_Sales_Class_D,
                        (SELECT W_SUB_JOB_F.JOB_ID, MIN(actual_ship_Date) as FirstShipDate
                         FROM W_JOB_SHIPMENT_F, W_SUB_JOB_F
                         WHERE W_SUB_JOB_F.SUB_JOB_ID = W_JOB_SHIPMENT_F.SUB_JOB_ID
                         GROUP BY W_SUB_JOB_F.JOB_ID
                         ) X1
                      WHERE date_ship_By < X1.FirstShipDate
                        AND W_Job_F.Job_ID = X1.Job_Id
                        AND W_Job_F.Location_Id = W_Location_D.Location_Id
                        AND W_Job_F.Sales_Class_Id = W_Sales_Class_D.Sales_Class_Id;


                      -- CREATE VIEW statement using the base query

                      CREATE VIEW FirstShipmentDelays AS
                       SELECT W_JOB_F.job_ID,
                        W_JOB_F.SALES_CLASS_ID, Sales_Class_Desc,
                        W_JOB_F.LOCATION_ID, Location_Name,
                        Date_Ship_By,
                        FirstShipDate,
                        GetBusDaysDiff ( date_Ship_By, FirstShipDate ) AS BusDaysDiff
                      FROM W_Job_F , W_Location_D, W_Sales_Class_D,
                        (SELECT W_Sub_Job_F.Job_ID, MIN(actual_ship_Date) as FirstShipDate
                         FROM W_Job_Shipment_F, W_Sub_Job_F
                         WHERE W_Sub_Job_F.Sub_Job_ID = W_Job_Shipment_F.Sub_Job_ID
                         GROUP BY W_Sub_Job_F.Job_ID
                         ) X1
                      WHERE date_ship_By < X1.FirstShipDate AND W_Job_F.Job_ID = X1.Job_Id
                        AND W_Job_F.Location_Id = W_Location_D.Location_Id
                        AND W_Job_F.Sales_Class_Id = W_Sales_Class_D.Sales_Class_Id;
