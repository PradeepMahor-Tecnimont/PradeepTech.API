--------------------------------------------------------
--  Constraints for Table DB_AUTOBOOK_EXCLUDE_DATE
--------------------------------------------------------

  ALTER TABLE "DESK_BOOK"."DB_AUTOBOOK_EXCLUDE_DATE" MODIFY ("EMPNO" NOT NULL ENABLE);
  ALTER TABLE "DESK_BOOK"."DB_AUTOBOOK_EXCLUDE_DATE" MODIFY ("ATTENDANCE_DATE" NOT NULL ENABLE);
  ALTER TABLE "DESK_BOOK"."DB_AUTOBOOK_EXCLUDE_DATE" ADD CONSTRAINT "DB_AUTOBOOK_EXCLUDE_DATE_PK" PRIMARY KEY ("EMPNO", "ATTENDANCE_DATE")
  USING INDEX "DESK_BOOK"."DB_AUTOBOOK_EXCLUDE_DATE_PK"  ENABLE;
  ALTER TABLE "DESK_BOOK"."DB_AUTOBOOK_EXCLUDE_DATE" ADD CONSTRAINT "DB_AUTOBOOK_EXCLUDE_DATE_UK1" UNIQUE ("KEY_ID")
  USING INDEX "DESK_BOOK"."DB_AUTOBOOK_EXCLUDE_DATE_UK1"  ENABLE;
