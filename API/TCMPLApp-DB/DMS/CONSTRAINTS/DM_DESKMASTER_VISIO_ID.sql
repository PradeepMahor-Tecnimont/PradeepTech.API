--------------------------------------------------------
--  Constraints for Table DM_DESKMASTER_VISIO_ID
--------------------------------------------------------

  ALTER TABLE "DM_DESKMASTER_VISIO_ID" ADD CONSTRAINT "DM_DESKMASTER_VISIO_ID_PK" PRIMARY KEY ("DESKID")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_DESKMASTER_VISIO_ID" MODIFY ("DESKID" NOT NULL ENABLE);
