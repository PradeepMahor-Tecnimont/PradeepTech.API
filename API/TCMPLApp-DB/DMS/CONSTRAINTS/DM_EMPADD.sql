--------------------------------------------------------
--  Constraints for Table DM_EMPADD
--------------------------------------------------------

  ALTER TABLE "DM_EMPADD" ADD CONSTRAINT "DM_EMPADD_PK" PRIMARY KEY ("UNQID", "EMPNO")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_EMPADD" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "DM_EMPADD" MODIFY ("UNQID" NOT NULL ENABLE);
