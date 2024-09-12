--------------------------------------------------------
--  DDL for Procedure INSERTPUNCHUNIQUE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."INSERTPUNCHUNIQUE" (ErrLevel OUT number) IS

  cursor cur_punch is select * from ss_IPFormat where mach in 
    (SELECT MACH_NAME FROM SS_SWIPE_MACH_MAST WHERE valid_4_in_out = 1);


  cursor cur_4All_punch is select * from ss_ipformat   ;

  BEGIN

    Delete from ss_importpunch where mach not in (Select mach_name from ss_swipe_mach_mast WHERE valid_4_in_out = 1);
    commit;
    UpDate SS_ImportPunch Set EmpNo = (Select EmpNo From SS_VU_CONTMAST Where PunchNo = SS_ImportPunch.EmpNo ) Where EmpNo In (Select PunchNo From SS_VU_CONTMAST); 
    commit;

    for c3 in cur_punch loop
      Begin
        Insert into SS_Punch(empno,hh,mm,ss,pdate,falseflag,dd,mon,yyyy,mach) values
          (c3.empno,c3.hh,c3.mm,c3.ss,c3.pdate,1,c3.dd,c3.mon,c3.yyyy,c3.mach);
      commit;
      exception
        when others then null;
      end;
    end loop;


    for c4 in cur_4All_punch loop
      Begin
        Insert into SS_Punch_all(empno,hh,mm,ss,pdate,falseflag,dd,mon,yyyy,mach) values
          (c4.empno,c4.hh,c4.mm,c4.ss,c4.pdate,1,c4.dd,c4.mon,c4.yyyy,c4.mach);
      commit;
      exception
        when others then null;
      end;
    end loop;


    declare
      cursor cur_4auto_punch is select distinct empno, pdate from ss_ipformat;
    begin
      for c1 in cur_4auto_punch loop
        generate_auto_punch(c1.empno,c1.pdate);
      end loop;
    end;



    ErrLevel := 0;
  /*Exception
    when others then
      ErrLevel := 1;*/
  END;


/
