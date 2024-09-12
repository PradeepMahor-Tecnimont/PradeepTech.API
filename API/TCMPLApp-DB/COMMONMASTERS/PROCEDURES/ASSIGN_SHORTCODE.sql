--------------------------------------------------------
--  DDL for Procedure ASSIGN_SHORTCODE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "COMMONMASTERS"."ASSIGN_SHORTCODE" IS
   V_SHORTCD VARCHAR2(3);
   V_SHORTCD_F VARCHAR2(1);
   V_SHORTCD_M VARCHAR2(1);
   V_SHORTCD_L VARCHAR2(1);
   V_SHORTCD_LEVEL NUMBER(3);
   V_SHORTCD_LEVEL2 NUMBER(3);
   V_Shortcd_Level3 Number(3);
   V_Shortcd_Level4 Number(2);
   V_Shortcd_Level5 Number(2);
    V_SHORTCD_LEVEL6 NUMBER(2);
   --CURSOR C1 IS SELECT * FROM LIST1 WHERE  SUBSTR(NEW_SHORTCD,1,1) = ' ' OR SUBSTR(NEW_SHORTCD,1,1) = '' ORDER BY EMPTYPE DESC, DOJ ASC FOR UPDATE;
 --  CURSOR C1 IS SELECT * FROM LIST1  ORDER BY EMPTYPE DESC, DOJ ASC FOR UPDATE;
--CURSOR C1 IS SELECT * FROM LIST1 WHERE  empno = '11582' ORDER BY EMPTYPE DESC, DOJ ASC FOR UPDATE;
 CURSOR C1 IS SELECT * FROM LIST1 WHERE NEW_SHORTCD = ' ' ORDER BY EMPTYPE DESC, DOJ ASC FOR UPDATE;
