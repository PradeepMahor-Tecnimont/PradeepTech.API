--------------------------------------------------------
--  Ref Constraints for Table SS_BUSLATE_LAYOFF_DETAIL
--------------------------------------------------------

  ALTER TABLE "SS_BUSLATE_LAYOFF_DETAIL" ADD CONSTRAINT "FK_PDATE_EMPNO_BLLOMAST" FOREIGN KEY ("CODE", "PDATE")
	  REFERENCES "SS_BUSLATE_LAYOFF_MAST" ("CODE", "PDATE") ENABLE NOVALIDATE;
