--------------------------------------------------------
--  Ref Constraints for Table SS_LEAVEAPP
--------------------------------------------------------

  ALTER TABLE "SS_LEAVEAPP" ADD CONSTRAINT "FK_LEAVEAPP_LEAVETYPE" FOREIGN KEY ("LEAVETYPE")
	  REFERENCES "SS_LEAVETYPE" ("LEAVETYPE") ENABLE NOVALIDATE;
