--------------------------------------------------------
--  Constraints for Table ATTEND_PLAN_CALENDAR
--------------------------------------------------------

  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_CALENDAR" MODIFY ("PUNCH_DATE" NOT NULL ENABLE);
  ALTER TABLE "ITINV_STK"."ATTEND_PLAN_CALENDAR" ADD CONSTRAINT "ATTEND_PLAN_CALENDAR_PK" PRIMARY KEY ("PUNCH_DATE")
  USING INDEX  ENABLE;
