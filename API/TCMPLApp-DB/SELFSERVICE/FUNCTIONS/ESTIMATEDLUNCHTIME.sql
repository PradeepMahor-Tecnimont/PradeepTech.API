--------------------------------------------------------
--  DDL for Function ESTIMATEDLUNCHTIME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ESTIMATEDLUNCHTIME" (
      p_EmpNo IN VARCHAR2,
      p_PDate IN DATE,
      p_SCode IN VARCHAR2)
    RETURN NUMBER
  IS
    v_RetVal NUMBER := 0;
    vStartHH NUMBER := 0;
    vStartMN NUMBER := 0;
    vEndHH   NUMBER := 0;
    vEndMN   NUMBER := 0;
    vParent  VARCHAR2(10);
  BEGIN
  --xx
    IF Get_Holiday(p_PDate) = 0 THEN
      --SELECT Assign INTO vParent FROM SS_EmplMast WHERE EmpNo = Trim(p_EmpNo);
      SELECT lunch_mn
      INTO v_retval
      FROM ss_shiftmast
      WHERE SHIFTCODE = trim(p_scode);
      /*Select StartHH, StartMN, EndHH, EndMN
      InTo vStartHH, vStartMN, vEndHH, vEndMN
      From SS_LunchMast Where ShiftCode = Trim(p_SCode) And Parent = Trim(vParent);
      v_RetVal := ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);*/
    END IF;
    RETURN v_RetVal;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN 30;
  END;


/
