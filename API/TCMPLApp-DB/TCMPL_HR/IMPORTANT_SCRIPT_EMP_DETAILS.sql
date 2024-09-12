-- Alter Table emp_details Modify (p_add_1 Varchar2(200), r_add_1 Varchar2(200), f_add_1 Varchar2(200));

/*
Update
    emp_details
Set
    p_add_1 = trim(Trailing ' ' from (p_add_1 || ' ' || p_add_2 || ' ' || p_add_3 ));
    
Update
    emp_details
Set
    R_add_1 = trim(Trailing ' ' from (R_add_1 || ' ' || R_add_2 || ' ' || R_add_3 ));
    
Update
    emp_details
Set
    F_add_1 = trim(Trailing ' ' from (F_add_1 || ' ' || F_add_2 || ' ' || F_add_3 ));
*/
 
/*
Alter Table emp_details
 Drop (p_add_1_old, p_add_2_old, p_add_3_old, p_add_4_old,
       p_add_2, r_add_2, f_add_2,
       p_add_3, r_add_3, f_add_3
       );

alter table emp_details rename column p_add_4 to p_state;
alter table emp_details rename column r_add_4 to r_state;
alter table emp_details rename column f_add_4 to f_state;


*/

/*

ALTER TABLE EMP_GRATUITY 
ADD MODIFIED_BY CHAR(5 BYTE);

ALTER TABLE EMP_FAMILY 
ADD MODIFIED_BY CHAR(5 BYTE);

ALTER TABLE EMP_EPS_4_MARRIED 
ADD MODIFIED_BY CHAR(5 BYTE);

ALTER TABLE EMP_EPS_4_ALL 
ADD MODIFIED_BY CHAR(5 BYTE);

ALTER TABLE EMP_EPF 
ADD MODIFIED_BY CHAR(5 BYTE);

ALTER TABLE EMP_GTLI 
ADD MODIFIED_BY CHAR(5 BYTE);

ALTER TABLE emp_sup_annuation 
ADD MODIFIED_BY CHAR(5 BYTE);

ALTER TABLE emp_scan_file 
ADD MODIFIED_BY CHAR(5 BYTE);
 
*/


