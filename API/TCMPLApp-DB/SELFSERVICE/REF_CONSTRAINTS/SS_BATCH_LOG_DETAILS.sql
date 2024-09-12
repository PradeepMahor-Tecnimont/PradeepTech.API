--------------------------------------------------------
--  Ref Constraints for Table SS_BATCH_LOG_DETAILS
--------------------------------------------------------

  ALTER TABLE "SS_BATCH_LOG_DETAILS" ADD CONSTRAINT "SS_BATCH_LOG_DETAILS_FK1" FOREIGN KEY ("BATCH_KEY_ID")
	  REFERENCES "SS_BATCH_LOG_MAST" ("BATCH_KEY_ID") ENABLE;
