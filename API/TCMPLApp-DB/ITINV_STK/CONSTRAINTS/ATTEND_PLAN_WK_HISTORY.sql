--------------------------------------------------------
--  Constraints for Table ATTEND_PLAN_WK_HISTORY
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_WK_HISTORY" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_WK_HISTORY" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_WK_HISTORY" MODIFY ("PLANNED" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_WK_HISTORY" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_WK_HISTORY" MODIFY ("PLANNED_DATE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_WK_HISTORY" ADD CONSTRAINT "ATTEND_PLAN_WK_HISTORY_PK" PRIMARY KEY ("PLANNED_DATE", "EMPNO")
  USING INDEX  ENABLE;
