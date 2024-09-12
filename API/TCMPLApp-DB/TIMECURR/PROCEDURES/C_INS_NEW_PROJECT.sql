--------------------------------------------------------
--  DDL for Procedure C_INS_NEW_PROJECT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."C_INS_NEW_PROJECT" AS
cursor c1 is ( select distinct projno,co from TIMETRAN_copy  where projno||co  not in (select projno||co from projmast));
cursor c2 (vProjno char,vCo char) is select * from projmast where rownum = 1 and co = vCo and substr(projno,1,5) = substr(vProjno,1,5) and ( active = 1 or (cdate >='01-JAN-2011' AND CDATE <= '31-MAR-2011')) order by projno;
c1_rec c1%rowtype;
c2_rec c2%rowtype;
test_projno CHAR(7);
test_co char(1);
BEGIN
  open c1;
  loop
      fetch c1 into c1_rec;
      exit when c1%NOTFOUND; 
      test_projno := c1_rec.projno;
      test_co := c1_rec.co;
      open c2(c1_rec.projno ,c1_rec.co);
      loop
          fetch c2 into c2_rec;
          exit when c2%NOTFOUND;
          insert into projmast (PROJNO,NAME,CLIENT,SDATE,EXPTCDATE,CDATE,COSTCODE,PRJMNGR,PRJDYMNGR,ORIGINAL,REVISED,PROJTYPE,TYPE,TMAGRP,ABBR,ACTIVE,TCM_JOBS,TCM_GRP,PRJOPER,TCMNO,REIMB_JOB,EOU_JOB,EXCL_BILLING,EXCL_DELTA_BILLING,BU,PROJ_NO,BLOCK_BOOKING,CO,PHASE_RULE,NEWCOSTCODE,REVCDATE,BLOCK_OT,CCAPPRL) values (test_projno,c2_rec.NAME,c2_rec.CLIENT, c2_rec.SDATE, c2_rec.EXPTCDATE, c2_rec.CDATE,c2_rec.COSTCODE, c2_rec.PRJMNGR, c2_rec.PRJDYMNGR, c2_rec.ORIGINAL, c2_rec.REVISED, c2_rec.PROJTYPE, c2_rec.TYPE, c2_rec.TMAGRP, c2_rec.ABBR, c2_rec.ACTIVE, c2_rec.TCM_JOBS, c2_rec.TCM_GRP, c2_rec.PRJOPER, c2_rec.TCMNO, c2_rec.REIMB_JOB, c2_rec.EOU_JOB, c2_rec.EXCL_BILLING, c2_rec.EXCL_DELTA_BILLING, c2_rec.BU, c2_rec.PROJ_NO, c2_rec.BLOCK_BOOKING, test_co, c2_rec.PHASE_RULE, c2_rec.NEWCOSTCODE, c2_rec.REVCDATE, c2_rec.BLOCK_OT, c2_rec.CCAPPRL);
      end loop;
      close c2;
      commit;
  end loop;
  close c1;
  commit;   
END;

/
