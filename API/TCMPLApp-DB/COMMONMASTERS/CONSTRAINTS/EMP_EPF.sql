--------------------------------------------------------
--  Constraints for Table EMP_EPF
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_EPF" ADD CONSTRAINT "EMP_EPF_PK" PRIMARY KEY ("EMPNO", "NOM_NAME")
  USING INDEX  ENABLE;
  ALTER TABLE "COMMONMASTERS"."EMP_EPF" MODIFY ("NOM_NAME" NOT NULL ENABLE);
  ALTER TABLE "COMMONMASTERS"."EMP_EPF" MODIFY ("EMPNO" NOT NULL ENABLE);
