--------------------------------------------------------
--  DDL for Table DB_DESK_BOOKINGS_LOG
--------------------------------------------------------

  CREATE TABLE "DESK_BOOK"."DB_DESK_BOOKINGS_LOG" 
   (	"KEY_ID" CHAR(8), 
	"EMPNO" CHAR(5), 
	"DESKID" VARCHAR2(7), 
	"ATTENDANCE_DATE" DATE, 
	"START_TIME" NUMBER(4,0), 
	"END_TIME" NUMBER(4,0), 
	"MODIFIED_ON" DATE, 
	"MODIFIED_BY" VARCHAR2(5), 
	"ACTION_TYPE" VARCHAR2(20), 
	"OFFICE" VARCHAR2(20), 
	"SHIFTCODE" VARCHAR2(2)
   ) ;
