--------------------------------------------------------
--  DDL for Package Body PKG_SYSTEMGRANTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_SYSTEMGRANTS" as

  procedure sp_deskmanagement_systemgrants (
        param_msg_type out varchar2,
        param_msgtext  out varchar2
    ) as
    vExits Number;
    vApplsystem varchar2(3) := '008';
  begin
    -- Remove employees from table who left company
    delete from dm_secretary 
      where empno in (select distinct empno from vu_system_grants where status = 0);
    delete from dm_ituser 
      where empno in (select distinct empno from vu_system_grants where status = 0);
    delete from dm_emailid 
      where empno in (select distinct empno from vu_system_grants where status = 0);
    commit;
    
    -- Check records exists in COMMONMASTERS
    select count(*) into vExits from commonmasters.system_grants
      Where applsystem = vApplsystem;
        
    -- Remove records in COMMONMASTERS if exits
    if (vExits > 0) then
      delete from commonmasters.system_grants
        where applsystem = vApplsystem;
      commit;
    end if;
    
    -- Insert records available in VU_SYSTEM_GRANTS
    insert into commonmasters.system_grants (
      empno,
      applsystem,
      rolename,
      roledesc,
      module,
      role_on_costcode
    )
    select
      vu_sys.empno,
      vu_sys.applsystem,
      vu_sys.rolename,
      vu_sys.roledesc,
      vu_sys.module,
      vu_sys.role_on_costcode
    from
      vu_system_grants vu_sys 
    where 
      applsystem = vApplsystem;

    if ( Sql%rowcount > 0 ) then
      param_msg_type := 'SUCCESS';
    else
      param_msg_type := 'FAILURE';
    end if;
  end sp_deskmanagement_systemgrants;

end pkg_systemgrants;

/
