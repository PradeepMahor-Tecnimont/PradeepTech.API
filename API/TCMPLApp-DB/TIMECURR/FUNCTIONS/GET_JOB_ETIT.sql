--------------------------------------------------------
--  DDL for Function GET_JOB_ETIT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_JOB_ETIT" 
  (v_EMPNO IN VARCHAR2)
  RETURN  char IS
  V_RETURN_ETIT varchar2(50);
BEGIN 


  --select * from (SELECT GET_JOB_TIT(TIt_cd)  INTO V_RETURN_eTIT   FROM job_eTIT WHERE EMPNO = v_EMPNO ORDER BY EFFDATE DESC) WHERE ROWNUM = 1;
  
  select GET_JOB_TIT(tit_cd) into  V_RETURN_eTIT from (SELECT TIt_cd    FROM job_eTIT WHERE EMPNO = v_EMPNO ORDER BY EFFDATE DESC) WHERE ROWNUM = 1;
  
 
 
  --SELECT * FROM (SELECT * FROM … ORDER BY …) WHERE ROWNUM <= N;
  
  --SELECT TIt_cd  INTO V_RETURN_eTIT   FROM job_eTIT WHERE EMPNO = v_EMPNO ORDER BY EFFDATE DESC
 
  RETURN V_RETURN_eTIT;
  
EXCEPTION
   WHEN OTHERS THEN
       RETURN 'NA';
END;

/
