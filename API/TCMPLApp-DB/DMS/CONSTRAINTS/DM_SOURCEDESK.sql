--------------------------------------------------------
--  Constraints for Table DM_SOURCEDESK
--------------------------------------------------------

  ALTER TABLE "DM_SOURCEDESK" ADD CONSTRAINT "DM_SOURCEDESK_PK" PRIMARY KEY ("SID", "DESKID")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_SOURCEDESK" MODIFY ("DESKID" NOT NULL ENABLE);
  ALTER TABLE "DM_SOURCEDESK" MODIFY ("SID" NOT NULL ENABLE);