BEGIN
   -- UPDATE LIST1 SET NEW_SHORTCD = '   ';
   -- UPDATE LIST1 SET NEW_SHORTCD = SUBSTR(SHORTCD,1,3) WHERE SUBSTR(GRADE,1,1) = 'X';
  -- OPEN C1;
  --DBMS_OUTPUT.put_line('Count is ' || C1%ROWCOUNT);
  -- CLOSE C1;
   FOR V_RECORD IN C1 LOOP
 --  DBMS_OUTPUT.put_line('hello '||v_record.empno);
       V_SHORTCD := '';
       V_SHORTCD_F := '';
       V_SHORTCD_M := '';
       V_SHORTCD_L := '';
       V_SHORTCD_LEVEL := 0;
       V_SHORTCD_LEVEL2 := 0;
       V_Shortcd_Level3 := 0;
        V_Shortcd_Level4 := 0;
        V_Shortcd_Level5 := 0;
         V_SHORTCD_LEVEL6 := 0;
       IF trim(V_RECORD.FIRSTNAME) is not null  THEN
          V_SHORTCD := V_SHORTCD || SUBSTR(V_RECORD.FIRSTNAME,1,1);
          V_SHORTCD_F := SUBSTR(V_RECORD.FIRSTNAME,1,1);
       END IF;
       IF trim(V_RECORD.SECONDLAST)  is not null THEN
          V_SHORTCD := V_SHORTCD || SUBSTR(V_RECORD.SECONDLAST,1,1);
          V_SHORTCD_M := SUBSTR(V_RECORD.SECONDLAST,1,1);
       END IF;
      -- IF nvl(SUBSTR(V_RECORD.LASTNAME,1,1),'') <> '' AND SUBSTR(V_RECORD.LASTNAME,1,1) <> '' THEN
      IF trim(V_RECORD.LASTname)  is not null THEN
          V_SHORTCD := V_SHORTCD || SUBSTR(V_RECORD.LASTNAME,1,1);
          V_SHORTCD_L := SUBSTR(V_RECORD.LASTNAME,1,1);
       END IF;
      -- DBMS_OUTPUT.put_line(v_record.empno ||  v_record.firstname || v_record.lastname || V_SHORTCD ||V_SHORTCD_F || V_SHORTCD_M || V_SHORTCD_L);
       IF SHORTCD_FOUND(V_SHORTCD) = 0 THEN
          UPDATE LIST1 SET NEW_SHORTCD = V_SHORTCD WHERE CURRENT OF C1;
       --   DBMS_OUTPUT.put_line(v_record.name ||v_record.empno || V_SHORTCD ||V_SHORTCD_F || V_SHORTCD_M || V_SHORTCD_L);
   
       ELSE
          V_SHORTCD := '';
          IF trim(V_RECORD.LASTNAME) is not null then
             V_SHORTCD := V_SHORTCD || SUBSTR(V_RECORD.LASTNAME,1,1);
          END IF;
          IF trim(V_RECORD.FIRSTNAME) is not null then
             V_SHORTCD := V_SHORTCD || SUBSTR(V_RECORD.FIRSTNAME,1,1);
          END IF;
          IF trim(V_RECORD.SECONDLAST) is not null then
             V_SHORTCD := V_SHORTCD || SUBSTR(V_RECORD.SECONDLAST,1,1);
          END IF;
          LOOP
             IF SHORTCD_FOUND(V_SHORTCD) = 0 THEN
                UPDATE LIST1 SET NEW_SHORTCD = V_SHORTCD WHERE CURRENT OF C1;
                EXIT;
             END IF;
             V_SHORTCD_LEVEL := V_SHORTCD_LEVEL + 1;
             IF V_SHORTCD_LEVEL = 1 THEN
                V_SHORTCD := V_SHORTCD_F || V_SHORTCD_L;
             END IF;
             IF V_SHORTCD_LEVEL > 1 THEN
                IF V_SHORTCD_LEVEL <= 10 THEN
                   V_SHORTCD := V_SHORTCD_F || V_SHORTCD_L || LTRIM(RTRIM(TO_CHAR(V_SHORTCD_LEVEL-1)));
                ELSE
                   IF V_SHORTCD_LEVEL = 11 THEN
                      V_SHORTCD := V_SHORTCD_L || V_SHORTCD_F;
                   ELSE
                      IF V_SHORTCD_LEVEL <= 20 THEN
                         V_SHORTCD := V_SHORTCD_L || V_SHORTCD_F || LTRIM(RTRIM(TO_CHAR(V_SHORTCD_LEVEL-11)));
                      ELSE
                         V_SHORTCD_LEVEL2 := V_SHORTCD_LEVEL2 + 1;
                         IF V_SHORTCD_LEVEL2 <= 99 THEN
                            V_SHORTCD := V_SHORTCD_F || LPAD(LTRIM(RTRIM(TO_CHAR(V_SHORTCD_LEVEL2))),2,'0');    
                         ELSE
                            V_SHORTCD_LEVEL3 := V_SHORTCD_LEVEL3 + 1;
                            IF V_SHORTCD_LEVEL3 <= 99 THEN   
                              V_SHORTCD := V_SHORTCD_L || LPAD(LTRIM(RTRIM(TO_CHAR(V_SHORTCD_LEVEL3))),2,'0');    -- Upen
                             Else 
                                V_Shortcd_Level4 := V_Shortcd_Level4 + 1;
                                If V_Shortcd_Level4 <= 9 Then 
                                   V_Shortcd := Ltrim(Rtrim(To_Char(V_Shortcd_Level4))) || V_Shortcd_L  || V_Shortcd_F;
                                Else
                                   V_Shortcd_Level5 := V_Shortcd_Level5 + 1;
                                   If V_Shortcd_Level5 <= 9 Then 
                                      V_Shortcd := Ltrim(Rtrim(To_Char(V_Shortcd_Level5))) || V_Shortcd_F  || V_Shortcd_L;
                                   Else
                                       V_Shortcd_Level6 := V_Shortcd_Level6 + 1;
                                       If V_Shortcd_Level6 <= 9 Then 
                                          V_Shortcd := V_Shortcd_L || Ltrim(Rtrim(To_Char(V_Shortcd_Level6)))    || V_Shortcd_F;
                                       Else
                                         Exit;
                                      End if;
                                   End if;   
                                end if;
                             END IF; 
                         END IF;   
                      END IF;
                   END IF;
                END IF;
             END IF;
          END LOOP;
       END IF;
   END LOOP;
   COMMIT;
EXCEPTION
    WHEN OTHERS THEN
      --  DBMS_OUTPUT.put_line('ERROR : '||SQLERRM);
        ROLLBACK;                   	
        RAISE;
END;

/
