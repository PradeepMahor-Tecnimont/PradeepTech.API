--------------------------------------------------------
--  Constraints for Table DM_EMP_DM_TYPE_MAP
--------------------------------------------------------

  ALTER TABLE "DM_EMP_DM_TYPE_MAP" ADD CONSTRAINT "DM_EMP_DM_TYPE_MAP_PK" PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_EMP_DM_TYPE_MAP" MODIFY ("EMPNO" NOT NULL ENABLE);
