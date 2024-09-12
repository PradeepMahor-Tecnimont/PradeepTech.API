--------------------------------------------------------
--  DDL for View DM_VU_EMP_DESK_OFFICE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DESK_OFFICE" ("EMPNO", "NAME", "SHIFT", "EMPTYPE", "DESKID", "OFFICE") AS 
  select x."EMPNO",x."NAME",x."SHIFT",x."EMPTYPE",x."DESKID",y.office from (
select a.empno,name,getshift1(a.empno,sysdate) shift,emptype,B.Deskid from ss_emplmast a, dm_usermaster b where 
emptype in ('R','C','S') and
status=1 and a.empno=b.empno(+)

) x , dm_deskmaster y where x.deskid = y.deskid(+)
;
