--------------------------------------------------------
--  Ref Constraints for Table SS_PUNCH_AUTO
--------------------------------------------------------

  ALTER TABLE "SS_PUNCH_AUTO" ADD CONSTRAINT "SS_PUNCH_AUTO_SS_PUNCH_AU_FK1" FOREIGN KEY ("AUTO_PUNCH_TYPE")
	  REFERENCES "SS_PUNCH_AUTO_TYPE_MAST" ("AUTO_PUNCH_TYPE") ENABLE;
