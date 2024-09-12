--------------------------------------------------------
--  DDL for Table DM_ASSETMOVE_TRAN_HISTORY
--------------------------------------------------------

  CREATE TABLE "DM_ASSETMOVE_TRAN_HISTORY" 
   (	"MOVEREQNUM" VARCHAR2(18), 
	"EMPNO" CHAR(5), 
	"DESKID" VARCHAR2(7), 
	"DESK_FLAG" CHAR(1), 
	"ASSETID" VARCHAR2(20), 
	"HISTORYDATE" DATE, 
	"BARCODE_OLD" VARCHAR2(13)
   ) ;
