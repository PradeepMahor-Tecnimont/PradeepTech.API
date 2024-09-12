--------------------------------------------------------
--  DDL for View NGTS_VTIME_MAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."NGTS_VTIME_MAST" ("YYMM", "EMPNO", "PARENT", "ASSIGN", "LOCKED", "APPROVED", "POSTED", "APPR_ON", "GRP", "TOT_NHR", "TOT_OHR", "COMPANY", "REMARK", "EXCEED", "DESGCODE", "GRADE", "MASTKEYID") AS 
  SELECT
    "YYMM","EMPNO","PARENT","ASSIGN","LOCKED","APPROVED","POSTED","APPR_ON","GRP","TOT_NHR","TOT_OHR","COMPANY","REMARK","EXCEED","DESGCODE","GRADE","MASTKEYID"
FROM
    time_mast
WHERE
    parent = assign
    
UNION ALL

SELECT
    "YYMM","EMPNO","PARENT","ASSIGN","LOCKED","APPROVED","POSTED","APPR_ON","GRP","TOT_NHR","TOT_OHR","COMPANY","REMARK","EXCEED","DESGCODE","GRADE","MASTKEYID"
FROM
    time_mast 
WHERE
    parent != assign
    AND (parent, parent, yymm) NOT IN (
        SELECT
            parent, assign, yymm
        FROM
            time_mast 
    )
;
