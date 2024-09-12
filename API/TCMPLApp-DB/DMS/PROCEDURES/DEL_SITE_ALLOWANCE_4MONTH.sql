--------------------------------------------------------
--  DDL for Procedure DEL_SITE_ALLOWANCE_4MONTH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DEL_SITE_ALLOWANCE_4MONTH" AS 
BEGIN
delete from ss_site_allowance_processed where processed_month = '1-AUG-13';
delete from ss_site_allowance_trans where processed_month = '201308';
END DEL_SITE_ALLOWANCE_4MONTH;

/
