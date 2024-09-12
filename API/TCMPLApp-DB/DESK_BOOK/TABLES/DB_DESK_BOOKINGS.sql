--------------------------------------------------------
--  DDL for Table DB_DESK_BOOKINGS
--------------------------------------------------------

  CREATE TABLE "DESK_BOOK"."DB_DESK_BOOKINGS" 
   (	"KEY_ID" CHAR(8), 
	"EMPNO" CHAR(5), 
	"DESKID" VARCHAR2(7), 
	"ATTENDANCE_DATE" DATE, 
	"START_TIME" NUMBER(4,0), 
	"END_TIME" NUMBER(4,0), 
	"MODIFIED_ON" DATE, 
	"MODIFIED_BY" VARCHAR2(5), 
	"SHIFTCODE" VARCHAR2(2), 
	"OFFICE" VARCHAR2(4)
   ) ;
