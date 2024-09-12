--------------------------------------------------------
--  Ref Constraints for Table SS_SWIPE_MACH_MAST
--------------------------------------------------------

  ALTER TABLE "SS_SWIPE_MACH_MAST" ADD CONSTRAINT "SS_SWIPE_MACH_SS_OFFICE_M_FK1" FOREIGN KEY ("OFFICE")
	  REFERENCES "SS_OFFICE_MAST" ("OFFICE_ID") ENABLE;
