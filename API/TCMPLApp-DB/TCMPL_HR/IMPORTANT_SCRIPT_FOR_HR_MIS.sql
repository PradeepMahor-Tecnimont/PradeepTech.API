drop table mis_prospective_emp cascade constraints purge;
drop table mis_internal_transfers cascade constraints purge;
drop table mis_resigned_emp cascade constraints purge;

Create Table mis_prospective_emp(
key_id Char(8),
costcode Char(4),
emp_name Varchar2(100),
office_code Char(2), 
proposed_doj Date,
revised_doj Date,
join_status_code Char(2),
empno Char(5)
);

Create Table mis_internal_transfers(
key_id Char(8),
empno Char(5),
transfer_date Date,
from_costcode Char(4),
to_costcode Char(4)
);

Create Table mis_resigned_emp(
key_id Char(8),
empno Char(5),
emp_resign_date Date,
hr_receipt_date Date,
date_of_relieving Date,
emp_resign_reason Varchar2(200),
resign_reason_type Char(2),-- (Lov)
additional_feedback  Varchar2(200),
exit_interview_complete Char(2),-- (OK / KO) 
percent_increase Number(3),
resign_status_code Char(2),
commitment_on_rollback Varchar2(200),
actual_last_date_in_office Date
);

create table mis_mast_office_location(
office_code char(2),
office_desc varchar2(100)
);

create table mis_mast_joining_status(
join_status_code char(2),
join_status_desc varchar2(100)
);

create table mis_mast_resign_reason_types(
resign_reason_type char(2),
resign_reason_desc varchar2(100)
);

create table mis_mast_resign_status(
resign_status_code char(2),
resign_status_desc varchar2(100)
);



alter table mis_internal_transfers add(modified_by varchar2(5), modified_on date);
alter table mis_prospective_emp add(modified_by varchar2(5), modified_on date);
alter table mis_resigned_emp add(modified_by varchar2(5), modified_on date);

/*
--By Pradeep Mahor

-- Table MIS_EMPLOYMENT_TYPE Data
INSERT INTO "TCMPL_HR"."MIS_EMPLOYMENT_TYPE" (KEY_ID, EMPLOYMENT_TYPE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0001', 'Permanent', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_EMPLOYMENT_TYPE" (KEY_ID, EMPLOYMENT_TYPE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0002', 'Fixed term Contract', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_EMPLOYMENT_TYPE" (KEY_ID, EMPLOYMENT_TYPE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0003', 'Third Party Contract', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_EMPLOYMENT_TYPE" (KEY_ID, EMPLOYMENT_TYPE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0004', 'Consultant', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_EMPLOYMENT_TYPE" (KEY_ID, EMPLOYMENT_TYPE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0005', 'Trainee', '1', '04170', Sysdate);

-- Table MIS_SOURCES_OF_CANDIDATE Data
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0001', 'Ex- TCMPL', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0002', 'ASHITA BUSINESS SOLUTIONS', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0003', 'Brainstorming Consultancy', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0004', 'Carrer vision', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0005', 'Covenant Consultant', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0006', 'Executive Placement', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0007', 'Green Globe', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0008', 'Krishna Global Services Pvt.Ltd.', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0009', 'Regalia HR Services', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0010', 'SARAARO HR Consultancy', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0011', 'TRS Staffing Solutions India Pvt.Ltd.', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0012', 'PROCON INDIA Consultancy', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0013', 'Winner HR Consultant', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0014', 'Techmas Technical Services', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0015', 'ANI INTEGRATED SERVICES', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0016', 'Elshaddaihr Consultancy', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0017', 'Michael Page', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0018', 'SAP Brothers', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0019', 'O & G SKILLS INDIA Pvt.Ltd.', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0020', 'Naukri. Com', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0021', 'Linkedln', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0022', 'Employee Referral ( Employee Number)', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_SOURCES_OF_CANDIDATE" (KEY_ID, SOURCES_OF_CANDIDATE, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0023', 'Conversion', '1', '04170', Sysdate);

INSERT INTO "TCMPL_HR"."MIS_PRE_EMP_MEDICAL_TEST" (KEY_ID, PRE_MEDICAL_TEST, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0001', 'Fit', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_PRE_EMP_MEDICAL_TEST" (KEY_ID, PRE_MEDICAL_TEST, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0002', 'Unfit', '1', '04170', Sysdate);
INSERT INTO "TCMPL_HR"."MIS_PRE_EMP_MEDICAL_TEST" (KEY_ID, PRE_MEDICAL_TEST, IS_ACTIVE, MODIFIED_BY, MODIFIED_ON) VALUES ('A0003', 'Under Medication', '1', '04170', Sysdate);

-- Alter Table mis_prospective_emp Data
Alter  Table mis_prospective_emp Add (grade Varchar2(5));
Alter  Table mis_prospective_emp Add (designation Varchar2(10));
Alter  Table mis_prospective_emp Add (employment_type Varchar2(5));
Alter  Table mis_prospective_emp Add (sources_of_candidate Varchar2(5));


Alter  Table mis_prospective_emp Add (pre_emplmnt_medcl_test Varchar2(5));
Alter  Table mis_prospective_emp Add (medcl_request_date Date);
Alter  Table mis_prospective_emp Add (actual_appt_date Date);
Alter  Table mis_prospective_emp Add (medcl_fitness_cert Date);
Alter  Table mis_prospective_emp Add (re_pre_emplmnt_medcl_test Varchar2(150));


Alter  Table mis_prospective_emp Add (rec_for_appt Varchar2(2));
Alter  Table mis_prospective_emp Add (rec_issued Date);
Alter  Table mis_prospective_emp Add (rec_received Date);

Alter  Table mis_prospective_emp Add (re_rec_appt Varchar2(150));

Alter  Table mis_prospective_emp Add (offer_letter Varchar2(2));

*/



