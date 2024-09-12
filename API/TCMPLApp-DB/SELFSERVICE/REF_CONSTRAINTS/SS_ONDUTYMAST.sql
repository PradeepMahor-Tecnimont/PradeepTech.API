--------------------------------------------------------
--  Ref Constraints for Table SS_ONDUTYMAST
--------------------------------------------------------

  ALTER TABLE "SS_ONDUTYMAST" ADD CONSTRAINT "FK_TABLETAG_TABLETAG" FOREIGN KEY ("TABLETAG")
	  REFERENCES "SS_TABLETAG" ("TABLETAG") ENABLE NOVALIDATE;
