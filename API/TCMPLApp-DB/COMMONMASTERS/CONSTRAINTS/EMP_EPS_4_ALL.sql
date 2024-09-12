--------------------------------------------------------
--  Constraints for Table EMP_EPS_4_ALL
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_EPS_4_ALL" ADD CONSTRAINT "EMP_EPS_4_ALL_PK" PRIMARY KEY ("EMPNO", "NOM_NAME")
  USING INDEX  ENABLE;
  ALTER TABLE "COMMONMASTERS"."EMP_EPS_4_ALL" MODIFY ("NOM_NAME" NOT NULL ENABLE);
  ALTER TABLE "COMMONMASTERS"."EMP_EPS_4_ALL" MODIFY ("EMPNO" NOT NULL ENABLE);
