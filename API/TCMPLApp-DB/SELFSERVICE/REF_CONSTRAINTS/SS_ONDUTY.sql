--------------------------------------------------------
--  Ref Constraints for Table SS_ONDUTY
--------------------------------------------------------

  ALTER TABLE "SS_ONDUTY" ADD CONSTRAINT "FK_TYPE_ONDUTY" FOREIGN KEY ("TYPE")
	  REFERENCES "SS_ONDUTYMAST" ("TYPE") ENABLE NOVALIDATE;
