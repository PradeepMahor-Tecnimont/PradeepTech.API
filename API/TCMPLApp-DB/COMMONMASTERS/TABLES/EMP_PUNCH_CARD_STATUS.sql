--------------------------------------------------------
--  DDL for Table EMP_PUNCH_CARD_STATUS
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_PUNCH_CARD_STATUS" 
   (	"CODE" NUMBER(2,0), 
	"DESCRIPTION" VARCHAR2(60)
   ) ;

   COMMENT ON COLUMN "COMMONMASTERS"."EMP_PUNCH_CARD_STATUS"."CODE" IS 'Punch Card Status Code';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_PUNCH_CARD_STATUS"."DESCRIPTION" IS 'Punch Card Status Description';
