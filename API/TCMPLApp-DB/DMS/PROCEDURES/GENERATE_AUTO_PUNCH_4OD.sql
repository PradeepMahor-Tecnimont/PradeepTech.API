--------------------------------------------------------
--  DDL for Procedure GENERATE_AUTO_PUNCH_4OD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GENERATE_AUTO_PUNCH_4OD" (
    p_od_app IN VARCHAR2 )
AS
  CURSOR c1
  IS
  WITH t AS
    (SELECT p_od_app str FROM DUAL
    )
SELECT REGEXP_SUBSTR (str, '[^,]+', 1, LEVEL) appno
FROM t
  CONNECT BY LEVEL <=
  (SELECT LENGTH (REPLACE (str, ',', NULL)) FROM t
  );
vEmpNo CHAR(5);
vPDate DATE;
BEGIN
  FOR c2 IN c1
  LOOP
    if trim(c2.AppNo) is not null then
    
    SELECT DISTINCT empno,
      pdate
    INTO vEmpNo,
      vPDate
    FROM ss_onduty
    WHERE Trim(app_no) = trim((c2.appno));
    generate_auto_punch(vEmpNo, vPDate);
    end if;
  END LOOP;
END GENERATE_AUTO_PUNCH_4OD;

/
