--------------------------------------------------------
--  DDL for Package Body PKG_SYSTEMGRANTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."PKG_SYSTEMGRANTS" as 
procedure sp_jobform_systemgrants (
param_msg_type out varchar2,
param_msgtext out varchar2
) as
vExits Number;
vApplsystem varchar2(3) := '014';  --tIMESHEET
--vApplsystem varchar2(3) := '018';  --rap Reporting
--vApplsystem varchar2(3) := '014';  --Jobform

begin
-- Remove employees from table who left company
update emplmast set amfi_auth = 0 
where empno in (select  empno from VU_JOB_AFCAPPROVER where status = 0);
update emplmast set amfi_user = 0 
where empno in (select distinct empno from VU_JOB_AFCUSER where status = 0);
update emplmast set projmngr = 0 
where empno in (select distinct empno from VU_JOB_PM where status = 0);
update emplmast set job_incharge = 0 
where empno in (select distinct empno from VU_JOB_SPONSOR where status = 0);
update emplmast set dirop = 0 
where empno in (select distinct empno from VU_JOB_CMD where status = 0);
commit;
-- Check records exists in COMMONMASTERS
select count(*) into vExits from commonmasters.system_grants
Where applsystem = '014';  --jobform
-- Remove records in COMMONMASTERS if exits
if (vExits > 0) then
delete from commonmasters.system_grants
where applsystem = '014' ;--vApplsystem;
commit;
end if;
-- Insert records available in VU_SYSTEM_GRANTS
insert into commonmasters.system_grants (
empno,
applsystem,
rolename,
roledesc,
module
)
select
vu_sys.empno,
vApplsystem,
vu_sys.role,   --vu_sys.rolename,
vu_sys.role,
vu_sys.application --vu_sys.applsystem,
--vu_sys.module
from
job_roles vu_sys;
--where
--applsystem = vApplsystem;
if ( Sql%rowcount > 0 ) then
param_msg_type := 'SUCCESS';
else
param_msg_type := 'FAILURE';
end if;



end sp_jobform_systemgrants;


procedure sp_ts_systemgrants (
param_msg_type out varchar2,
param_msgtext out varchar2
) as
vExits Number;
vApplsystem varchar2(3) := '012';  --tIMESHEET
--vApplsystem varchar2(3) := '018';  --rap Reporting
--vApplsystem varchar2(3) := '014';  --Jobform

begin
-- Remove employees from table who left company
delete from time_hod where empno in (select  empno from emplmast where status = 0);
delete from time_dyhod where empno in (select  empno from emplmast where status = 0);
delete from time_secretary where empno in (select  empno from emplmast where status = 0);
commit;
-- Check records exists in COMMONMASTERS
--select count(*) into vExits from commonmasters.system_grants
--Where applsystem = '012';  --'012';  --ts
-- Remove records in COMMONMASTERS if exits
--if (vExits > 0) then
delete from commonmasters.system_grants
where applsystem = '012'  ; --'012' ;--vApplsystem;
commit;
--end if;
-- Insert records available in VU_SYSTEM_GRANTS
insert into commonmasters.system_grants (
empno,
applsystem,
rolename,
roledesc,
module
)
select
vu_sys.empno,
'012', --vApplsystem,
vu_sys.role,   --vu_sys.rolename,
vu_sys.role,
vu_sys.applsystem --vu_sys.applsystem,
--vu_sys.module
from
ts_role vu_sys;
--where
--applsystem = vApplsystem;
if ( Sql%rowcount > 0 ) then
param_msg_type := 'SUCCESS';
else
param_msg_type := 'FAILURE';
end if;



end sp_ts_systemgrants;


procedure sp_rap_systemgrants (
param_msg_type out varchar2,
param_msgtext out varchar2
) as
vExits Number;
vApplsystem varchar2(3) := '018';  --tIMESHEET
--vApplsystem varchar2(3) := '018';  --rap Reporting
--vApplsystem varchar2(3) := '014';  --Jobform

begin
-- Remove employees from table who left company
-- Remove employees from table who left company
delete from rap_hod where empno in (select  empno from emplmast where status = 0);
delete from rap_dyhod where empno in (select  empno from emplmast where status = 0);
delete from rap_secretary where empno in (select  empno from emplmast where status = 0);
commit;
/*
update emplmast set amfi_auth = 0 
where empno in (select  empno from VU_JOB_AFCAPPROVER where status = 0);
update emplmast set amfi_user = 0 
where empno in (select distinct empno from VU_JOB_AFCUSER where status = 0);
update emplmast set projmngr = 0 
where empno in (select distinct empno from VU_JOB_PM where status = 0);
update emplmast set job_incharge = 0 
where empno in (select distinct empno from VU_JOB_SPONSOR where status = 0);
update emplmast set dirop = 0 
where empno in (select distinct empno from VU_JOB_CMD where status = 0);
commit;
*/
-- Check records exists in COMMONMASTERS
--select count(*) into vExits from commonmasters.system_grants
--Where applsystem = '018';  --'012';  --ts
-- Remove records in COMMONMASTERS if exits
--if (vExits > 0) then
delete from commonmasters.system_grants
where applsystem = '018' ; --'012' ;--vApplsystem;
commit;
--end if;
-- Insert records available in VU_SYSTEM_GRANTS
insert into commonmasters.system_grants (
empno,
applsystem,
rolename,
roledesc,
module,
ROLE_ON_COSTCODE
)
select
vu_sys.empno,
vApplsystem,
vu_sys.role,   --vu_sys.rolename,
vu_sys.role,
vu_sys.applsystem ,--vu_sys.applsystem,
--vu_sys.module
vu_sys.costcode
from
ts_role vu_sys;
--where
--applsystem = vApplsystem;
if ( Sql%rowcount > 0 ) then
param_msg_type := 'SUCCESS';
else
param_msg_type := 'FAILURE';
end if;



end sp_rap_systemgrants;
end pkg_systemgrants;

/
