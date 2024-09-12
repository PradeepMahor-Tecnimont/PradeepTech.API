--------------------------------------------------------
--  Ref Constraints for Table EMP_FAMILY
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_FAMILY" ADD CONSTRAINT "FK_OCCUPATION" FOREIGN KEY ("OCCUPATION")
	  REFERENCES "COMMONMASTERS"."EMP_OCCUPATION" ("CODE") ENABLE NOVALIDATE;
  ALTER TABLE "COMMONMASTERS"."EMP_FAMILY" ADD CONSTRAINT "FK_RELATION" FOREIGN KEY ("RELATION")
	  REFERENCES "COMMONMASTERS"."EMP_RELATION_MAST" ("CODE") ENABLE NOVALIDATE;
