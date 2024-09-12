--------------------------------------------------------
--  Constraints for Table EMP_GTLI
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_GTLI" ADD CONSTRAINT "EMP_GTLI_PK" PRIMARY KEY ("EMPNO", "NOM_NAME")
  USING INDEX  ENABLE;
  ALTER TABLE "COMMONMASTERS"."EMP_GTLI" MODIFY ("NOM_NAME" NOT NULL ENABLE);
  ALTER TABLE "COMMONMASTERS"."EMP_GTLI" MODIFY ("EMPNO" NOT NULL ENABLE);
