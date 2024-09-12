--------------------------------------------------------
--  DDL for Procedure REPOST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."REPOST" (proc_month in timetran.yymm%type) IS
cursor c1 is select * from time_mast where approved > 0 and yymm = proc_month for update;
rec time_mast%rowtype;
BEGIN
   open c1;
   Loop
      fetch c1 into rec;
      exit when c1%NOTFOUND;
      delete from timetran where yymm = rec.yymm and empno = rec.empno and costcode = rec.assign;
      insert into timetran(yymm,empno,costcode,projno,wpcode,activity,grp,company,hours,othours) select yymm,empno,assign,projno,wpcode,activity,grp,company,sum(nhrs),sum(ohrs) from postingdata where yymm = rec.yymm and empno = rec.empno and assign = rec.assign group by yymm,empno,assign,projno,wpcode,activity,grp,company;
      update time_mast set posted = 1 where current of c1;
   end loop;
   close c1;
   --UPDATE TIMETRAN SET PARENT = 
   UPDATE TIMETRAN    SET PARENT =  (SELECT PARENT FROM EMPLMAST  WHERE emplmast.EMPNO = timetran.EMPNO) where timetran.parent is null;
   commit;
   EXCEPTION
   	 when others then
        dbms_output.put_line('ERROR : '||SQLERRM);
        rollback;            
        raise;    
END;

/
