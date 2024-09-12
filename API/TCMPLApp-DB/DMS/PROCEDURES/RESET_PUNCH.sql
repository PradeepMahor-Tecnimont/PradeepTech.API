--------------------------------------------------------
--  DDL for Procedure RESET_PUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "RESET_PUNCH" (
    p_empno IN VARCHAR2,
    p_pdate IN DATE )
AS
  CURSOR c1
  IS
    SELECT * FROM ss_punch WHERE empno = trim(p_empno) AND pdate = p_pdate
    order by hh,mm;
Type TabHrsRec
IS
  record
  (
    punch_hrs NUMBER,
    mach      CHAR(10));
Type TabHrs
IS
  TABLE OF TabHrsRec INDEX BY Binary_Integer;
  oTab TabHrs;
  vCount   NUMBER;
  i        NUMBER;
  vInPunch BOOLEAN;
BEGIN
  SELECT COUNT(*)
  INTO vCount
  FROM ss_punch
  WHERE empno = trim(p_empno)
  AND pdate   = p_pdate;
  UPDATE ss_punch SET falseflag=1 WHERE empno=p_empno AND pdate=p_pdate;
  commit;
  IF vCount < 3 THEN
    RETURN;
  END IF;
  i      :=1;
  FOR c2 IN c1
  LOOP
    oTab(i).punch_hrs := ( c2.hh * 60) + c2.mm;
    oTab(i).mach      := c2.mach;
    i                 := i +1;
  END LOOP;
  i     := i-1;
  FOR x    IN 1..i
  LOOP
    IF x        = 1 THEN
      vInPunch := true;
    END IF;
    IF x                                             < i THEN
      IF (otab(x+1).punch_hrs - otab(x).punch_hrs) < 4 and  otab(x+1).mach = otab(x).mach THEN
        IF vInPunch THEN
          UPDATE ss_punch
          SET falseflag = 0
          WHERE empno   = trim(p_empno)
          AND pdate     = p_pdate
          AND hh        = floor(otab(x+1).punch_hrs/60)
          AND mm        = mod(otab(x  +1).punch_hrs,60)
          AND mach      =otab(x       +1).mach;
          commit;
        ELSE
          UPDATE ss_punch
          SET falseflag = 0
          WHERE empno   = trim(p_empno)
          AND pdate     = p_pdate
          AND hh        = floor(otab(x).punch_hrs/60)
          AND mm        = mod(otab(x).punch_hrs,60)
          AND mach      =otab(x).mach;
          commit;
        END IF;
      ELSE
        IF x       <> 1 THEN
          vInPunch := NOT vInPUnch;
        END IF;
      END IF;
    END IF;
    --End If;
  END LOOP;
END RESET_PUNCH;

/
