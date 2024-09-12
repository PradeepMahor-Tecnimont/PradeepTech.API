--------------------------------------------------------
--  Constraints for Table DM_GRAPHIC_CARD
--------------------------------------------------------

  ALTER TABLE "DM_GRAPHIC_CARD" ADD CONSTRAINT "DM_GRAPHIC_CARD_PK" PRIMARY KEY ("GCARDID")
  USING INDEX  ENABLE;
  ALTER TABLE "DM_GRAPHIC_CARD" MODIFY ("GCARDID" NOT NULL ENABLE);
