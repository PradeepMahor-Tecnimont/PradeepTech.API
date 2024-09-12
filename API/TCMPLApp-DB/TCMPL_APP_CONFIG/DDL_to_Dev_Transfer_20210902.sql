--------------------------------------------------------
--  File created - Thursday-September-02-2021   
--------------------------------------------------------
DROP SEQUENCE "TCMPL_APP_CONFIG"."SEQ_ACTIONS";
DROP TABLE "TCMPL_APP_CONFIG"."CONFIG_SCHEMA";
DROP TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS";
DROP TABLE "TCMPL_APP_CONFIG"."SEC_MODULES";
DROP TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES";
DROP TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLE_ACTIONS";
DROP TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_USER_ROLES";
DROP TABLE "TCMPL_APP_CONFIG"."SEC_ROLES";
DROP VIEW "TCMPL_APP_CONFIG"."VU_EMPLMAST";
DROP VIEW "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS";
DROP VIEW "TCMPL_APP_CONFIG"."VU_USERIDS";
DROP PACKAGE "TCMPL_APP_CONFIG"."APP_MODULE";
DROP PACKAGE "TCMPL_APP_CONFIG"."APP_USERS";
DROP PACKAGE "TCMPL_APP_CONFIG"."GENERATE_CSHARP_CODE";
DROP PACKAGE BODY "TCMPL_APP_CONFIG"."APP_MODULE";
DROP PACKAGE BODY "TCMPL_APP_CONFIG"."APP_USERS";
DROP PACKAGE BODY "TCMPL_APP_CONFIG"."GENERATE_CSHARP_CODE";
--------------------------------------------------------
--  DDL for Sequence SEQ_ACTIONS
--------------------------------------------------------

   CREATE SEQUENCE  "TCMPL_APP_CONFIG"."SEQ_ACTIONS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table CONFIG_SCHEMA
--------------------------------------------------------

  CREATE TABLE "TCMPL_APP_CONFIG"."CONFIG_SCHEMA" 
   (	"SCHEMA_NAME" VARCHAR2(30)
   ) ;
--------------------------------------------------------
--  DDL for Table SEC_ACTIONS
--------------------------------------------------------

  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" 
   (	"MODULE_ID" CHAR(3), 
	"ACTION_ID" CHAR(8), 
	"ACTION_NAME" VARCHAR2(20), 
	"ACTION_DESC" VARCHAR2(200), 
	"ACTION_IS_ACTIVE" VARCHAR2(2), 
	"MODULE_ACTION_KEY_ID" CHAR(7)
   ) ;
