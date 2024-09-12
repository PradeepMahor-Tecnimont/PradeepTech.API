--------------------------------------------------------
--  DDL for Function DM_IS_DESK_OCCUPIED
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."DM_IS_DESK_OCCUPIED" 
(
  param_desk_id in varchar2 
) return number as 
    v_count number;
begin
  Select count(deskid) into v_count from dm_usermaster where trim(deskid)= trim(upper(param_desk_id));
  If v_count = 0 Then
    select count(targetdesk)  into v_count from dm_assetmove_tran 
      where nvl(it_cord_apprl,0) = 0 and trim(targetdesk) = trim(upper(param_desk_id)) ;
  End If;
  If v_count = 0 Then
    Select Count(deskid) into v_count from dm_desklock where trim(deskid) = trim(upper(param_desk_id))
      and blockreason = 1;
  End If;
  if v_count > 0 Then
    return 1; -- occupied
  else
    return 0; -- empty
  end if;
end dm_is_desk_occupied;


/
