--------------------------------------------------------
--  Ref Constraints for Table SS_SITE_MAST
--------------------------------------------------------

  ALTER TABLE "SS_SITE_MAST" ADD CONSTRAINT "FK_LOCCODE" FOREIGN KEY ("LOC_CODE")
	  REFERENCES "SS_SITE_LOC_MAST" ("LOC_CODE") ENABLE;
