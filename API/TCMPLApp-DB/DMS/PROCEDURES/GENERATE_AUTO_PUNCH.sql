--------------------------------------------------------
--  DDL for Procedure GENERATE_AUTO_PUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GENERATE_AUTO_PUNCH" (
    p_EmpNo IN VARCHAR2,
    p_PDate IN DATE)
AS
  CURSOR cur_punch_data  IS
    SELECT a.hh,a.mm,a.ss,b.office FROM ss_integratedpunch a, ss_swipe_mach_mast b WHERE a.pdate = p_Pdate
      AND a.empno   = p_empno
      AND a.mach    = b.mach_name(+)
      and falseflag = 1
      ORDER BY a.hh, a.mm,a.ss;
  v_pdate DATE;
  v_Count NUMBER;
  Type rec_Hrs IS record (hh     NUMBER,mm     NUMBER,hhmm   NUMBER,ss Number, office CHAR(10) );
  Type type_Tab_Hrs IS TABLE OF rec_hrs INDEX BY Binary_Integer;
  o_Tab_Hrs type_tab_hrs;
  v_THrs      VARCHAR2(10);
  v_cntr      NUMBER;
  v_Loop_cntr NUMBER;
BEGIN
  --reset_punch(p_empno,p_pdate);
  
  SELECT COUNT(*) INTO v_Count FROM ss_integratedpunch  WHERE empno =p_EmpNo  AND pdate   = p_PDate;
  IF v_Count <= 2 THEN
    RETURN;
  END IF;

  DELETE FROM ss_punch_auto WHERE empno=p_empno AND pdate=p_pdate;
  COMMIT;
  v_cntr := 1;
  FOR c1 IN cur_punch_data
  LOOP
    o_tab_hrs(v_Cntr).hh     := c1.hh;
    o_tab_hrs(v_Cntr).mm     := c1.mm;
    o_tab_hrs(v_cntr).hhmm   := (c1.hh * 60) + c1.mm;
    o_tab_hrs(v_cntr).ss     := c1.ss;
    o_tab_hrs(v_cntr).office := nvl(c1.office,'ODAP');
    v_cntr                   := v_cntr + 1;
  END LOOP;
  
  FOR v_loop_cntr IN 1..v_cntr-1
  LOOP
    IF mod(v_loop_cntr,2) = 0 and v_loop_cntr < v_cntr-1 THEN
      IF ( o_tab_hrs(v_loop_cntr  + 1).hhmm - o_tab_hrs(v_loop_cntr).hhmm) <= 30 and ( o_tab_hrs(v_loop_cntr  + 1).hhmm - o_tab_hrs(v_loop_cntr).hhmm) > 0 THEN
        IF o_tab_hrs(v_loop_cntr).office <> o_tab_hrs(v_loop_cntr + 1).office THEN
          insert_auto_punch 
          (
                p_empno, 
                p_pdate, 
                o_TAB_HRS(v_loop_cntr).hh, 
                O_TAB_HRS(v_loop_cntr).mm,
                O_TAB_HRS(v_loop_cntr).ss+1, 
                o_TAB_HRS(v_loop_cntr +1).hh, 
                O_TAB_HRS(v_loop_cntr+1).mm,
                O_TAB_HRS(v_loop_cntr+1).ss -1, 
                2 
          ); -- Inter Office Punch
        END IF;
      END IF;
    END IF;
  END LOOP;
  
END GENERATE_AUTO_PUNCH;

/
