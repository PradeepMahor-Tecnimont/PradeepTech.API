--------------------------------------------------------
--  DDL for Procedure C_INS_NEW_PROJECT_OPENMAST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."C_INS_NEW_PROJECT_OPENMAST" AS
cursor c1 is (select distinct projno,newco from openmast_COPY where  projno||newCO not in (select projno||CO from projmast)  AND PROJNO NOT IN ('0014110',
'0325308',
'0325309',
'0325310',
'0328709',
'0341209',
'0891035',
'0891813',
'0892035',
'0894210',
'0894314',
'0895110',
'0933414',
'0940902',
'0962735',
'2222409',
'5555409',
'E222414',
'E666410'
));
cursor c2(vProjno char,vCo char) is select * from projmast where rownum = 1 and co = vCo and substr(projno,1,5) = substr(vProjno,1,5) and ( active = 1 or (cdate >= '01-JAN-2011' and cdate <= '31-MAR-2011')) order by projno;
c1_rec c1%rowtype;
c2_rec c2%rowtype;
test_projno CHAR(7);
TEST_CO CHAR(1);
BEGIN
 open c1;
  loop
      fetch c1 into c1_rec;
      exit when c1%NOTFOUND; 
      test_projno := c1_rec.projno;
      TEST_CO := c1_rec.newco;
      open c2 (c1_rec.projno,c1_rec.newco);
      loop
          fetch c2 into c2_rec;
          exit when c2%NOTFOUND;
      insert into projmast (PROJNO,NAME,CLIENT,SDATE,EXPTCDATE,CDATE,COSTCODE,PRJMNGR,PRJDYMNGR,ORIGINAL,REVISED,PROJTYPE,TYPE,TMAGRP,ABBR,ACTIVE,TCM_JOBS,TCM_GRP,PRJOPER,TCMNO,REIMB_JOB,EOU_JOB,EXCL_BILLING,EXCL_DELTA_BILLING,BU,PROJ_NO,BLOCK_BOOKING,CO,PHASE_RULE,NEWCOSTCODE,REVCDATE,BLOCK_OT,CCAPPRL) values (c1_rec.projno,c2_rec.NAME,c2_rec.CLIENT, c2_rec.SDATE, c2_rec.EXPTCDATE, c2_rec.CDATE,c2_rec.COSTCODE, c2_rec.PRJMNGR, c2_rec.PRJDYMNGR, c2_rec.ORIGINAL, c2_rec.REVISED, c2_rec.PROJTYPE, c2_rec.TYPE, c2_rec.TMAGRP, c2_rec.ABBR, c2_rec.ACTIVE, c2_rec.TCM_JOBS, c2_rec.TCM_GRP, c2_rec.PRJOPER, c2_rec.TCMNO, c2_rec.REIMB_JOB, c2_rec.EOU_JOB, c2_rec.EXCL_BILLING, c2_rec.EXCL_DELTA_BILLING, c2_rec.BU, c2_rec.PROJ_NO, c2_rec.BLOCK_BOOKING, C1_REC.NEWCO, c2_rec.PHASE_RULE, c2_rec.NEWCOSTCODE, c2_rec.REVCDATE, c2_rec.BLOCK_OT, c2_rec.CCAPPRL);
      --INSERT INTO ANITA(PROJNO,NAME,CO) (
      -- dbms_output.put_line('projno ' || test_projno||'-'||test_co);
      end loop;
      close c2;
      commit;
  end loop;
  close c1;
  commit;   
END ;

/
