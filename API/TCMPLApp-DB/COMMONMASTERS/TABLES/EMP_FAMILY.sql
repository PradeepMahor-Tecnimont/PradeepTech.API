--------------------------------------------------------
--  DDL for Table EMP_FAMILY
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."EMP_FAMILY" 
   (	"EMPNO" CHAR(5), 
	"MEMBER" VARCHAR2(60), 
	"DOB" DATE, 
	"RELATION" NUMBER(2,0), 
	"OCCUPATION" NUMBER(2,0), 
	"REMARKS" VARCHAR2(200), 
	"MODIFIED_ON" DATE, 
	"KEY_ID" VARCHAR2(8)
   ) ;

   COMMENT ON COLUMN "COMMONMASTERS"."EMP_FAMILY"."EMPNO" IS 'Employee Number';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_FAMILY"."MEMBER" IS 'Name of the Member of the Family';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_FAMILY"."DOB" IS 'Date of Birth of the Member of the family';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_FAMILY"."RELATION" IS 'Relation of the Member with Employee';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_FAMILY"."OCCUPATION" IS 'Occupation of the Member of the Family';
   COMMENT ON COLUMN "COMMONMASTERS"."EMP_FAMILY"."REMARKS" IS 'Description of Pre-existing Diseases of the Member';
