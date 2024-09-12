--------------------------------------------------------
--  Ref Constraints for Table SS_USERMAST
--------------------------------------------------------

  ALTER TABLE "SS_USERMAST" ADD CONSTRAINT "SS_USERMAST_FK1" FOREIGN KEY ("TYPE")
	  REFERENCES "SS_USER_TYPE_MAST" ("USER_TYPE") ENABLE;
