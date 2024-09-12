--------------------------------------------------------
--  Ref Constraints for Table SWP_VACCINE_DATES
--------------------------------------------------------

  ALTER TABLE "SWP_VACCINE_DATES" ADD CONSTRAINT "SWP_VACCINE_DATES_FK1" FOREIGN KEY ("VACCINE_TYPE")
	  REFERENCES "SWP_VACCINE_MASTER" ("VACCINE_TYPE") ENABLE;
