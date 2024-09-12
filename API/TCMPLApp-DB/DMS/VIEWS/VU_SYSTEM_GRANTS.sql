--------------------------------------------------------
--  DDL for View VU_SYSTEM_GRANTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VU_SYSTEM_GRANTS" ("APPLSYSTEM", "EMPNO", "NAME", "STATUS", "ROLENAMEBYPROJECT", "ROLENAME", "ROLEDESC", "MODULE", "ROLE_ON_COSTCODE") AS 
  select '008' As "APPLSYSTEM", a.empno, b.name, b.status, a.usertype rolenamebyproject,
Case 
    When a.usertype = 'SEC' Then 'Secretary Role' 
    When a.usertype = 'ITUSER' Then 'IT User Role'
    When a.usertype = 'ADMIN' Then 'Desk Management Admin Role' 
    When a.usertype = 'DEPCORD' Then 'Deputation Coordinator Role'
    When a.usertype = 'FIN' Then 'Finance User Role'
    When a.usertype = 'HR' Then 'HR User Role'
    When a.usertype = 'IT' Then 'IT User Authorisation Role'
    When a.usertype = 'ITCORD' Then 'IT Cordinator User Role'
    When a.usertype = 'LIB' Then 'Library User Role'
    When a.usertype = 'SHIFTCORD' Then 'Shift Cordinator User Role'
    When a.usertype = 'TRAVEL' Then 'Travel Desk User Role'
End As rolename,
Case 
    When a.usertype = 'SEC' Then 'Desk Management Request' 
    When a.usertype = 'ITUSER' Then 'View Asset Status'
    When a.usertype = 'ADMIN' Then 'Manage Application' 
    When a.usertype = 'DEPCORD' Then 'Manage Deputation'
    When a.usertype = 'FIN' Then 'Manage Finance Related Issues'
    When a.usertype = 'HR' Then 'Apporve Desk Management Request'
    When a.usertype = 'IT' Then 'Manage Assets'
    When a.usertype = 'ITCORD' Then 'Apporve Assets Movements'
    When a.usertype = 'LIB' Then 'Library User Role'
    When a.usertype = 'SHIFTCORD' Then 'Desk Management Request in Bulk'
    When a.usertype = 'TRAVEL' Then 'Travel Desk Related Request'
End As roledesc, 'Desk Management' module, costcode ROLE_ON_COSTCODE
from (select empno, 'SEC' usertype, costcode from dm_secretary union
select distinct empno, 'ITUSER' usertype, '' costcode from dm_ituser union
select empno, name usertype, '' costcode from dm_emailid) a, ss_emplmast b
where a.empno = b.empno
;
