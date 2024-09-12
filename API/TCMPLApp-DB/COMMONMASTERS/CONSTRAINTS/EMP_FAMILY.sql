--------------------------------------------------------
--  Constraints for Table EMP_FAMILY
--------------------------------------------------------

  ALTER TABLE "COMMONMASTERS"."EMP_FAMILY" ADD CONSTRAINT "CHK_CASE_MEMBER" CHECK (member = Upper(member)
) ENABLE NOVALIDATE;
  ALTER TABLE "COMMONMASTERS"."EMP_FAMILY" ADD CONSTRAINT "PK_FAMILY" PRIMARY KEY ("EMPNO", "MEMBER")
  USING INDEX  ENABLE;
