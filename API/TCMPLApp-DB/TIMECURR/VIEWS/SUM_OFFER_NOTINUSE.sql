--------------------------------------------------------
--  DDL for View SUM_OFFER_NOTINUSE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."SUM_OFFER_NOTINUSE" ("YYMM", "COSTCODE", "PROJ_TYPE", "TOTHOURS") AS 
  ((SELECT A.YYMM,A.COSTCODE,'TCM' AS PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0)) AS TOTHOURS FROM TIMETRAN A,PROJMAST B
WHERE A.PROJNO = B.PROJNO AND substr(A.PROJNO,6,2) <> '30'  AND A.YYMM <= '200412'
AND B.TCM_JOBS = 1 GROUP BY A.YYMM,A.COSTCODE)
UNION
(SELECT A.YYMM,B.PARENT,'DEP_TCM'as PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0))
FROM TIMETRAN A,EMPLMAST B WHERE A.EMPNO = B.EMPNO  AND A.YYMM <= '200412' AND A.PROJNO in ('0002130','0800130') GROUP BY A.YYMM,B.PARENT)
UNION
(SELECT A.YYMM,B.PARENT,'DEP_TCMSITE'as PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0))
FROM TIMETRAN A,EMPLMAST B WHERE A.EMPNO = B.EMPNO AND
A.YYMM <= '200412' AND A.PROJNO = '0002230'  GROUP BY A.YYMM,B.PARENT)
UNION
(SELECT A.YYMM,B.PARENT,'DEP_NONTCM'as PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0))
FROM TIMETRAN A,EMPLMAST B WHERE A.EMPNO = B.EMPNO
 AND A.YYMM <= '200412' AND substr(A.PROJNO,6,2) = '30'
AND A.PROJNO NOT IN('0002130','0002230','0800130') GROUP BY A.YYMM,B.PARENT)
UNION
(SELECT A.YYMM,A.COSTCODE,'NON TCM' AS PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0)) AS TOTHOURS FROM TIMETRAN A,PROJMAST B
WHERE A.PROJNO = B.PROJNO  AND A.YYMM <= '200412' AND B.COSTCODE not IN ('0402','0405')
AND A.PROJNO NOT IN('1111400','2222400','5555400','6666400')  AND substr(A.PROJNO,6,2) <> '30'
AND  B.TCM_JOBS = 0  GROUP BY A.YYMM,A.COSTCODE)
union
(SELECT A.YYMM,A.COSTCODE,'PROPOSALS'AS PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0)) AS TOTHOURS FROM TIMETRAN A,PROJMAST B
WHERE A.PROJNO = B.PROJNO AND A.YYMM <= '200412' AND B.COSTCODE IN ('0402','0405')
AND A.PROJNO NOT IN('1111400','2222400','5555400','6666400') AND substr(A.PROJNO,6,2) <> '30'
AND B.TCM_JOBS = 0 GROUP BY A.YYMM,A.COSTCODE)
union
(SELECT A.YYMM,A.COSTCODE,'TRAINING'AS PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0)) AS TOTHOURS FROM TIMETRAN A
WHERE  A.YYMM <= '200412' AND A.PROJNO = '6666400' GROUP BY A.YYMM,A.COSTCODE)
UNION
(SELECT A.YYMM,A.COSTCODE,'VACATION'AS PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0)) AS TOTHOURS FROM TIMETRAN A
WHERE A.YYMM <= '200412' AND A.PROJNO IN('1111400','2222400') GROUP BY A.YYMM,A.COSTCODE)
UNION
(SELECT A.YYMM,A.COSTCODE,'AVAILABLE'AS PROJ_TYPE,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0)) AS TOTHOURS FROM TIMETRAN A
WHERE A.YYMM <= '200412' AND A.PROJNO = '5555400' GROUP BY A.YYMM,A.COSTCODE)
) WITH READ ONLY

;
