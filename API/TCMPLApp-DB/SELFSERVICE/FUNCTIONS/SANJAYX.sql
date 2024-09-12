--------------------------------------------------------
--  DDL for Function SANJAYX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."SANJAYX" return number is
n number;
 begin 
 n := network_data_printer.deleteKyoceraCanonData('20190404154940');
 End;


/
