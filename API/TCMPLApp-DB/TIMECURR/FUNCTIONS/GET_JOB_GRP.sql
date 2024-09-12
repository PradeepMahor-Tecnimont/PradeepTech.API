--------------------------------------------------------
--  DDL for Function GET_JOB_GRP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_JOB_GRP" 
  (v_jobgrp IN VARCHAR2)
  RETURN  char IS
  V_RETURN_GRP varchar2(50);

BEGIN 
--vParent := '    ';
--vAssign := '    ';

  SELECT grp_name  INTO V_RETURN_GRP   FROM job_grp WHERE trim(grp_cd) = trim(v_jobgrp);
  
 
  RETURN V_RETURN_GRP;
  
EXCEPTION
   WHEN OTHERS THEN
       RETURN 'NA';
END;

/
