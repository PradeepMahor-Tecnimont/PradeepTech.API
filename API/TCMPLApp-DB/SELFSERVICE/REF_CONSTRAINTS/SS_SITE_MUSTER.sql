--------------------------------------------------------
--  Ref Constraints for Table SS_SITE_MUSTER
--------------------------------------------------------

  ALTER TABLE "SS_SITE_MUSTER" ADD CONSTRAINT "FK_SITEMUSTER" FOREIGN KEY ("SITECODE")
	  REFERENCES "SS_SITE_MAST" ("SITECODE") ENABLE;
