--------------------------------------------------------
--  DDL for View DESMAS_ALLOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DESMAS_ALLOCATION" ("DESKID", "OFFICE", "FLOOR", "WING", "CABIN", "EMPNO1", "NAME1", "USERID1", "DEPT1", "GRADE1", "DESG1", "SHIFT1", "EMAIL1", "EMPNO2", "NAME2", "USERID2", "DEPT2", "GRADE2", "DESG2", "SHIFT2", "EMAIL2", "COMPNAME", "COMPUTER", "PCMODEL", "MONITOR1", "MONMODEL1", "MONITOR2", "MONMODEL2", "TELEPHONE", "TELMODEL", "PRINTER", "PRINTMODEL", "DOCSTN", "DOCSTNMODEL", "PC_RAM", "PC_GCARD") AS 
  select xx.deskid,office,floor,decode(wing,null,' ',wing) wing,decode(cabin,'C','Cabin',decode(cabin,null,' ',cabin)) cabin,empno1,name1,Userid1,dept1,grade1,desg1,selfservice.getshift1(empno1,sysdate) shift1,email1,
empno2,name2,Userid2,dept2,grade2,desg2,selfservice.getshift1(empno2,sysdate) shift2,email2,Compname,Computer,PCModel,Monitor1,MonModel1,Monitor2,MonModel2,Telephone,TelModel,Printer,PrintModel,DocStn,DocStnModel,
dmsv2.get_ram(Computer) PC_RAM, dmsv2.get_gcard(Computer) PC_GCARD from
(select g.deskid,empno1,name1,Userid1,dept1,grade1,desg1,email1,empno2,name2,Userid2,dept2,grade2,desg2,email2,Compname,Computer,PCModel,Monitor1,MonModel1,Monitor2,MonModel2,Telephone,TelModel,Printer,PrintModel,DocStn,DocStnModel from
(select x.deskid,empno1,name1,Userid1,dept1,email1,grade1,desg1,empno2,name2,Userid2,dept2,grade2,desg2,email2,
Computer,PCModel,Monitor1,MonModel1,Monitor2,MonModel2,Telephone,TelModel,Printer,PrintModel,DocStn,DocStnModel from
(select deskid,max(decode(cnt,1,decode(empno,null,' ',empno))) Empno1,
max(decode(cnt,1,decode(name,null,' ',name))) Name1,
max(decode(cnt,1,decode(userid,null,' ',userid))) Userid1,
max(decode(cnt,1,decode(parent,null,' ',parent))) Dept1,
max(decode(cnt,1,decode(grade,null,' ',grade))) Grade1,
max(decode(cnt,1,decode(desg,null,' ',desg))) Desg1,
max(decode(cnt,1,decode(email,null,' ',email))) email1,
max(decode(cnt,2,decode(empno,null,' ',empno))) Empno2,
max(decode(cnt,2,decode(name,null,' ',name))) Name2,
max(decode(cnt,2,decode(userid,null,' ',userid))) Userid2,
max(decode(cnt,2,decode(parent,null,' ',parent))) Dept2,
max(decode(cnt,2,decode(email,null,' ',email))) email2,
max(decode(cnt,2,decode(grade,null,' ',grade))) Grade2,
max(decode(cnt,2,decode(desg,null,' ',desg))) Desg2 from
(select * from (select a.deskid,c.empno,d.name,e.userid,d.parent,d.grade,f.desg,d.email, row_number() Over(Partition By a.deskid Order By a.deskid, c.empno) Cnt
from dm_deskmaster a,dm_usermaster c,ss_emplmast d,userids e,ss_desgmast f
where c.empno = d.empno(+) and a.deskid = c.deskid(+)  and c.empno = e.empno(+)
and d.desgcode = f.desgcode(+) and a.deskid not in (select deskid from dm_desklock)) where cnt <= 2) group by deskid) x,
(select deskid,max(decode(n,1,decode(assettype,'C',assetid,' '))) Computer,
max(decode(n,1,decode(assettype,'C',Model,' '))) PCModel,
max(decode(n,1,decode(assettype,'M',assetid,' '))) Monitor1,
max(decode(n,1,decode(assettype,'M',Model,' '))) MonModel1,
max(decode(n,2,decode(assettype,'M',assetid,' '))) Monitor2,
max(decode(n,2,decode(assettype,'M',Model,' '))) MonModel2,
max(decode(n,1,decode(assettype,'T',assetid,' '))) Telephone,
max(decode(n,1,decode(assettype,'T',Model,' '))) TelModel,
max(decode(n,1,decode(assettype,'P',assetid,' '))) Printer,
max(decode(n,1,decode(assettype,'P',Model,' '))) PrintModel,
max(decode(n,1,decode(assettype,'D',assetid,' '))) DocStn,
max(decode(n,1,decode(assettype,'D',Model,' '))) DocStnModel
from (select * from (select a.deskid,a.assetid,b.model,
decode(substr(a.assetid,6,2),'C/','C','PC','C','NB','C','L/','C','M/','M','MO','M','T/','T','TL','T','IP','T','PR','P','DS','D','Z') assettype, 
row_number() over (partition by a.deskid,decode(substr(a.assetid,6,2),'C/','C','PC','C','NB','C','L/','C','M/','M','MO','M','T/','T','TL','T','IP','T','PR','P','DS','D','Z') 
order by a.deskid,decode(substr(a.assetid,6,2),'C/','C','PC','C','NB','C','L/','C','M/','M','MO','M','T/','T','TL','T','IP','T','PR','P','DS','D','Z')) n
from dm_deskallocation a,dm_assetcode b where trim(a.assetid) = trim(b.barcode(+))) where n <= 2) group by deskid) y where x.deskid = y.deskid(+)) g 
left outer join dm_assetcode h on trim(g.computer) = trim(h.barcode)) xx left outer join dm_deskmaster yy on trim(xx.deskid) = trim(yy.deskid(+))
;
