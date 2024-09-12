--------------------------------------------------------
--  Ref Constraints for Table SS_SITE_EMPLOYEE
--------------------------------------------------------

  ALTER TABLE "SS_SITE_EMPLOYEE" ADD CONSTRAINT "SS_SITE_MOBI_SS_SITE_MAST_FK1" FOREIGN KEY ("SITECODE")
	  REFERENCES "SS_SITE_MAST" ("SITECODE") ENABLE;
