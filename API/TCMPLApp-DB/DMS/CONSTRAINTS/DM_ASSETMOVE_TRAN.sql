--------------------------------------------------------
--  Constraints for Table DM_ASSETMOVE_TRAN
--------------------------------------------------------

  ALTER TABLE "DM_ASSETMOVE_TRAN" ADD CONSTRAINT "DM_ASSETMOVE_TRAN_PK" PRIMARY KEY ("EMPNO", "CURRDESK", "TARGETDESK", "MOVEREQNUM")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_ASSETMOVE_TRAN" MODIFY ("TARGETDESK" NOT NULL ENABLE);
  ALTER TABLE "DM_ASSETMOVE_TRAN" MODIFY ("CURRDESK" NOT NULL ENABLE);
  ALTER TABLE "DM_ASSETMOVE_TRAN" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "DM_ASSETMOVE_TRAN" MODIFY ("MOVEREQDATE" NOT NULL ENABLE);
  ALTER TABLE "DM_ASSETMOVE_TRAN" MODIFY ("MOVEREQNUM" NOT NULL ENABLE);
