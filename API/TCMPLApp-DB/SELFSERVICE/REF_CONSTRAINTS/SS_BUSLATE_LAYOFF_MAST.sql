--------------------------------------------------------
--  Ref Constraints for Table SS_BUSLATE_LAYOFF_MAST
--------------------------------------------------------

  ALTER TABLE "SS_BUSLATE_LAYOFF_MAST" ADD CONSTRAINT "FK_CODE_BLLO" FOREIGN KEY ("CODE")
	  REFERENCES "SS_BL_LO_MAST" ("CODE") ENABLE NOVALIDATE;