/*
ALTER TABLE "TCMPL_HR"."EMP_GRATUITY" ADD ("KEY_ID" VARCHAR2(5) );
update emp_gratuity set key_id = dbms_random.string('X',5);
ALTER TABLE "TCMPL_HR"."EMP_GRATUITY" DROP CONSTRAINT "EMP_GRATUITY_UK1";
ALTER TABLE "TCMPL_HR"."EMP_GRATUITY" DROP CONSTRAINT "EMP_GRATUITY_PK";
drop index emp_gratuity_pk;
drop index EMP_GRATUITY_UK1;
ALTER TABLE "TCMPL_HR"."EMP_GRATUITY" ADD CONSTRAINT "EMP_GRATUITY_PK" PRIMARY KEY ("KEY_ID") ENABLE;
ALTER TABLE "TCMPL_HR"."EMP_GRATUITY" ADD CONSTRAINT "EMP_GRATUITY_UK1" UNIQUE ("EMPNO","NOM_NAME") ENABLE;

---------------------------
--Changed TABLE
--EMP_DETAILS
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_DETAILS" ADD CONSTRAINT "FK_PC_STAT" FOREIGN KEY ("PUNCH_CARD_STATUS") REFERENCES "TCMPL_HR"."EMP_PUNCH_CARD_STATUS"("CODE") ENABLE NOVALIDATE;

---------------------------
--Changed TABLE
--EMP_EPS_4_ALL
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_ALL" ADD ("KEY_ID" VARCHAR2(5) );
update EMP_EPS_4_ALL set key_id = dbms_random.string('X',5);
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_ALL" DROP CONSTRAINT "EMP_EPS_4_ALL_UK1";
DROP index EMP_EPS_4_ALL_PK;
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_ALL" ADD CONSTRAINT "EMP_EPS_4_ALL_PK" PRIMARY KEY ("KEY_ID") ENABLE;
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_ALL" ADD CONSTRAINT "EMP_EPS_4_ALL_UK1" UNIQUE ("EMPNO","NOM_NAME") ENABLE;

---------------------------
--New TABLE
--EMP_PUNCH_CARD_STATUS
---------------------------
  CREATE TABLE "TCMPL_HR"."EMP_PUNCH_CARD_STATUS" 
   (	"CODE" NUMBER(2,0),
	"DESCRIPTION" VARCHAR2(60),
	CONSTRAINT "PK_PUNCHCARD_STAT" PRIMARY KEY ("CODE") ENABLE
   );
---------------------------
--Changed TABLE
--EMP_EPS_4_MARRIED
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_MARRIED" ADD ("KEY_ID" VARCHAR2(5) );
update EMP_EPS_4_MARRIED set key_id = dbms_random.string('X',5);
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_MARRIED" DROP CONSTRAINT "EMP_EPS_4_MARRIED_PK";
DROP index "EMP_EPS_4_MARRIED_PK";
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_MARRIED" ADD CONSTRAINT "EMP_EPS_4_MARRIED_PK" PRIMARY KEY ("KEY_ID") ENABLE;
ALTER TABLE "TCMPL_HR"."EMP_EPS_4_MARRIED" ADD CONSTRAINT "EMP_EPS_4_MARRIED_UK1" UNIQUE ("EMPNO","NOM_NAME") ENABLE;

---------------------------
--Changed TABLE
--EMP_GTLI
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_GTLI" ADD ("KEY_ID" VARCHAR2(5) );
update EMP_GTLI set key_id = dbms_random.string('X',5);
ALTER TABLE "TCMPL_HR"."EMP_GTLI" DROP CONSTRAINT "EMP_GTLI_PK";
DROP index "EMP_GTLI_PK";
ALTER TABLE "TCMPL_HR"."EMP_GTLI" ADD CONSTRAINT "EMP_GTLI_PK" PRIMARY KEY ("KEY_ID") ENABLE;
ALTER TABLE "TCMPL_HR"."EMP_GTLI" ADD CONSTRAINT "EMP_GTLI_UK1" UNIQUE ("EMPNO","NOM_NAME") ENABLE;

---------------------------
--Changed TABLE
--EMP_EPF
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_EPF" ADD ("KEY_ID" VARCHAR2(5));
update EMP_EPF set key_id = dbms_random.string('X',5);
ALTER TABLE "TCMPL_HR"."EMP_EPF" DROP CONSTRAINT "EMP_EPF_PK";
DROP index "EMP_EPF_PK";
ALTER TABLE "TCMPL_HR"."EMP_EPF" ADD CONSTRAINT "EMP_EPF_PK" PRIMARY KEY ("KEY_ID") ENABLE;
ALTER TABLE "TCMPL_HR"."EMP_EPF" ADD CONSTRAINT "EMP_EPF_UK1" UNIQUE ("EMPNO","NOM_NAME") ENABLE;

---------------------------
--Changed TABLE
--EMP_PASSPORT
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_PASSPORT" MODIFY ("EMPNO" NOT NULL ENABLE);
alter table emp_passport drop (clint_file_name,server_file_name);
Insert Into emp_passport(
    empno,
    has_passport,

    surname,
    given_name,
    issued_at,
    issue_date,
    expiry_date,
    modified_on,
    modified_by,
    passport_no
)

Select
    empno,
    'OK'    has_passpoprt,

    passport_surname,
    passport_given_name,

    passport_issued_at,
    issue_date,
    expiry_date,
    sysdate modified_on,
    'Sys'   modified_by,
    passport_no
From
    emp_details;
    
alter table emp_details drop(
    passport_surname,
    passport_given_name,
    passport_issued_at,
    issue_date,
    expiry_date,
    passport_no,
    include_dad_husb_name
);    
---------------------------
--Changed TABLE
--EMP_SUP_ANNUATION
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_SUP_ANNUATION" ADD ("KEY_ID" VARCHAR2(5) );
update EMP_SUP_ANNUATION set key_id = dbms_random.string('X',5);
ALTER TABLE "TCMPL_HR"."EMP_SUP_ANNUATION" DROP CONSTRAINT "EMP_SUP_ANNUATION_PK";
drop index EMP_SUP_ANNUATION_PK;

ALTER TABLE "TCMPL_HR"."EMP_SUP_ANNUATION" ADD CONSTRAINT "EMP_SUP_ANNUATION_PK" PRIMARY KEY ("KEY_ID") ENABLE;
ALTER TABLE "TCMPL_HR"."EMP_SUP_ANNUATION" ADD CONSTRAINT "EMP_SUP_ANNUATION_UK1" UNIQUE ("EMPNO","NOM_NAME") ENABLE;

---------------------------
--Changed TABLE
--EMP_ADHAAR
---------------------------
ALTER TABLE "TCMPL_HR"."EMP_ADHAAR" ADD ("HAS_AADHAAR" CHAR(2));
update emp_adhaar set has_aadhaar='OK';
ALTER TABLE "TCMPL_HR"."EMP_ADHAAR" ADD ("MODIFIED_BY" CHAR(5));
ALTER TABLE "TCMPL_HR"."EMP_ADHAAR" DROP CONSTRAINT "EMP_ADHAAR_PK";
ALTER TABLE "TCMPL_HR"."EMP_ADHAAR" ADD CONSTRAINT "EMP_ADHAAR_UK1" UNIQUE ("EMPNO") ENABLE;

---------------------------
--New TABLE
--EMP_DETAILS_INCLUDE_EMPTYPE
---------------------------
  CREATE TABLE "TCMPL_HR"."EMP_DETAILS_INCLUDE_EMPTYPE" 
   (	"EMPTYPE" CHAR(1) NOT NULL ENABLE,
	CONSTRAINT "EMP_DETAILS_INCLUDE_EMPTYPE_PK" PRIMARY KEY ("EMPTYPE") ENABLE
   );
   
   insert into EMP_DETAILS_INCLUDE_EMPTYPE(emptype) values('R);
   insert into EMP_DETAILS_INCLUDE_EMPTYPE(emptype) values('F';
   Commit;
*/ 



