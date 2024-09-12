--------------------------------------------------------
--  DDL for Table DM_ASSETTICKET
--------------------------------------------------------

  CREATE TABLE "DM_ASSETTICKET" 
   (	"TICKETNO" VARCHAR2(15), 
	"REQDATE" DATE, 
	"EMPNO" VARCHAR2(5), 
	"DESKID" VARCHAR2(7), 
	"ACTIONTYPE" VARCHAR2(1), 
	"PARTICULARS" VARCHAR2(250), 
	"CLOSEBY" VARCHAR2(5), 
	"CLOSEDATE" DATE, 
	"REMARKS" VARCHAR2(200)
   ) ;
