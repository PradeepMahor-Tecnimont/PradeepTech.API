--------------------------------------------------------
--  Ref Constraints for Table SS_LEAVE_ADJ
--------------------------------------------------------

  ALTER TABLE "SS_LEAVE_ADJ" ADD CONSTRAINT "FK_LEAVETYPE_LEAVETYPE" FOREIGN KEY ("LEAVETYPE")
	  REFERENCES "SS_LEAVETYPE" ("LEAVETYPE") ENABLE NOVALIDATE;
