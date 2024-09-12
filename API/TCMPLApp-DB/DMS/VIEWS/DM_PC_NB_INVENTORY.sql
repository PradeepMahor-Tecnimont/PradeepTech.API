--------------------------------------------------------
--  DDL for View DM_PC_NB_INVENTORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_PC_NB_INVENTORY" ("ASSETID", "COMPNAME", "MODEL", "ASSETTYPE", "EMPNO", "NAME", "SHIFT", "SOURCEREF", "REMARKS") AS 
  select a.assetid, a.compname, a.model, a.assettype, a.empno, initcap(b.name) name, 
  selfservice.getshift1(a.empno,sysdate) shift, a.sourceref, a.remarks from (
    select t.assetid, t.compname, t.model, t.assettype,
      replace(regexp_substr(t.col, '[^;]+', 1, 1),'-','') empno,
      replace(regexp_substr(t.col, '[^;]+', 1, 2),'-','') assetid_1,
      replace(regexp_substr(t.col, '[^;]+', 1, 3),'-','') sourceref,
      replace(regexp_substr(t.col, '[^;]+', 1, 4),'-','') remarks
     from (select trim(x.barcode) assetid, x.compname, x.model, x.assettype,   
            (select dmsv2.get_emp_asset(trim(x.barcode)) col from dual) col   
           from dm_assetcode x
           where x.assettype in ('PC','NB') and x.scrap = 0) t) a
      left outer join ss_emplmast b on a.empno = b.empno
;