--------------------------------------------------------
--  DDL for Table SEC_MODULES
--------------------------------------------------------

  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_MODULES" 
   (	"MODULE_ID" CHAR(3), 
	"MODULE_NAME" VARCHAR2(20), 
	"MODULE_LONG_DESC" VARCHAR2(200), 
	"MODULE_IS_ACTIVE" VARCHAR2(2), 
	"MODULE_SCHEMA_NAME" VARCHAR2(30), 
	"FUNC_TO_CHECK_USER_ACCESS" VARCHAR2(30), 
	"MODULE_SHORT_DESC" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table SEC_MODULE_ROLES
--------------------------------------------------------

  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" 
   (	"MODULE_ID" CHAR(3), 
	"ROLE_ID" CHAR(4), 
	"MODULE_ROLE_KEY_ID" VARCHAR2(7)
   ) ;
--------------------------------------------------------
--  DDL for Table SEC_MODULE_ROLE_ACTIONS
--------------------------------------------------------

  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLE_ACTIONS" 
   (	"MODULE_ID" CHAR(3), 
	"ROLE_ID" CHAR(4), 
	"ACTION_ID" CHAR(4), 
	"MODULE_ROLE_ACTION_KEY_ID" CHAR(11), 
	"MODULE_ROLE_KEY_ID" CHAR(7)
   ) ;
--------------------------------------------------------
--  DDL for Table SEC_MODULE_USER_ROLES
--------------------------------------------------------

  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_USER_ROLES" 
   (	"MODULE_ID" CHAR(3), 
	"ROLE_ID" CHAR(4), 
	"EMPNO" CHAR(5), 
	"PERSON_ID" CHAR(8), 
	"MODULE_ROLE_KEY_ID" CHAR(7)
   ) ;
--------------------------------------------------------
--  DDL for Table SEC_ROLES
--------------------------------------------------------

  CREATE TABLE "TCMPL_APP_CONFIG"."SEC_ROLES" 
   (	"ROLE_ID" CHAR(4), 
	"ROLE_NAME" VARCHAR2(20), 
	"ROLE_DESC" VARCHAR2(200), 
	"ROLE_IS_ACTIVE" VARCHAR2(2)
   ) ;
--------------------------------------------------------
--  DDL for View VU_EMPLMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_APP_CONFIG"."VU_EMPLMAST" ("EMPNO", "NAME", "ABBR", "EMPTYPE", "EMAIL", "ASSIGN", "PARENT", "DESGCODE", "PASSWORD", "DOB", "DOJ", "DOL", "DOR", "COSTHEAD", "COSTDY", "PROJMNGR", "PROJDY", "DBA", "DIRECTOR", "STATUS", "SUBMIT", "OFFICE", "PROJNO", "DIROP", "AMFI_USER", "AMFI_AUTH", "SECRETARY", "DO", "INV_AUTH", "JOB_INCHARGE", "COSTOPR", "MNGR", "IPADD", "PWD_CHGD", "DOC", "GRADE", "PROC_OPR", "REPORTO", "COMPANY", "TRANS_OUT", "TRANS_IN", "HR_OPR", "SEX", "USER_DOMAIN", "WEB_ITDECL", "CATEGORY", "ESI_COVER", "EMP_HOD", "SEATREQ", "NEWEMP", "ONDEPUTATION", "OLDCO", "MARRIED", "JOBTITLE", "EOW", "EOW_DATE", "EOW_WEEK", "LASTNAME", "FIRSTNAME", "MIDDLENAME", "SAPEMP", "PFSLNO", "ADD1", "ADD2", "ADD3", "ADD4", "PINCODE", "CONTRACT_END_DATE", "JOBGROUP", "JOBGROUPDESC", "JOBDISCIPLINE", "JOBDISCIPLINEDESC", "JOBSUBDISCIPLINE", "JOBSUBDISCIPLINEDESC", "JOBCATEGORY", "JOBCATEGOORYDESC", "JOBSUBCATEGORY", "JOBSUBCATEGORYDESC", "ITNO", "LASTDAY", "SUBCONTRACT", "NO_TCM_UPD", "PAYROLL", "EXPATRIATE", "METAID", "PERSONID", "CID", "BANKACNO", "IFSCNO", "PER_EMAIL") AS 
  SELECT 
    "EMPNO","NAME","ABBR","EMPTYPE","EMAIL","ASSIGN","PARENT","DESGCODE","PASSWORD","DOB","DOJ","DOL","DOR","COSTHEAD","COSTDY","PROJMNGR","PROJDY","DBA","DIRECTOR","STATUS","SUBMIT","OFFICE","PROJNO","DIROP","AMFI_USER","AMFI_AUTH","SECRETARY","DO","INV_AUTH","JOB_INCHARGE","COSTOPR","MNGR","IPADD","PWD_CHGD","DOC","GRADE","PROC_OPR","REPORTO","COMPANY","TRANS_OUT","TRANS_IN","HR_OPR","SEX","USER_DOMAIN","WEB_ITDECL","CATEGORY","ESI_COVER","EMP_HOD","SEATREQ","NEWEMP","ONDEPUTATION","OLDCO","MARRIED","JOBTITLE","EOW","EOW_DATE","EOW_WEEK","LASTNAME","FIRSTNAME","MIDDLENAME","SAPEMP","PFSLNO","ADD1","ADD2","ADD3","ADD4","PINCODE","CONTRACT_END_DATE","JOBGROUP","JOBGROUPDESC","JOBDISCIPLINE","JOBDISCIPLINEDESC","JOBSUBDISCIPLINE","JOBSUBDISCIPLINEDESC","JOBCATEGORY","JOBCATEGOORYDESC","JOBSUBCATEGORY","JOBSUBCATEGORYDESC","ITNO","LASTDAY","SUBCONTRACT","NO_TCM_UPD","PAYROLL","EXPATRIATE","METAID","PERSONID","CID","BANKACNO","IFSCNO","PER_EMAIL"
FROM 
    
commonmasters.emplmast
;
--------------------------------------------------------
--  DDL for View VU_MODULE_USER_ROLE_ACTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS" ("MODULE_ID", "MODULE_SHORT_DESC", "ROLE_ID", "ROLE_NAME", "EMPNO", "PERSON_ID", "ACTION_ID") AS 
  Select
    ur.module_id,
    m.module_short_desc,
    ur.role_id,
    r.role_name,
    ur.empno,
    ur.person_id,
    ra.action_id
From
    sec_module_user_roles   ur,
    sec_modules             m,
    sec_roles               r,
    sec_module_role_actions ra
Where
    ur.module_id              = m.module_id
    And ur.role_id            = r.role_id
    And ur.module_role_key_id = ra.module_role_key_id(+)
;
--------------------------------------------------------
--  DDL for View VU_USERIDS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_APP_CONFIG"."VU_USERIDS" ("EMPNO", "NAME", "OFFICE", "USERID", "DATETIME", "EMAIL", "DOMAIN", "MODIFIED_ON", "INSERT_ON") AS 
  SELECT "EMPNO","NAME","OFFICE","USERID","DATETIME","EMAIL","DOMAIN","MODIFIED_ON","INSERT_ON"
    
FROM 
    
selfservice.userids
;
REM INSERTING into TCMPL_APP_CONFIG.CONFIG_SCHEMA
SET DEFINE OFF;
Insert into TCMPL_APP_CONFIG.CONFIG_SCHEMA (SCHEMA_NAME) values ('SELFSERVICE');
REM INSERTING into TCMPL_APP_CONFIG.SEC_ACTIONS
SET DEFINE OFF;
Insert into TCMPL_APP_CONFIG.SEC_ACTIONS (MODULE_ID,ACTION_ID,ACTION_NAME,ACTION_DESC,ACTION_IS_ACTIVE,MODULE_ACTION_KEY_ID) values ('M01','A0000003','CR_SWP','Create Read - SWP for all users','OK',null);
Insert into TCMPL_APP_CONFIG.SEC_ACTIONS (MODULE_ID,ACTION_ID,ACTION_NAME,ACTION_DESC,ACTION_IS_ACTIVE,MODULE_ACTION_KEY_ID) values ('M01','A0000004','CR_VACCINE','Create Read - Self Vaccine Info','OK',null);
REM INSERTING into TCMPL_APP_CONFIG.SEC_MODULES
SET DEFINE OFF;
Insert into TCMPL_APP_CONFIG.SEC_MODULES (MODULE_ID,MODULE_NAME,MODULE_LONG_DESC,MODULE_IS_ACTIVE,MODULE_SCHEMA_NAME,FUNC_TO_CHECK_USER_ACCESS,MODULE_SHORT_DESC) values ('M01','SWPVACCINE','Smart Work Policy & Vaccination','OK','SELFSERVICE',null,'SWP & Vaccine');
Insert into TCMPL_APP_CONFIG.SEC_MODULES (MODULE_ID,MODULE_NAME,MODULE_LONG_DESC,MODULE_IS_ACTIVE,MODULE_SCHEMA_NAME,FUNC_TO_CHECK_USER_ACCESS,MODULE_SHORT_DESC) values ('M02','OFFBOARDING','Employee Off-boarding','OK','TCMPL_HR',null,'Off-Boarding');
Insert into TCMPL_APP_CONFIG.SEC_MODULES (MODULE_ID,MODULE_NAME,MODULE_LONG_DESC,MODULE_IS_ACTIVE,MODULE_SCHEMA_NAME,FUNC_TO_CHECK_USER_ACCESS,MODULE_SHORT_DESC) values ('M03','HRMASTERS','HR Masters module (EMPLMAST, COSTMAST,etc)','OK','TIMECURR',null,'HR Masters');
REM INSERTING into TCMPL_APP_CONFIG.SEC_MODULE_ROLES
SET DEFINE OFF;
Insert into TCMPL_APP_CONFIG.SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M01','R001','M01R001');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M01','R002','M01R002');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M02','R001','M02R001');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M02','R002','M02R002');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M03','R010','M03R010');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M03','R011','M03R011');
REM INSERTING into TCMPL_APP_CONFIG.SEC_MODULE_ROLE_ACTIONS
SET DEFINE OFF;
REM INSERTING into TCMPL_APP_CONFIG.SEC_MODULE_USER_ROLES
SET DEFINE OFF;
Insert into TCMPL_APP_CONFIG.SEC_MODULE_USER_ROLES (MODULE_ID,ROLE_ID,EMPNO,PERSON_ID,MODULE_ROLE_KEY_ID) values ('M03','R010','02848','01009525','M03R010');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_USER_ROLES (MODULE_ID,ROLE_ID,EMPNO,PERSON_ID,MODULE_ROLE_KEY_ID) values ('M03','R010','04057','01051551','M03R010');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_USER_ROLES (MODULE_ID,ROLE_ID,EMPNO,PERSON_ID,MODULE_ROLE_KEY_ID) values ('M03','R011','02079','01009204','M03R011');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_USER_ROLES (MODULE_ID,ROLE_ID,EMPNO,PERSON_ID,MODULE_ROLE_KEY_ID) values ('M03','R011','10072','01009413','M03R011');
Insert into TCMPL_APP_CONFIG.SEC_MODULE_USER_ROLES (MODULE_ID,ROLE_ID,EMPNO,PERSON_ID,MODULE_ROLE_KEY_ID) values ('M03','R010','02320','01009257','M03R010');
REM INSERTING into TCMPL_APP_CONFIG.SEC_ROLES
SET DEFINE OFF;
Insert into TCMPL_APP_CONFIG.SEC_ROLES (ROLE_ID,ROLE_NAME,ROLE_DESC,ROLE_IS_ACTIVE) values ('R001','TCMPL_EMP','TCMPL Employee - Status=1','OK');
Insert into TCMPL_APP_CONFIG.SEC_ROLES (ROLE_ID,ROLE_NAME,ROLE_DESC,ROLE_IS_ACTIVE) values ('R002','HOD','Head of Department','OK');
Insert into TCMPL_APP_CONFIG.SEC_ROLES (ROLE_ID,ROLE_NAME,ROLE_DESC,ROLE_IS_ACTIVE) values ('R003','SEC','Dept Secretary','OK');
Insert into TCMPL_APP_CONFIG.SEC_ROLES (ROLE_ID,ROLE_NAME,ROLE_DESC,ROLE_IS_ACTIVE) values ('R010','PAYROLL_ADM','Payroll Admin','OK');
Insert into TCMPL_APP_CONFIG.SEC_ROLES (ROLE_ID,ROLE_NAME,ROLE_DESC,ROLE_IS_ACTIVE) values ('R011','ATTENDANCE_ADM','Attendance Admin','OK');
--------------------------------------------------------
--  DDL for Index SEC_MODULE_INDEX1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_MODULE_INDEX1" ON "TCMPL_APP_CONFIG"."SEC_MODULES" ("MODULE_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index SEC_ACTIONS_INDEX1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_ACTIONS_INDEX1" ON "TCMPL_APP_CONFIG"."SEC_ACTIONS" ("ACTION_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index CONFIG_SCHEMA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."CONFIG_SCHEMA_PK" ON "TCMPL_APP_CONFIG"."CONFIG_SCHEMA" ("SCHEMA_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index SEC_MODULE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_MODULE_PK" ON "TCMPL_APP_CONFIG"."SEC_MODULES" ("MODULE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SEC_ROLES_INDEX1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_ROLES_INDEX1" ON "TCMPL_APP_CONFIG"."SEC_ROLES" ("ROLE_NAME") 
  ;
--------------------------------------------------------
--  DDL for Index SEC_ACTONS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_ACTONS_PK" ON "TCMPL_APP_CONFIG"."SEC_ACTIONS" ("MODULE_ID", "ACTION_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SEC_ROLES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_ROLES_PK" ON "TCMPL_APP_CONFIG"."SEC_ROLES" ("ROLE_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SEC_MODULE_ROLES_INDEX1
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES_INDEX1" ON "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" ("MODULE_ROLE_KEY_ID") 
  ;
--------------------------------------------------------
--  DDL for Index SEC_MODULE_ROLES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES_PK" ON "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" ("MODULE_ID", "ROLE_ID") 
  ;
--------------------------------------------------------
--  DDL for Trigger TRIG_ACTIONS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_ACTIONS_01" Before
Insert Or Update Of action_desc, action_id, action_is_active, action_name, module_action_key_id On sec_actions
Referencing
Old As old
New As new
For Each Row
Begin
    Declare
        n_next_id Number;
    Begin
        n_next_id := seq_actions.nextval;
        If inserting Then
            :new.action_id := 'A' || lpad(n_next_id, 7, '0');
        End If;

    End;

    :new.module_id            := trim(upper(:new.module_id));
    :new.action_id            := trim(upper(:new.action_id));
    :new.action_name          := trim(upper(:new.action_name));
    :new.action_is_active     := trim(upper(:new.action_is_active));
    :new.module_action_key_id := :new.module_id || :new.action_id;
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_ACTIONS_01" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_CONFIG_SCHEMA_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_CONFIG_SCHEMA_01" Before
    Insert Or Update Of schema_name On config_schema
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.schema_name := Upper(Trim(:new.schema_name));
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_CONFIG_SCHEMA_01" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_MODULE_ROLE_ACTIONS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_MODULE_ROLE_ACTIONS_01" Before
Insert Or Update Of module_id, role_id, action_id, module_role_action_key_id, module_role_key_id On sec_module_role_actions
Referencing
Old As old
New As new
For Each Row
Begin
    :new.module_id                 := upper(trim(:new.module_id));
    :new.role_id                   := upper(trim(:new.role_id));
    :new.action_id                 := upper(trim(:new.action_id));
    :new.module_role_action_key_id := :new.module_id || :new.role_id || :new.action_id;
    :new.module_role_key_id        := :new.module_id || :new.role_id;

End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_MODULE_ROLE_ACTIONS_01" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_MODULE_USER_ROLES_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_MODULE_USER_ROLES_01" Before
Insert Or Update Of module_id, role_id, empno, person_id, module_role_key_id On tcmpl_app_config.sec_module_user_roles
Referencing
Old As old
New As new
For Each Row
Begin
    :new.module_id          := upper(trim(:new.module_id));
    :new.role_id            := upper(trim(:new.role_id));
    :new.empno              := upper(trim(:new.empno));
    :new.module_role_key_id := :new.module_id || :new.role_id;

End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_MODULE_USER_ROLES_01" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_SEC_MODULE_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_01" Before
    Insert Or Update Of module_name, module_id On "SEC_MODULES"
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.module_name        := Upper(Trim(:new.module_name));
    :new.module_id          := Upper(Trim(:new.module_id));
    :new.module_is_active   := Trim(Upper(:new.module_is_active));
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_01" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_SEC_MODULE_ROLES_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_ROLES_01" Before
    Insert Or Update Of module_role_key_id , module_id, role_id On sec_module_roles
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.module_role_key_id := :new.module_id || :new.role_id;
End;


/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_MODULE_ROLES_01" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRIG_SEC_ROLES_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_ROLES_01" Before
    Insert Or Update On sec_roles
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.role_id          := Trim(Upper(:new.role_id));
    :new.role_name        := Trim(Upper(:new.role_name));
    :new.role_is_active   := Trim(Upper(:new.role_is_active));
End;

/
ALTER TRIGGER "TCMPL_APP_CONFIG"."TRIG_SEC_ROLES_01" ENABLE;
--------------------------------------------------------
--  DDL for Package APP_MODULE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."APP_MODULE" As
    Procedure get_user_access (
        p_win_uid       Varchar2,
        p_modules_csv   Out             Varchar2,
        p_success       Out             Varchar2,
        p_message       Out             Varchar2
    );

End app_module;


/
--------------------------------------------------------
--  DDL for Package APP_USERS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."APP_USERS" As
    Function get_empno_from_win_uid (
        p_win_uid Varchar2
    ) Return Varchar2;

    Procedure get_emp_details_from_win_uid (
        p_win_uid    Varchar2,
        p_empno      Out          Varchar2,
        p_emp_name   Out          Varchar2,
        p_costcode   Out          Varchar2,
        p_success    Out          Varchar2,
        p_message    Out          Varchar2
    );

End app_users;


/
--------------------------------------------------------
--  DDL for Package GENERATE_CSHARP_CODE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "TCMPL_APP_CONFIG"."GENERATE_CSHARP_CODE" As 

    Procedure proc_to_class (
        p_package_name   In               Varchar2,
        p_proc_name      In               Varchar2,
        p_class          Out              Varchar2
    );

    Procedure table_to_class (
        p_table_view_name Varchar2,
        p_class Out Varchar2
    );

End generate_csharp_code;




/
--------------------------------------------------------
--  DDL for Package Body APP_MODULE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."APP_MODULE" As

    Procedure get_user_access (
        p_win_uid       Varchar2,
        p_modules_csv   Out             Varchar2,
        p_success       Out             Varchar2,
        p_message       Out             Varchar2
    ) As
        v_empno   Char(5);
        v_roles   Varchar2(1000);
    Begin

        --Initialze

        --Initialize
        --************** 

        --
        v_empno         := app_users.get_empno_from_win_uid(p_win_uid);
        If v_empno Is Null Then
            return;
        End If;

        --Get roles in SWP-Vaccine Module
        v_roles         := selfservice.swp_users.fnc_get_roles_for_user(param_win_uid => p_win_uid);
        If v_roles <> 'NONE' Then
            p_modules_csv := p_modules_csv || ',SWPVACCINE';
        End If;

        --Get roles in OffBoarding
        v_roles         := tcmpl_hr.ofb_user.get_roles_csv_from_win_uid(p_win_uid => p_win_uid);
        
        If v_roles <> 'NONE' Then
            p_modules_csv := p_modules_csv || ',OFFBOARDING';
        End If;
        
        p_modules_csv   := Trim(Both ',' From p_modules_csv);
        p_success       := 'OK';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End get_user_access;

End app_module;

/
--------------------------------------------------------
--  DDL for Package Body APP_USERS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."APP_USERS" As

    Function get_empno_from_win_uid (
        p_win_uid Varchar2
    ) Return Varchar2 As
        v_user_domain   Varchar2(60);
        v_user_id       Varchar2(60);
        v_empno         Varchar2(5);
    Begin
        v_user_domain   := Substr(p_win_uid, 1, Instr(p_win_uid, '\') - 1);

        v_user_id       := Substr(p_win_uid, Instr(p_win_uid, '\') + 1);
        Select
            a.empno
        Into v_empno
        From
            vu_userids    a,
            vu_emplmast   b
        Where
            a.empno = b.empno
            And Upper(a.userid)  = Upper(v_user_id)
            And Upper(a.domain)  = Upper(v_user_domain)
            And b.status         = 1;

        If v_empno = '02320' Then
            Null;
            --v_empno := '02242'; -- Nitin Narvekar
            --v_empno := '02640'; -- Mayekar Abhijit
            --v_empno := '02848'; -- Nilesh Sawant
            --v_empno := '01938'; -- Sanjay Mistry
            --v_empno := '02079'; -- Kotian
            v_empno := '04057'; --Kadam Sunil
            --v_empno := '00583'; -- MAKUR GAUTAM	
            --v_empno := '10072'; -- Vinay Joshi
            --v_empno := '02459'; --Annie Fernandes
            --v_empno := '01994'; --Sharvari Vaidya
            --v_empno := '03682'; --Mandar Santan Chandrakant
            --v_empno := '01746';
        End If;
        Return v_empno;
    Exception
        When Others Then
            Return Null;
    End;

    Procedure get_emp_details_from_win_uid (
        p_win_uid    Varchar2,
        p_empno      Out          Varchar2,
        p_emp_name   Out          Varchar2,
        p_costcode   Out          Varchar2,
        p_success    Out          Varchar2,
        p_message    Out          Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno     := get_empno_from_win_uid(p_win_uid);
        Select
            empno,
            name,
            parent
        Into
            p_empno,
            p_emp_name,
            p_costcode
        From
            vu_emplmast
        Where
            empno = v_empno;

        p_success   := 'OK';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

End app_users;

/
--------------------------------------------------------
--  DDL for Package Body GENERATE_CSHARP_CODE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_APP_CONFIG"."GENERATE_CSHARP_CODE" As

    Procedure proc_to_class (
        p_package_name   In               Varchar2,
        p_proc_name      In               Varchar2,
        p_class          Out              Varchar2
    ) As

        Cursor cur_proc_params Is
        Select
            object_name,
            package_name,
            argument_name,
            data_type,
            in_out
        From
            user_arguments
        Where
            package_name = Upper(p_package_name)
            And object_name = Upper(p_proc_name)
        Order By
            position;

        v_class        Varchar2(4000);
        v_properties   Varchar2(2000);
        v_datatype     Varchar2(60);
        v_class_name   Varchar2(60);
    Begin
        v_class        := 'public class CLASS_NAME ! { ! public string CommandText {get => "' --
         || Upper(p_package_name) || '.' || Upper(p_proc_name) || '"; } ! PARAM_NAMES ! }';

        v_class_name   := Replace(Initcap(p_package_name) || Initcap(p_proc_name), '_', '');

        v_class        := Replace(v_class, 'CLASS_NAME', v_class_name);
        For cur_row In cur_proc_params Loop
            v_datatype :=
                Case cur_row.data_type
                    When 'VARCHAR2' Then
                        'string'
                    When 'CHAR' Then
                        'string'
                    When 'DATE' Then
                        'DateTime'
                    When 'NUMBER' Then
                        'Int32'
                    Else 'string'
                End;

            If cur_row.in_out = 'OUT' Then
                v_properties := v_properties || ' public ' || v_datatype || ' Out' || Trim(Replace(Initcap(cur_row.argument_name)
                , '_')) || ' { get; set; } ! ';
            Else
                v_properties := v_properties || ' public ' || v_datatype || '    ' || Replace(Initcap(cur_row.argument_name), '_'
                ) || ' { get; set; } ! ';
            End If;

        End Loop;

        v_class        := Replace(Replace(v_class, 'PARAM_NAMES', v_properties), '!', Chr(13));

        p_class        := v_class;
    End proc_to_class;

    Procedure table_to_class (
        p_table_view_name Varchar2,
        p_class Out Varchar2
    ) As

        Cursor cur_columns Is
        Select
            table_name,
            column_name,
            data_type
        From
            user_tab_columns
        Where
            table_name = Upper(p_table_view_name);

        v_class        Varchar(4000);
        v_properties   Varchar2(3900);
        v_datatype     Varchar2(60);
        v_class_name   Varchar2(60);
    Begin
        v_class   := 'public class CHANGE_CLASS_NAME ! { ! PARAM_NAMES ! }';
        For cur_row In cur_columns Loop
            v_datatype     :=
                Case cur_row.data_type
                    When 'VARCHAR2' Then
                        'string'
                    When 'CHAR' Then
                        'string'
                    When 'DATE' Then
                        'DateTime'
                    When 'NUMBER' Then
                        'Int32'
                    Else 'string'
                End;

            v_properties   := v_properties || ' public ' || v_datatype || ' ' || Replace(Initcap(cur_row.column_name), '_') || '{get;set;}! '
            ;

        End Loop;

        v_class   := Replace(Replace(v_class, 'PARAM_NAMES', v_properties), '!', Chr(13));

        p_class   := v_class;
    End;

End generate_csharp_code;



/
--------------------------------------------------------
--  Constraints for Table CONFIG_SCHEMA
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."CONFIG_SCHEMA" MODIFY ("SCHEMA_NAME" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."CONFIG_SCHEMA" ADD CONSTRAINT "CONFIG_SCHEMA_PK" PRIMARY KEY ("SCHEMA_NAME")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table SEC_MODULE_ROLES
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" MODIFY ("MODULE_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" MODIFY ("MODULE_ROLE_KEY_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" ADD CONSTRAINT "SEC_MODULE_ROLES_PK" PRIMARY KEY ("MODULE_ID", "ROLE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table SEC_ACTIONS
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" MODIFY ("ACTION_IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" MODIFY ("ACTION_DESC" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" MODIFY ("ACTION_NAME" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" MODIFY ("ACTION_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" ADD CONSTRAINT "SEC_ACTONS_PK" PRIMARY KEY ("MODULE_ID", "ACTION_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table SEC_MODULES
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULES" MODIFY ("MODULE_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULES" MODIFY ("MODULE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULES" MODIFY ("MODULE_LONG_DESC" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULES" MODIFY ("MODULE_IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULES" ADD CONSTRAINT "SEC_MODULE_PK" PRIMARY KEY ("MODULE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table SEC_ROLES
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ROLES" MODIFY ("ROLE_ID" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ROLES" MODIFY ("ROLE_NAME" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ROLES" MODIFY ("ROLE_DESC" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ROLES" MODIFY ("ROLE_IS_ACTIVE" NOT NULL ENABLE);
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ROLES" ADD CONSTRAINT "SEC_ROLES_PK" PRIMARY KEY ("ROLE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SEC_ACTIONS
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_ACTIONS" ADD CONSTRAINT "SEC_ACTIONS_FK1" FOREIGN KEY ("MODULE_ID")
	  REFERENCES "TCMPL_APP_CONFIG"."SEC_MODULES" ("MODULE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SEC_MODULE_ROLES
--------------------------------------------------------

  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" ADD CONSTRAINT "SEC_MODULE_ROLES_FK1" FOREIGN KEY ("MODULE_ID")
	  REFERENCES "TCMPL_APP_CONFIG"."SEC_MODULES" ("MODULE_ID") ENABLE;
  ALTER TABLE "TCMPL_APP_CONFIG"."SEC_MODULE_ROLES" ADD CONSTRAINT "SEC_MODULE_ROLES_FK2" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "TCMPL_APP_CONFIG"."SEC_ROLES" ("ROLE_ID") ENABLE;
