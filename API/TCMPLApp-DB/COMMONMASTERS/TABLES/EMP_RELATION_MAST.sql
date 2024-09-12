--------------------------------------------------------
--  DDL for Table EMP_RELATION_MAST
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_RELATION_MAST" 
   (	"CODE" NUMBER(2,0), 
	"DESCRIPTION" VARCHAR2(60), 
	"GENDER" VARCHAR2(1)
   ) ;

   COMMENT ON COLUMN "COMMONMASTERS"."EMP_RELATION_MAST"."CODE" IS 'Code of Relation';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_RELATION_MAST"."DESCRIPTION" IS 'Description of the Relation';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_RELATION_MAST"."GENDER" IS 'M - F';
