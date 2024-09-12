--------------------------------------------------------
--  Ref Constraints for Table SS_LEAVELEDG
--------------------------------------------------------

  ALTER TABLE "SS_LEAVELEDG" ADD CONSTRAINT "SS_TABLETAGKEY" FOREIGN KEY ("TABLETAG")
	  REFERENCES "SS_TABLETAG" ("TABLETAG") ENABLE NOVALIDATE;
