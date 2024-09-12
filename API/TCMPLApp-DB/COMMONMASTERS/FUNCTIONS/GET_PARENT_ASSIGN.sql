--------------------------------------------------------
--  DDL for Function GET_PARENT_ASSIGN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "COMMONMASTERS"."GET_PARENT_ASSIGN" 
  (v_empno IN VARCHAR2)
  RETURN  char IS
  v_Ret_Sap_CC varchar2(6);
  V_RETURN_CC varchar2(4);
  vParent varchar2(4);
   vAssign varchar2(4);
BEGIN 
vParent := '    ';
vAssign := '    ';

  SELECT parent,assign INTO vParent ,vAssign   FROM emplmast WHERE trim(empno) = trim(V_empno);
  if vParent = vAssign then
     V_RETURN_CC := vParent;
  else
     if vAssign = '0198' then
        V_RETURN_CC := vAssign;
     else
        V_RETURN_CC := vParent;
     end if   ;
  end if;
  select sapcc into v_Ret_Sap_CC from  costmast where costcode = v_Return_cc;
  RETURN v_Ret_Sap_CC;

EXCEPTION
   WHEN OTHERS THEN
       RETURN -1;
END;

/
