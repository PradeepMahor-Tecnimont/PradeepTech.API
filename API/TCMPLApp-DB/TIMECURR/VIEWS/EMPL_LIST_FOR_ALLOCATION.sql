--------------------------------------------------------
--  DDL for View EMPL_LIST_FOR_ALLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."EMPL_LIST_FOR_ALLOCATION" ("PARENT", "ASSIGN", "EMPNO", "NAME", "EMPTYPE", "WORK_POSITION") AS 
  SELECT "PARENT","ASSIGN","EMPNO","NAME","EMPTYPE","WORK_POSITION" FROM
((SELECT PARENT,ASSIGN,EMPNO,NAME,EMPTYPE,'R_INOFFICE' AS WORK_POSITION FROM EMPLMAST WHERE STATUS = 1 AND EMPTYPE = 'R' AND ASSIGN NOT IN ('0236','0237','0232','0296','0297')) UNION
(SELECT PARENT,ASSIGN,EMPNO,NAME,EMPTYPE,'R_SITE/DEP' FROM EMPLMAST WHERE STATUS = 1 AND EMPTYPE = 'R' AND ASSIGN IN ('0236','0237','0232','0296','0297') ) UNION
(SELECT A.PARENT,A.ASSIGN,A.EMPNO,A.NAME,A.EMPTYPE,'C_FillTime' FROM EMPLMAST A  WHERE   A.EMPNO IN (SELECT DISTINCT EMPNO FROM TIMETRAN WHERE YYMM IN ('200701','200612','200611') )AND A.STATUS = 1 AND A.EMPTYPE <> 'R' ) )
 ORDER BY PARENT,WORK_POSITION,EMPNO

;
