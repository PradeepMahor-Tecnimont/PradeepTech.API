--------------------------------------------------------
--  DDL for View LL_REJECTED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."LL_REJECTED" ("LLNUM", "LLDATE", "LLCATEGORY", "LLAUTHOR", "LLCOAUTHOR", "LLDEPT", "LLPROJECT", "LLCOUNTRY", "LLPLANT", "LLTECHNOLOGY", "LLFROM", "LLTO", "LLRPHASE", "LLPPHASE", "LLSUBJECT", "LLACTIVITY", "LLPACKAGE", "LLEVENT", "LLIMPACT", "LLAPPLIED", "LLSOLUTION", "LLRECIPIENT", "ORGREQNUM", "REVIEWACCEPTDATE", "CLOSEDATE", "LLPRJNAME", "OWNDEPT", "KEYWORDDEPT", "CHNGREQ", "CHNGDESC", "TRGTDATE", "SUBJECTNEW", "COMPNAME") AS 
  select llnum,lldate,llcategory,llauthor,llcoauthor,lldept,llproject,llcountry,llplant,lltechnology,
llfrom,llto,llrphase,llpphase,llsubject,llactivity,llpackage,llevent,llimpact,llapplied,llsolution,
llrecipient,orgreqnum,reviewacceptdate,closedate,llprjname,owndept,
keyworddept,chngreq,chngdesc,trgtdate,subjectnew,compname
from ll_recorded where llstatus = 'X'
;
