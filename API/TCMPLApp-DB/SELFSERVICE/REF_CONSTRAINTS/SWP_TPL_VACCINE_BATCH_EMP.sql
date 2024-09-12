--------------------------------------------------------
--  Ref Constraints for Table SWP_TPL_VACCINE_BATCH_EMP
--------------------------------------------------------

  ALTER TABLE "SWP_TPL_VACCINE_BATCH_EMP" ADD CONSTRAINT "SWP_TPL_VACCINE_BATCH_EMP_FK1" FOREIGN KEY ("BATCH_KEY_ID")
	  REFERENCES "SWP_TPL_VACCINE_BATCH" ("BATCH_KEY_ID") ENABLE;
