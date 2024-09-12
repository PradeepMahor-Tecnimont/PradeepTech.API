--------------------------------------------------------
--  DDL for Function GET_JOB_DIS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_JOB_DIS" 
  (v_jobdis IN VARCHAR2)
  RETURN  char IS
  V_RETURN_DISC varchar2(50);
  --V_RETURN_CC  varchar2(4);
 -- vParent varchar2(4);
  -- vAssign varchar2(4);
BEGIN 
--vParent := '    ';
--vAssign := '    ';

  SELECT DIS_name  INTO V_RETURN_DISC   FROM job_dis WHERE trim(grp_cd)||trim(dis_cd) = trim(v_jobdis);
  
 
  RETURN V_RETURN_DISC;
  
EXCEPTION
   WHEN OTHERS THEN
       RETURN 'NA';
END;

/
