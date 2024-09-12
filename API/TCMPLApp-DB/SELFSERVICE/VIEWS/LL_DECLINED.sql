--------------------------------------------------------
--  DDL for View LL_DECLINED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."LL_DECLINED" ("ORGREQNUM", "ORGREQDATE", "ORGCATEGORY", "ORGAUTHOR", "ORGCOAUTHOR", "ORGDEPT", "ORGPROJECT", "ORGCOUNTRY", "ORGPLANT", "ORGTECHNOLOGY", "ORGFROM", "ORGTO", "ORGRPHASE", "ORGPPHASE", "ORGSUBJECT", "ORGACTIVITY", "ORGPACKAGE", "ORGEVENT", "ORGIMPACT", "ORGAPPLIED", "ORGSOLUTION", "ORGPRJNAME", "EMPNO", "COSTCODE", "KEYWORDDEPT", "COMPNAME") AS 
  select orgreqnum,orgreqdate,orgcategory,orgauthor,orgcoauthor,orgdept,orgproject,orgcountry,
orgplant,orgtechnology,orgfrom,orgto,orgrphase,orgpphase,orgsubject,orgactivity,orgpackage,
orgevent,orgimpact,orgapplied,orgsolution,orgprjname,empno,costcode,keyworddept,compname
from ll_originator where orgstatus = 2
;
