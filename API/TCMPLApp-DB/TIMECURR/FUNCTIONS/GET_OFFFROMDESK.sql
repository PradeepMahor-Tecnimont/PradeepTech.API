--------------------------------------------------------
--  DDL for Function GET_OFFFROMDESK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."GET_OFFFROMDESK" (p_deskid varchar2) return varchar2 is
   p_office varchar2(7);
Begin
   select office into p_office from selfservice.dm_deskmaster where ltrim(rtrim(deskid))  = ltrim(rtrim(p_deskid));
   return p_office;
exception   
   When No_Data_Found Then
        p_office := '';
        Return p_office ;
end;

/
