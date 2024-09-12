--------------------------------------------------------
--  File created - Monday-April-04-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SWP_CONFIG_WEEKS
---------------------------
ALTER TABLE "SELFSERVICE"."SWP_CONFIG_WEEKS" ADD ("OWS_OPEN" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SWP_CONFIG_WEEKS" ADD ("PWS_OPEN" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SWP_CONFIG_WEEKS" ADD ("SWS_OPEN" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SWP_CONFIG_WEEKS" ADD ("TO_DEL_PLANNING_OPEN" NUMBER(1,0));
ALTER TABLE "SELFSERVICE"."SWP_CONFIG_WEEKS" DROP ("PLANNING_OPEN");

