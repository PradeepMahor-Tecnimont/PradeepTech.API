--------------------------------------------------------
--  DDL for Function GET_DESK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_DESK" (p_empno emplmast.empno%type) return varchar2 is
   p_deskid varchar2(7);
Begin
   select max(deskid) deskid into p_deskid from selfservice.dm_usermaster where empno = p_empno;
   return p_deskid;
exception   
   when no_data_found then
        p_deskid:= '';
        Return P_Deskid;
end;

/
