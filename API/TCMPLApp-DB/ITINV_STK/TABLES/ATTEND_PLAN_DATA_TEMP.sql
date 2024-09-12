--------------------------------------------------------
--  DDL for Table ATTEND_PLAN_DATA_TEMP
--------------------------------------------------------

  CREATE TABLE "ITINV_STK"."ATTEND_PLAN_DATA_TEMP" 
   (	"EMPNO" CHAR(5), 
	"ASSIGN" CHAR(4), 
	"ATTENDING_OFFICE" NUMBER(1,0) DEFAULT 0, 
	"MODELER" NUMBER(1,0), 
	"SHIFT" CHAR(2), 
	"BUS" NUMBER(1,0) DEFAULT 0, 
	"STATION" VARCHAR2(30), 
	"SIDE" CHAR(4), 
	"CITY_LANDMARK" VARCHAR2(100), 
	"TASKFORCE" VARCHAR2(20), 
	"CREATED_BY" CHAR(5), 
	"CREATED_ON" DATE, 
	"SPECIAL_NOTE" VARCHAR2(200)
   ) ;
