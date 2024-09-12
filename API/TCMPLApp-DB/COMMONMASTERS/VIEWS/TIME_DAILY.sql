--------------------------------------------------------
--  DDL for View TIME_DAILY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."TIME_DAILY" ("YYMM", "EMPNO", "PARENT", "ASSIGN", "PROJNO", "WPCODE", "ACTIVITY", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "D21", "D22", "D23", "D24", "D25", "D26", "D27", "D28", "D29", "D30", "D31", "TOTAL", "GRP", "COMPANY") AS 
  (
  SELECT "YYMM",
    "EMPNO",
    "PARENT",
    "ASSIGN",
    "PROJNO",
    "WPCODE",
    "ACTIVITY",
    "D1",
    "D2",
    "D3",
    "D4",
    "D5",
    "D6",
    "D7",
    "D8",
    "D9",
    "D10",
    "D11",
    "D12",
    "D13",
    "D14",
    "D15",
    "D16",
    "D17",
    "D18",
    "D19",
    "D20",
    "D21",
    "D22",
    "D23",
    "D24",
    "D25",
    "D26",
    "D27",
    "D28",
    "D29",
    "D30",
    "D31",
    "TOTAL",
    "GRP",
    "COMPANY"
  FROM timeCURR.time_daily
  )
;
  GRANT SELECT ON "COMMONMASTERS"."TIME_DAILY" TO "SELFSERVICE";
