--------------------------------------------------------
--  Ref Constraints for Table SS_OTDETAIL
--------------------------------------------------------

  ALTER TABLE "SS_OTDETAIL" ADD CONSTRAINT "SS_OTDETAIL_FK21028195019711" FOREIGN KEY ("EMPNO", "MON", "YYYY")
	  REFERENCES "SS_OTMASTER" ("EMPNO", "MON", "YYYY") ENABLE NOVALIDATE;
