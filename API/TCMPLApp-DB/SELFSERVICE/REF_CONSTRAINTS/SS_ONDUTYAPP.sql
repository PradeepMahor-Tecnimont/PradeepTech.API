--------------------------------------------------------
--  Ref Constraints for Table SS_ONDUTYAPP
--------------------------------------------------------

  ALTER TABLE "SS_ONDUTYAPP" ADD CONSTRAINT "FK_TYPE_ONDUTYMAST" FOREIGN KEY ("TYPE")
	  REFERENCES "SS_ONDUTYMAST" ("TYPE") ENABLE NOVALIDATE;
