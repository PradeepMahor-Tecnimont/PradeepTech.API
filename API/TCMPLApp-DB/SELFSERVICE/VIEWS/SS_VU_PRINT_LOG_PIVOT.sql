--------------------------------------------------------
--  DDL for View SS_VU_PRINT_LOG_PIVOT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_PRINT_LOG_PIVOT" ("USER_NAME", "COLOR", "PRINT_DATE", "PERIOD", "PAGECOUNT", "EMPNO", "EMP_NAME", "PARENT", "PAGE_SIZE", "FILE_NAME", "QUE_NAME", "TIME") AS 
  (
SELECT upper(a.USERID) USER_NAME,
  a.COLOR,
  a.PRINT_DATE,
  CASE a.COLOR
    WHEN 'GRAYSCALE'
    THEN TO_CHAR(a.PRINT_DATE, 'yyyymm')
      || '_B_W'
    WHEN 'NOT GRAYSCALE'
    THEN TO_CHAR(a.PRINT_DATE, 'yyyymm')
      || '_COLOR'
    ELSE TO_CHAR(a.PRINT_DATE, 'yyyymm')
      || '_OTHER'
  END                                AS Period,
  NVL(a.PAGES, 0)  AS PageCount,
  b.EMPNO,
  c.name emp_name,
  c.PARENT, a.page_size, a.file_name,a.que_name,a.time
FROM ss_print_log a,
  userids b,
  ss_emplmast c
WHERE trim(upper(a.USERID)) = trim(b.USERID)
AND b.EMPNO                 = c.EMPNO
AND b.DOMAIN                = 'TICB')
;
