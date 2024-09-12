--------------------------------------------------------
--  File created - Thursday-January-06-2022   
--------------------------------------------------------
---------------------------
--Changed TABLE
--SS_ABSENT_DETAIL
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" MODIFY ("ABSENT_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" MODIFY ("EMPNO" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" MODIFY ("PAYSLIP_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_DETAIL" ADD CONSTRAINT "SS_ABSENT_DETAIL_PK" PRIMARY KEY ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO") ENABLE;

---------------------------
--Changed TABLE
--SS_ABSENT_TS_DETAIL
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" MODIFY ("ABSENT_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" MODIFY ("EMPNO" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" MODIFY ("PAYSLIP_YYYYMM" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ADD CONSTRAINT "SS_ABSENT_TS_DETAIL_PK" PRIMARY KEY ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO") ENABLE;

---------------------------
--New TABLE
--SS_HEALTH_REMIND_EXP
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_HEALTH_REMIND_EXP" 
   (	"EMPNO" CHAR(5) NOT NULL ENABLE
   );
---------------------------
--Changed TABLE
--SS_ABSENT_TS_LEAVE
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_LEAVE" MODIFY ("WPCODE" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_LEAVE" DROP CONSTRAINT "SS_ABSENT_TS_LEAVE_PK";
ALTER TABLE "SELFSERVICE"."SS_ABSENT_TS_LEAVE" ADD CONSTRAINT "SS_ABSENT_TS_LEAVE_PK" PRIMARY KEY ("EMPNO","TDATE","PROJNO","ACTIVITY","WPCODE") ENABLE;

---------------------------
--New TABLE
--SS_HEALTH_MESSAGE
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_HEALTH_MESSAGE" 
   (	"MESSAGETEXT" VARCHAR2(1000) NOT NULL ENABLE,
	"ISACTIVE" NUMBER(1,0) DEFAULT 1,
	"ORD" NUMBER(2,0),
	"TEXTCOLOR" VARCHAR2(20)
   );
  COMMENT ON COLUMN "SELFSERVICE"."SS_HEALTH_MESSAGE"."ISACTIVE" IS '0 - Inactive, 1 - Active';
---------------------------
--New TABLE
--SS_HEALTH_REMIND_ATTACH
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_HEALTH_REMIND_ATTACH" 
   (	"ID" NUMBER NOT NULL ENABLE,
	"NAME" VARCHAR2(2000),
	"CONTENTTYPE" VARCHAR2(4000),
	"DATABLOB" BLOB,
	"ISACTIVE" NUMBER DEFAULT 1,
	CONSTRAINT "SS_HEALTH_REMIND_ATTACH_PK" PRIMARY KEY ("ID") ENABLE
   );
---------------------------
--Changed TABLE
--SS_HEALTH_EMP
---------------------------
ALTER TABLE "SELFSERVICE"."SS_HEALTH_EMP" ADD ("CLINICLOC" VARCHAR2(4));

---------------------------
--Changed TABLE
--SS_ABSENT_PAYSLIP_PERIOD
---------------------------
ALTER TABLE "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD" MODIFY ("PERIOD" NOT NULL ENABLE);
ALTER TABLE "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD" ADD CONSTRAINT "SS_ABSENT_PAYSLIP_PERIOD_PK" PRIMARY KEY ("PERIOD") ENABLE;

---------------------------
--Changed VIEW
--DM_VU_EMP_DESK_MAP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DESK_MAP" 
 ( "EMPNO", "DESKID", "MODIFIED_ON", "MODIFIED_BY"
  )  AS 
  SELECT 
    "EMPNO","DESKID","MODIFIED_ON","MODIFIED_BY"
FROM 
    
dms.dm_vu_emp_desk_map;
---------------------------
--Changed VIEW
--SS_DISPLEDG
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_DISPLEDG" 
 ( "APP_NO", "APP_DATE", "LEAVETYPE", "DESCRIPTION", "EMPNO", "LEAVEPERIOD", "DB_CR", "DISPBDATE", "DISPEDATE", "DBDAY", "CRDAY", "ADJ_TYPE", "IS_COVID_SICK_LEAVE"
  )  AS 
  SELECT SS_LEAVELEDG.APP_NO,
    SS_LEAVELEDG.APP_DATE,
    SS_LEAVELEDG.LEAVETYPE,
    SS_LEAVELEDG.DESCRIPTION,
    SS_LEAVELEDG.EMPNO,
    SS_LEAVELEDG.LEAVEPERIOD,
    SS_LEAVELEDG.DB_CR,
    SS_Leaveledg.BDate DispBDate,
    SS_Leaveledg.EDate DispEDate,
    DECODE(SS_LEAVELEDG.DB_CR, 'D', SS_LEAVELEDG.LEAVEPERIOD*-1, NULL) DbDay,
    DECODE(SS_LEAVELEDG.DB_CR, 'C', SS_LEAVELEDG.LEAVEPERIOD, NULL) CrDay,
    SS_LEAVE_ADJ.ADJ_TYPE,
    SS_LEAVELEDG.IS_COVID_SICK_LEAVE
  FROM SS_LEAVE_ADJ,
    SS_LEAVEAPP,
    SS_LEAVELEDG
  WHERE (SS_LEAVELEDG.APP_NO=SS_LEAVE_ADJ.ADJ_NO(+))
  AND (SS_LEAVELEDG.APP_NO  =SS_LEAVEAPP.APP_NO(+))
  AND (SS_LEAVELEDG.EMPNO   =SS_LEAVE_ADJ.EMPNO(+))
  AND (SS_LEAVELEDG.EMPNO   =SS_LEAVEAPP.EMPNO(+));
---------------------------
--New VIEW
--VU_SYSTEM_GRANTS_HEALTH
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."VU_SYSTEM_GRANTS_HEALTH" 
 ( "APPLSYSTEM", "EMPNO", "NAME", "STATUS", "ROLENAMEBYPROJECT", "ROLENAME", "ROLEDESC", "MODULE"
  )  AS 
  select '011' As "APPLSYSTEM", a.empno, b.name, b.status, a.usertype rolenamebyproject,
Case 
    When a.usertype = 'HRD' Then 'Hr User'
End As rolename,
Case 
   When a.usertype = 'HRD' Then 'HR User'
End As roledesc, 'Health Checkup' module
from (select empno, 'HRD' usertype from ss_health_hrduser) a, ss_emplmast b
where a.empno = b.empno;
---------------------------
--Changed VIEW
--SS_VU_ABSENT_TS_LOP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ABSENT_TS_LOP" 
 ( "PERSONID", "EMPNO", "NAME", "PARENT", "ASSIGN", "PAYSLIP_YYYYMM", "ABSENT_YYYYMM", "LOP_DAYS_CSV", "EMP_TOT_LOP", "REVERSE_LOP_DAYS_CSV"
  )  AS 
  select
     b.personid,
     a.empno,
     b.name,
     b.parent,
     b.assign,
     a.payslip_yyyymm,
     a.absent_yyyymm,
     a.lop_days_csv,
     a.emp_tot_lop,
     reverse_lop_days_csv
 from
     (
         select
             empno,
             payslip_yyyymm,
             absent_yyyymm,
             listagg(lop_days,', ') within group(
                 order by
                     lop_4_date
             ) lop_days_csv,
             sum(half_full) emp_tot_lop,
             listagg(reverse_lop_days,', ') within group(
                 order by
                     lop_4_date
             ) reverse_lop_days_csv
         from
             (
                 select
                     aa.empno,
                     aa.lop_4_date,
                     aa.payslip_yyyymm,
                     to_char(aa.lop_4_date,'yyyymm') absent_yyyymm,
                     case aa.half_full
                         when 1   then to_char(aa.lop_4_date,'dd')
                         else '*'
                              || to_char(aa.lop_4_date,'dd')
                     end lop_days,
                     aa.half_full,
                     case nvl(bb.half_full,-1)
                         when 1    then to_char(bb.lop_4_date,'dd')
                         when.5   then '*'
                                     || to_char(bb.lop_4_date,'dd')
                         else null
                     end reverse_lop_days
                 from
                     ss_absent_ts_lop aa,
                     ss_absent_ts_lop_reverse bb
                 where
                     aa.empno = bb.empno (+)
                     and aa.lop_4_date = bb.lop_4_date (+)
             )
         group by
             empno,
             payslip_yyyymm,
             absent_yyyymm
         order by
             empno,
             payslip_yyyymm
     ) a,
     ss_emplmast b
 where
     a.empno = b.empno;
---------------------------
--New VIEW
--SS_EMPTYPEMAST
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_EMPTYPEMAST" 
 ( "EMPTYPE", "EMPDESC", "EMPREMARKS", "TM", "PRINTLOGO", "SORTORDER"
  )  AS 
  select "EMPTYPE","EMPDESC","EMPREMARKS","TM","PRINTLOGO","SORTORDER" from timecurr.emptypemast;
---------------------------
--Changed VIEW
--TCMPL_APP_CONFIG
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."TCMPL_APP_CONFIG" 
 ( ""
  )  AS 
  Select
        ur.module_id,
        m.module_name,
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
    Union
    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        hod  empno,
        Null person_id,
        ra.action_id
    From
        vu_costmast             c,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_hod
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
    Union
    Select
        mr.module_id,
        Null      module_name,
        mr.role_id,
        r.role_desc,
        mngr.mngr empno,
        Null      person_id,
        ra.action_id
    From
        (
            Select
            Distinct mngr
            From
                vu_emplmast
            Where
                status = 1
                And mngr Is Not Null
        )                       mngr,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_mngr_hod
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04';
---------------------------
--Changed VIEW
--SS_VU_ABSENT_LOP_NU
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_ABSENT_LOP_NU" 
 ( "PERSONID", "EMPNO", "NAME", "PARENT", "ASSIGN", "PAYSLIP_YYYYMM", "ABSENT_YYYYMM", "LOP_DAYS_CSV", "EMP_TOT_LOP", "REVERSE_LOP_DAYS_CSV"
  )  AS 
  select
     b.personid,
     a.empno,
     b.name,
     b.parent,
     b.assign,
     a.payslip_yyyymm,
     a.absent_yyyymm,
     a.lop_days_csv,
     a.emp_tot_lop,
     reverse_lop_days_csv
 from
     (
         select
             empno,
             payslip_yyyymm,
             absent_yyyymm,
             listagg(lop_days,', ') within group(
                 order by
                     lop_4_date
             ) lop_days_csv,
             sum(half_full) emp_tot_lop,
             listagg(reverse_lop_days,', ') within group(
                 order by
                     lop_4_date
             ) reverse_lop_days_csv
         from
             (
                 select
                     aa.empno,
                     aa.lop_4_date,
                     aa.payslip_yyyymm,
                     to_char(aa.lop_4_date,'yyyymm') absent_yyyymm,
                     case aa.half_full
                         when 1   then to_char(aa.lop_4_date,'dd')
                         else '*'
                              || to_char(aa.lop_4_date,'dd')
                     end lop_days,
                     aa.half_full,
                     case nvl(bb.half_full,-1)
                         when 1    then to_char(bb.lop_4_date,'dd')
                         when.5   then '*'
                                     || to_char(bb.lop_4_date,'dd')
                         else null
                     end reverse_lop_days
                 from
                     ss_absent_lop aa,
                     ss_absent_lop_reverse bb
                 where
                     aa.empno = bb.empno (+)
                     and aa.lop_4_date = bb.lop_4_date (+)
             )
         group by
             empno,
             payslip_yyyymm,
             absent_yyyymm
         order by
             empno,
             payslip_yyyymm
     ) a,
     ss_emplmast b
 where
     a.empno = b.empno;
---------------------------
--Changed VIEW
--SS_COSTMAST
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_COSTMAST" 
 ( "COSTCODE", "NAME", "ABBR", "HOD", "HOD_ABBR", "DY_HOD", "NOOFEMPS", "COSTGROUP", "GROUPS", "TM01_GRP", "TMA_GRP", "COST_TYPE", "ACTIVITY", "GROUP_CHART", "COSTGRP", "ITALIAN_NAME", "BU", "CHANGED_NEMPS", "INOFFICE", "SECRETARY", "COMP", "ACTIVE", "SDATE", "EDATE", "PHASE", "SAPCC", "CLOSED", "PARENT_COSTCODE"
  )  AS 
  select "COSTCODE","NAME","ABBR","HOD","HOD_ABBR","DY_HOD","NOOFEMPS","COSTGROUP","GROUPS","TM01_GRP","TMA_GRP","COST_TYPE","ACTIVITY","GROUP_CHART","COSTGRP","ITALIAN_NAME","BU","CHANGED_NEMPS","INOFFICE","SECRETARY","COMP","ACTIVE","SDATE","EDATE","PHASE","SAPCC","CLOSED","PARENT_COSTCODE" from commonmasters.costmast;
---------------------------
--New INDEX
--SS_HEALTH_REMIND_ATTACH_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_HEALTH_REMIND_ATTACH_PK" ON "SELFSERVICE"."SS_HEALTH_REMIND_ATTACH" ("ID");
---------------------------
--New INDEX
--SS_ABSENT_TS_DETAIL_INDEX1
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_TS_DETAIL_INDEX1" ON "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ("KEY_ID");
---------------------------
--New INDEX
--SS_ABSENT_PAYSLIP_PERIOD_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD_PK" ON "SELFSERVICE"."SS_ABSENT_PAYSLIP_PERIOD" ("PERIOD");
---------------------------
--New INDEX
--SS_ABSENT_TS_LEAVE_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_TS_LEAVE_PK" ON "SELFSERVICE"."SS_ABSENT_TS_LEAVE" ("EMPNO","TDATE","PROJNO","ACTIVITY","WPCODE");
---------------------------
--New INDEX
--SS_ABSENT_DETAIL_INDEX2
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_DETAIL_INDEX2" ON "SELFSERVICE"."SS_ABSENT_DETAIL" ("KEY_ID");
---------------------------
--New INDEX
--SS_ABSENT_DETAIL_INDEX1
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_DETAIL_INDEX1" ON "SELFSERVICE"."SS_ABSENT_DETAIL" ("KEY_ID","ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_TS_DETAIL_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_TS_DETAIL_PK" ON "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_PRINT_LOG_INDEX4
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_PRINT_LOG_INDEX4" ON "SELFSERVICE"."SS_PRINT_LOG" ("PRINT_DATE","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_TS_DETAIL_INDEX2
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_TS_DETAIL_INDEX2" ON "SELFSERVICE"."SS_ABSENT_TS_DETAIL" ("KEY_ID","ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_DETAIL_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_DETAIL_PK" ON "SELFSERVICE"."SS_ABSENT_DETAIL" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM","EMPNO");
---------------------------
--New INDEX
--SS_ABSENT_LOP_INDEX1
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_LOP_INDEX1" ON "SELFSERVICE"."SS_ABSENT_LOP" ("EMPNO","PAYSLIP_YYYYMM");
---------------------------
--New INDEX
--SS_ABSENT_MASTER_INDEX2
---------------------------
  CREATE INDEX "SELFSERVICE"."SS_ABSENT_MASTER_INDEX2" ON "SELFSERVICE"."SS_ABSENT_MASTER" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM");
---------------------------
--Changed INDEX
--SS_ABSENT_MASTER_INDEX1
---------------------------
DROP INDEX "SELFSERVICE"."SS_ABSENT_MASTER_INDEX1";
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_MASTER_INDEX1" ON "SELFSERVICE"."SS_ABSENT_MASTER" ("KEY_ID");
---------------------------
--New INDEX
--TABLE1_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."TABLE1_PK" ON "SELFSERVICE"."SS_HSESUGG" ("SUGGNO");
