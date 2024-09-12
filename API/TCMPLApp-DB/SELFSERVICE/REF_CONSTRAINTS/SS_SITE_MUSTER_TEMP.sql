--------------------------------------------------------
--  Ref Constraints for Table SS_SITE_MUSTER_TEMP
--------------------------------------------------------

  ALTER TABLE "SS_SITE_MUSTER_TEMP" ADD CONSTRAINT "FK_SYS0804041113" FOREIGN KEY ("SITECODE")
	  REFERENCES "SS_SITE_MAST" ("SITECODE") ENABLE;
