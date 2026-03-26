
/*SAVE Frequently used sql code in stored procedures in database using CREATE OR ALTER PROCEDURE
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables*/


CREATE OR ALTER PROCEDURE Bronze.load_Bronze AS
BEGIN
  
  DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
  BEGIN TRY
  SET @batch_start_time = GETDATE();
    
        PRINT'===================================================================';
        PRINT 'Loading Bronze layer';
        PRINT'===================================================================';

        PRINT'-------------------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT'-------------------------------------------------------------------';
        SET @start_time = GETDATE();
        PRINT'>> Truncating Table:Bronze.crm_cust_info';
        TRUNCATE TABLE Bronze.crm_cust_info --FULL LOAD, so we emptying table and then inserting data in the same table
        PRINT'>> Inserting Data into:Bronze.crm_cust_info';
        BULK INSERT Bronze.crm_cust_info 
        FROM 'C:sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
              FIRSTROW = 2,
              FIELDTERMINATOR = ',',
              TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT'>> Loading duration is: '+ CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+' seconds';
        PRINT'-------------------------------'
        --SELECT * FROM Bronze.crm_cust_info
        --SELECT COUNT(*) FROM Bronze.crm_cust_info

        SET @start_time = GETDATE();
        PRINT'>> Truncating Table:Bronze.crm_prd_info';
        TRUNCATE TABLE Bronze.crm_prd_info
        PRINT'>> Inserting Data into:Bronze.crm_prd_info';
        BULK INSERT Bronze.crm_prd_info 
        FROM 'C:sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
              FIRSTROW = 2,
              FIELDTERMINATOR = ',',
              TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT'>> Loding Duration is: '+ CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+' seconds'
        PRINT'-------------------------------'
        --SELECT * FROM Bronze.crm_prd_info
        SET @start_time = GETDATE();
        PRINT'>> Truncating Table:Bronze.crm_sales_details';
        TRUNCATE TABLE Bronze.crm_sales_details
        PRINT'>> Inserting Data into:Bronze.crm_sales_details';
        BULK INSERT Bronze.crm_sales_details 
        FROM 'C:sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
             FIRSTROW = 2,
             FIELDTERMINATOR = ',',
             TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT'>> Loading duration is: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +' seconds';
        PRINT'-------------------------------'
        --SELECT COUNT(*) FROM Bronze.crm_sales_details
        SET @start_time = GETDATE();
        PRINT'-------------------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT'-------------------------------------------------------------------';

        PRINT'>> Truncating Table:Bronze.erp_cust_az12';
        TRUNCATE TABLE Bronze.erp_cust_az12
        PRINT'>> Inserting Data into:Bronze.erp_cust_az12';
        BULK INSERT Bronze.erp_cust_az12 
        FROM 'C:sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
              FIRSTROW = 2,
              FIELDTERMINATOR = ',',
              TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT'>> Loading Duration is: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT'-------------------------------'
        --SELECT * FROM Bronze.erp_cust_az12
        SET @start_time = GETDATE();
        PRINT'>> Truncating Table:Bronze.erp_loc_a101';
        TRUNCATE TABLE Bronze.erp_loc_a101
        PRINT'>> Inserting Data into:Bronze.erp_loc_a101';
        BULK INSERT Bronze.erp_loc_a101
        FROM 'C:sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
              FIRSTROW = 2,
              FIELDTERMINATOR = ',',
              TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT'>> Loading duration is: '+ CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+ ' seconds';
        PRINT'-------------------------------'
        --SELECT * FROM Bronze.erp_loc_a101
        SET @start_time = GETDATE();
        PRINT'>> Truncating Table:Bronze.erp_px_cat_g1v1';
        TRUNCATE TABLE Bronze.erp_px_cat_g1v1
        PRINT'>> Inserting Data into:Bronze.erp_px_cat_g1v1';
        BULK INSERT Bronze.erp_px_cat_g1v1
        FROM 'C:sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
              FIRSTROW = 2,
              FIELDTERMINATOR = ',',
              TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT'>> Loading duration is: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR)+ ' seconds';
        PRINT'-------------------------------'
        --SELECT COUNT(*) FROM Bronze.erp_px_cat_g1v1
    SET @batch_end_time = GETDATE();
    PRINT'==============================================================='
    PRINT'Loading of Bronze Layer is completed'
    PRINT'  :Total duration of '+ CAST( DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR)+ ' seconds'
    PRINT'==============================================================='
   
    END TRY
    BEGIN CATCH
    PRINT'==============================================================='
    PRINT'Error occured during loading Bronze layer'
    PRINT'Error Message'+ Error_Message();
    PRINT'Error Message'+ CAST (Error_Number() AS NVARCHAR);
    PRINT 'Error Message'+ CAST(Error_State() AS NVARCHAR);
    PRINT'==============================================================='
    END CATCH
END
