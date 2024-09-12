--------------------------------------------------------
--  DDL for Procedure INSERT_AUTO_PUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "INSERT_AUTO_PUNCH" (
    p_empno           IN VARCHAR2,
    p_pdate           IN DATE,
    p_hh              IN NUMBER,
    p_mm              IN NUMBER,
    p_ss              IN NUMBER,
    p_hh_1              IN NUMBER,
    p_mm_1              IN NUMBER,
    p_ss_1              IN NUMBER,
    p_auto_punch_type IN NUMBER)
AS
  v_count NUMBER;
BEGIN
  IF P_AUTO_PUNCH_TYPE = 1 THEN -- Auto Punch Type ----->>>>> Lunch
    SELECT COUNT(*)
    INTO v_count
    FROM ss_punch_auto
    WHERE empno       =p_empno
    and trunc(PDATE)=trunc(p_pdate)
    AND auto_punch_type = 1;
    IF v_count         <> 0 THEN
      RETURN;
    END IF;
  END IF;
  INSERT
  INTO ss_punch_auto (empno, PDATE, HH, MM,SS, DD, MON, YYYY, MACH, AUTO_PUNCH_TYPE,falseflag )
    VALUES
    ( p_empno, p_pdate, p_hh, p_mm, p_ss, TO_CHAR(p_pdate,'dd'), TO_CHAR(p_pdate,'mm'), TO_CHAR(p_pdate,'yyyy'), 'SYS', p_auto_punch_type,1
    ) ;
  INSERT
  INTO ss_punch_auto (empno, PDATE, HH, MM,SS, DD, MON, YYYY, MACH, AUTO_PUNCH_TYPE,falseflag )
    VALUES
    ( p_empno, p_pdate, p_hh_1, p_mm_1, p_ss_1, TO_CHAR(p_pdate,'dd'), TO_CHAR(p_pdate,'mm'), TO_CHAR(p_pdate,'yyyy'), 'SYS', p_auto_punch_type,1
    ) ;
END INSERT_AUTO_PUNCH;

/
