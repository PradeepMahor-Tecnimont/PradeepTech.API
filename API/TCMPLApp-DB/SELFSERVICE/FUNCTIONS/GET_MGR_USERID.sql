--------------------------------------------------------
--  DDL for Function GET_MGR_USERID
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_MGR_USERID" 
(
  P_USERID_IN IN VARCHAR2  
) RETURN VARCHAR2 AS 

v_userid_in VARCHAR2(50);
v_empno VARCHAR2(5); 
v_mngr VARCHAR2(5);
v_userid VARCHAR2(50);
v_email VARCHAR2(45);
BEGIN
    v_userid_in := UPPER(LTRIM(RTRIM(p_userid_in)));

    SELECT empno INTO v_empno from USERIDS
    WhERE 'TICB\'|| upper(ltrim(rtrim(userid))) = v_userid_in;

    SELECT MNGR INTO v_mngr FROM SS_EMPLMAST
    WHERE empno = v_empno;

    SELECT ltrim(rtrim(USERID)),ltrim(rtrim(email)) INTO v_userid,v_email FROM USERIDS
    WHERE empno = v_mngr;

    v_userid := 'TICB\'|| v_userid;

    RETURN v_userid;
EXCEPTION
   WHEN OTHERS THEN
        RETURN 'TICB\Darshan';
END GET_MGR_USERID;


/
