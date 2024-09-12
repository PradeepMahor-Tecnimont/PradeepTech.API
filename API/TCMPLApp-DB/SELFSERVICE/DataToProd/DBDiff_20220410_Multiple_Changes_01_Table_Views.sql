--------------------------------------------------------
--  File created - Sunday-April-10-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--SWP_FLAGS
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_FLAGS" 
   (	"FLAG_ID" VARCHAR2(4) NOT NULL ENABLE,
	"FLAG_CODE" VARCHAR2(100),
	"FLAG_DESC" VARCHAR2(1000),
	"FLAG_VALUE" VARCHAR2(2),
	CONSTRAINT "SWP_FLAGS_PK" PRIMARY KEY ("FLAG_ID") ENABLE,
	CONSTRAINT "SWP_FLAGS_UK1" UNIQUE ("FLAG_CODE") ENABLE
   );
  COMMENT ON COLUMN "SELFSERVICE"."SWP_FLAGS"."FLAG_VALUE" IS 'OK/KO';
---------------------------
--Changed TABLE
--SWP_CONFIG_WEEKS
---------------------------
COMMENT ON COLUMN "SELFSERVICE"."SWP_CONFIG_WEEKS"."OWS_OPEN" IS '1 - Open / 0 - Close';
COMMENT ON COLUMN "SELFSERVICE"."SWP_CONFIG_WEEKS"."PWS_OPEN" IS '1 - Open / 0 - Close';
COMMENT ON COLUMN "SELFSERVICE"."SWP_CONFIG_WEEKS"."SWS_OPEN" IS '1 - Open / 0 - Close';
COMMENT ON COLUMN "SELFSERVICE"."SWP_CONFIG_WEEKS"."TO_DEL_PLANNING_OPEN" IS '1 - Open / 0 - Close';

---------------------------
--Changed VIEW
--DM_VU_DESKS
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_DESKS" 
 ( "DESKID", "OFFICE", "FLOOR", "SEATNO", "WING", "ASSETCODE", "NOEXIST", "CABIN", "REMARKS", "DESKID_OLD", "WORK_AREA", "BAY", "AREA_DESC", "AREA_CATG_CODE", "CATG_DESC"
  )  AS 
  Select
    dl."DESKID",dl."OFFICE",dl."FLOOR",dl."SEATNO",dl."WING",dl."ASSETCODE",dl."NOEXIST",dl."CABIN",dl."REMARKS",dl."DESKID_OLD",dl."WORK_AREA",dl."BAY", da.area_desc, da.area_catg_code, dac.description As catg_desc
From
    dm_vu_desk_list                                   dl
    Inner Join selfservice.dm_vu_desk_areas           da
    On dl.work_area = da.area_key_id
    Inner Join selfservice.dm_vu_desk_area_categories dac
    On da.area_catg_code = dac.area_catg_code;
---------------------------
--New INDEX
--SWP_FLAGS_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_FLAGS_PK" ON "SELFSERVICE"."SWP_FLAGS" ("FLAG_ID");
---------------------------
--New INDEX
--SS_ABSENT_MASTER_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_MASTER_PK" ON "SELFSERVICE"."SS_ABSENT_MASTER" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM");
---------------------------
--New INDEX
--SS_DELEGATE_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_DELEGATE_PK" ON "SELFSERVICE"."SS_DELEGATE" ("EMPNO","MNGR");
---------------------------
--New INDEX
--SS_ABSENT_TS_LEAVE_PK1
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_TS_LEAVE_PK1" ON "SELFSERVICE"."SS_ABSENT_TS_LEAVE" ("EMPNO","TDATE","PROJNO","ACTIVITY");
---------------------------
--New INDEX
--SS_HSESUGG_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_HSESUGG_PK" ON "SELFSERVICE"."SS_HSESUGG" ("SUGGNO");
---------------------------
--New INDEX
--SWP_FLAGS_UK1
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_FLAGS_UK1" ON "SELFSERVICE"."SWP_FLAGS" ("FLAG_CODE");
