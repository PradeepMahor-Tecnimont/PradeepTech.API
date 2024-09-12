--------------------------------------------------------
--  DDL for Function TMA_ORDER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."TMA_ORDER" (inPROJNO PROJMAST.PROJNO%TYPE,inACTIVE PROJMAST.ACTIVE%TYPE,inPROJTYPE PROJMAST.PROJTYPE%TYPE,inCDATE PROJMAST.CDATE%TYPE,inYYMM VARCHAR2,inDATE VARCHAR2,inECDATE PROJMAST.CDATE%TYPE) RETURN CHAR IS
   RETURN_VALUE CHAR(1);
   DUMMY PROJMAST.PROJNO%TYPE;
BEGIN
   IF inACTIVE > 0 THEN
      IF inPROJTYPE = 'O' THEN
         RETURN_VALUE := 'E';
         
      ELSIF inPROJTYPE = 'P' or inPROJTYPE = 'U' THEN
         RETURN_VALUE := 'A';
          if to_CHAR(inECDATE,'YYYYMM') < inYYMM then
           RETURN_VALUE := 'C';
         end if;
      ELSE
         RETURN_VALUE := 'D';
       --  SELECT DISTINCT PROJNO INTO DUMMY FROM PRJCMAST WHERE YYMM > inYYMM AND PROJNO = inPROJNO;
         if to_CHAR(inECDATE,'YYYYMM') < inYYMM then
           RETURN_VALUE := 'C';
         end if;
      END IF;
   ELSE
      IF inCDATE > inDATE THEN
         RETURN_VALUE := 'B';
      ELSE
         RETURN_VALUE := 'F';
      END IF;
   END IF;
   RETURN RETURN_VALUE;
--EXCEPTION
--  WHEN NO_DATA_FOUND THEN
--        RETURN 'C';
--  WHEN OTHERS THEN
 --       RETURN 'F';
END;

/
