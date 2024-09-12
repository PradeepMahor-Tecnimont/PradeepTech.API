--------------------------------------------------------
--  DDL for Table EMP_OCCUPATION
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_OCCUPATION" 
   (	"CODE" NUMBER(2,0), 
	"DESCRIPTION" VARCHAR2(60)
   ) ;

   COMMENT ON COLUMN "COMMONMASTERS"."EMP_OCCUPATION"."CODE" IS 'Code of the Family Member Occcupation';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_OCCUPATION"."DESCRIPTION" IS 'Description of Occupation';