/*
update emp_details set
p_add_1 = replace( p_add_1,', ,',','),
r_add_1 = replace( r_add_1,', ,',','),
f_add_1 = replace( f_add_1,', ,',',')
;

--replace continuous white space / tabs / carraige return
UPDATE emp_details
   SET p_add_1 = REGEXP_REPLACE(p_add_1, '\s{2,}', ' ')
 WHERE REGEXP_LIKE(p_add_1, '\s{2,}');

UPDATE emp_details
   SET r_add_1 = REGEXP_REPLACE(r_add_1, '\s{2,}', ' ')
 WHERE REGEXP_LIKE(r_add_1, '\s{2,}');

UPDATE emp_details
   SET f_add_1 = REGEXP_REPLACE(f_add_1, '\s{2,}', ' ')
 WHERE REGEXP_LIKE(f_add_1, '\s{2,}');

update emp_details set
p_add_1 = replace( p_add_1,' , ' , ', '),
r_add_1 = replace( r_add_1,' , ',', '),
f_add_1 = replace( f_add_1,' , ',', ')
;
update emp_details set
p_add_1 = ''
where trim(p_add_1) = ','
;

update emp_details set
r_add_1 = ''
where trim(r_add_1) = ','
;

update emp_details set
f_add_1 = ''
where trim(f_add_1) = ','
;
*/




--

TIMECURR
---


alter table cv_emplmast modify(per_add1 varchar2(200), res_add1 varchar2(200));



update cv_emplmast set per_add1 = trim(per_add1 || ' ' || per_add2 || ' ' || per_add3),
res_add1 = trim(res_add1 || ' ' || res_add2 || ' ' || res_add2);


alter table cv_emplmast drop COLUMNS(per_add2,per_add3, res_add1, res_add2);