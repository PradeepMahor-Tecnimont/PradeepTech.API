--------------------------------------------------------
--  DDL for Table SS_LEAVEAPP
--------------------------------------------------------

  CREATE TABLE "SELFSERVICE"."SS_LEAVEAPP" 
   (	"APP_NO" VARCHAR2(60 BYTE), 
	"EMPNO" CHAR(5 BYTE), 
	"APP_DATE" DATE, 
	"REP_TO" VARCHAR2(60 BYTE), 
	"PROJNO" VARCHAR2(60 BYTE), 
	"CARETAKER" VARCHAR2(60 BYTE), 
	"LEAVEPERIOD" NUMBER(8,1), 
	"LEAVETYPE" CHAR(2 BYTE), 
	"BDATE" DATE, 
	"EDATE" DATE, 
	"REASON" VARCHAR2(60 BYTE), 
	"MCERT" NUMBER(1,0), 
	"WORK_LDATE" DATE, 
	"RESM_DATE" DATE, 
	"CONTACT_ADD" VARCHAR2(60 BYTE), 
	"CONTACT_PHN" VARCHAR2(30 BYTE), 
	"CONTACT_STD" VARCHAR2(30 BYTE), 
	"LAST_HRS" NUMBER(2,0), 
	"LAST_MN" NUMBER(2,0), 
	"RESM_HRS" NUMBER(2,0), 
	"RESM_MN" NUMBER(2,0), 
	"DATAENTRYBY" CHAR(5 BYTE), 
	"OFFICE" VARCHAR2(30 BYTE), 
	"HOD_APPRL" NUMBER(1,0) DEFAULT 0, 
	"HOD_APPRL_DT" DATE, 
	"HOD_CODE" CHAR(5 BYTE), 
	"HRD_APPRL" NUMBER(1,0) DEFAULT 0, 
	"HRD_APPRL_DT" DATE, 
	"HRD_CODE" CHAR(5 BYTE), 
	"DISCREPANCY" VARCHAR2(1000 BYTE), 
	"USER_TCP_IP" VARCHAR2(30 BYTE), 
	"HOD_TCP_IP" VARCHAR2(30 BYTE), 
	"HRD_TCP_IP" VARCHAR2(30 BYTE), 
	"HODREASON" VARCHAR2(60 BYTE), 
	"HRDREASON" VARCHAR2(60 BYTE), 
	"HD_DATE" DATE, 
	"HD_PART" NUMBER(1,0), 
	"LEAD_APPRL" NUMBER(1,0), 
	"LEAD_APPRL_DT" DATE, 
	"LEAD_CODE" VARCHAR2(5 BYTE), 
	"LEAD_TCP_IP" VARCHAR2(30 BYTE), 
	"LEAD_APPRL_EMPNO" VARCHAR2(5 BYTE), 
	"LEAD_REASON" VARCHAR2(60 BYTE), 
	"MED_CERT_FILE_NAME" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;
