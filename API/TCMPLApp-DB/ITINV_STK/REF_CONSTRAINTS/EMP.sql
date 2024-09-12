--------------------------------------------------------
--  Ref Constraints for Table EMP
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."EMP" ADD FOREIGN KEY ("MGR")
	  REFERENCES "ITINV_STK"."EMP" ("EMPNO") ENABLE;
  ALTER TABLE "ITINV_STK"."EMP" ADD FOREIGN KEY ("DEPTNO")
	  REFERENCES "ITINV_STK"."DEPT" ("DEPTNO") ENABLE;
