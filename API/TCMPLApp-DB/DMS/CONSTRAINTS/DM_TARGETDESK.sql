--------------------------------------------------------
--  Constraints for Table DM_TARGETDESK
--------------------------------------------------------

  ALTER TABLE "DM_TARGETDESK" ADD CONSTRAINT "DM_TARGETDESK_PK" PRIMARY KEY ("SID", "DESKID")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_TARGETDESK" MODIFY ("DESKID" NOT NULL ENABLE);
  ALTER TABLE "DM_TARGETDESK" MODIFY ("SID" NOT NULL ENABLE);
