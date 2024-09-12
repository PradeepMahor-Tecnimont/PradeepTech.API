--------------------------------------------------------
--  File created - Thursday-April-21-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--DM_DESK_AREA_PROJ_MAP
---------------------------
  CREATE TABLE "DMS"."DM_DESK_AREA_PROJ_MAP" 
   (	"AREA_CODE" CHAR(3) NOT NULL ENABLE,
	"PROJNO" CHAR(5) NOT NULL ENABLE,
	"OFFICE" VARCHAR2(5),
	"IS_ACTIVE" NUMBER(1,0),
	CONSTRAINT "DM_DESK_AREA_PROJ_MAP_PK" PRIMARY KEY ("AREA_CODE","PROJNO") ENABLE
   );
---------------------------
--New INDEX
--DM_DESK_AREA_PROJ_MAP_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_DESK_AREA_PROJ_MAP_PK" ON "DMS"."DM_DESK_AREA_PROJ_MAP" ("AREA_CODE","PROJNO");
---------------------------
--New INDEX
--DM_DESKMASTER_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_DESKMASTER_PK" ON "DMS"."DM_DESKMASTER" ("DESKID");
---------------------------
--Changed INDEX
--DM_DESKMASTER_INDEX2
---------------------------
DROP INDEX "DMS"."DM_DESKMASTER_INDEX2";
  CREATE INDEX "DMS"."DM_DESKMASTER_INDEX2" ON "DMS"."DM_DESKMASTER_20211221" ("DESKID");
