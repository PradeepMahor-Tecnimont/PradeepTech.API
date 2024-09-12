--------------------------------------------------------
--  File created - Sunday-April-17-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SWP_FLAGS
---------------------------
ALTER TABLE "SELFSERVICE"."SWP_FLAGS" ADD ("FLAG_VALUE_DATE" DATE);
ALTER TABLE "SELFSERVICE"."SWP_FLAGS" ADD ("FLAG_VALUE_NUMBER" NUMBER);

---------------------------
--New TABLE
--SWP_DEPUTATION_DEPARTMENTS
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_DEPUTATION_DEPARTMENTS" 
   (	"ASSIGN" CHAR(4)
   );
