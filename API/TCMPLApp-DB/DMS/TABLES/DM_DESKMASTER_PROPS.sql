
  CREATE TABLE "DMS"."DM_DESKMASTER_PROPS" 
   (	"ID" CHAR(4 BYTE) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(20 BYTE) NOT NULL ENABLE, 
	"TYPE" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"ISACTIVE" NUMBER DEFAULT 1 NOT NULL ENABLE, 
	 CONSTRAINT "DM_DESKMASTER_PROPS_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "APPL_DATA" ;


INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('O001', 'MOC1', 'Office', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('O002', 'MOC2', 'Office', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('O003', 'MOC3', 'Office', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('O004', 'MOC4', 'Office', '0');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('F001', 'First', 'Floor', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('F002', 'Second', 'Floor', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('F003', 'Third', 'Floor', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('F004', 'Forth', 'Floor', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('F007', 'Seventh', 'Floor', '0');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('W001', 'Ease', 'Wing', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('W002', 'West', 'Wing', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('W003', 'North', 'Wing', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('W004', 'South', 'Wing', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B001', 'Bay - 001', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B002', 'Bay - 002', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B003', 'Bay - 003', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B004', 'Bay - 004', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B005', 'Bay - 005', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B006', 'Bay - 006', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B007', 'Bay - 007', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B008', 'Bay - 008', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B009', 'Bay - 009', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B010', 'Bay - 010', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B011', 'Bay - 011', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B012', 'Bay - 012', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B013', 'Bay - 013', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B014', 'Bay - 014', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B015', 'Bay - 015', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B016', 'Bay - 016', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B017', 'Bay - 017', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B018', 'Bay - 018', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B019', 'Bay - 019', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B020', 'Bay - 020', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B021', 'Bay - 021', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B022', 'Bay - 022', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B023', 'Bay - 023', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B024', 'Bay - 024', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B025', 'Bay - 025', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B026', 'Bay - 026', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B027', 'Bay - 027', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B028', 'Bay - 028', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B029', 'Bay - 029', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B030', 'Bay - 030', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B031', 'Bay - 031', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B032', 'Bay - 032', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B033', 'Bay - 033', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B034', 'Bay - 034', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B035', 'Bay - 035', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B036', 'Bay - 036', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B037', 'Bay - 037', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B038', 'Bay - 038', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B039', 'Bay - 039', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B040', 'Bay - 040', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B041', 'Bay - 041', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B042', 'Bay - 042', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B043', 'Bay - 043', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B044', 'Bay - 044', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B045', 'Bay - 045', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B046', 'Bay - 046', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B047', 'Bay - 047', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B048', 'Bay - 048', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B049', 'Bay - 049', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B050', 'Bay - 050', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B051', 'Bay - 051', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B052', 'Bay - 052', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B053', 'Bay - 053', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B054', 'Bay - 054', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B055', 'Bay - 055', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B056', 'Bay - 056', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B057', 'Bay - 057', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B058', 'Bay - 058', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B059', 'Bay - 059', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B060', 'Bay - 060', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B061', 'Bay - 061', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B062', 'Bay - 062', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B063', 'Bay - 063', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B064', 'Bay - 064', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B065', 'Bay - 065', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B066', 'Bay - 066', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B067', 'Bay - 067', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B068', 'Bay - 068', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B069', 'Bay - 069', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B070', 'Bay - 070', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B071', 'Bay - 071', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B072', 'Bay - 072', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B073', 'Bay - 073', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B074', 'Bay - 074', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B075', 'Bay - 075', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B076', 'Bay - 076', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B077', 'Bay - 077', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B078', 'Bay - 078', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B079', 'Bay - 079', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B080', 'Bay - 080', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B081', 'Bay - 081', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B082', 'Bay - 082', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B083', 'Bay - 083', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B084', 'Bay - 084', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B085', 'Bay - 085', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B086', 'Bay - 086', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B087', 'Bay - 087', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B088', 'Bay - 088', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B089', 'Bay - 089', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B090', 'Bay - 090', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B091', 'Bay - 091', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B092', 'Bay - 092', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B093', 'Bay - 093', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B094', 'Bay - 094', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B095', 'Bay - 095', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B096', 'Bay - 096', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B097', 'Bay - 097', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B098', 'Bay - 098', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B099', 'Bay - 099', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B100', 'Bay - 100', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B101', 'Bay - 101', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B102', 'Bay - 102', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B103', 'Bay - 103', 'BAY', '1');
INSERT INTO "DMS"."DM_DESKMASTER_PROPS" (ID, DESCRIPTION, TYPE, ISACTIVE) VALUES ('B104', 'Bay - 104', 'BAY', '1');
