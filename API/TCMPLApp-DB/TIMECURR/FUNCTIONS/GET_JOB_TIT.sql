--------------------------------------------------------
--  DDL for Function GET_JOB_TIT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_JOB_TIT" 
  (v_jobtit IN VARCHAR2)
  RETURN  char IS
  V_RETURN_TIT varchar2(50);
  --V_RETURN_CC  varchar2(4);
 -- vParent varchar2(4);
  -- vAssign varchar2(4);
BEGIN 
--vParent := '    ';
--vAssign := '    ';

  SELECT TITLE  INTO V_RETURN_TIT   FROM job_TIT WHERE trim(TIT_CD) = trim(v_jobtit);
  
 
  RETURN V_RETURN_TIT;
  
EXCEPTION
   WHEN OTHERS THEN
       RETURN 'NA';
END;

/
