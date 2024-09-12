--------------------------------------------------------
--  File created - Sunday-January-02-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--DM_EMP_DESK_MAP
---------------------------
  CREATE TABLE "DMS"."DM_EMP_DESK_MAP" 
   (	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"DESKID" VARCHAR2(7) NOT NULL ENABLE,
	"MODIFIED_ON" DATE,
	"MODIFIED_BY" VARCHAR2(5)
   );
---------------------------
--New TABLE
--DM_ASSET_HOME_REQUEST
---------------------------
  CREATE TABLE "DMS"."DM_ASSET_HOME_REQUEST" 
   (	"UNQID" VARCHAR2(20) NOT NULL ENABLE,
	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"DESKID" VARCHAR2(7) NOT NULL ENABLE,
	"ASSETID" VARCHAR2(20) NOT NULL ENABLE,
	"CREATEDON" DATE,
	"CREATEDBY" CHAR(5),
	"CONFIRMED" NUMBER(1,0) DEFAULT 0,
	"CONFIRMON" DATE,
	"CONFIRMBY" CHAR(5),
	CONSTRAINT "DM_ASSET_HOME_REQUEST_PK" PRIMARY KEY ("UNQID","ASSETID") ENABLE
   );
  COMMENT ON COLUMN "DMS"."DM_ASSET_HOME_REQUEST"."CONFIRMED" IS '1 is confirmed';
---------------------------
--New TABLE
--DM_ORPHAN_ASSET
---------------------------
  CREATE TABLE "DMS"."DM_ORPHAN_ASSET" 
   (	"UNQID" VARCHAR2(20),
	"EMPNO" CHAR(5),
	"DESKID" VARCHAR2(7),
	"ASSETID" VARCHAR2(20),
	"CREATEDON" DATE,
	"CREATEDBY" CHAR(5),
	"CONFIRMED" NUMBER(1,0) DEFAULT 0,
	"CONFIRMON" DATE,
	"CONFIRMBY" CHAR(5)
   );
---------------------------
--New TABLE
--DM_EMP_DM_TYPE_MAP
---------------------------
  CREATE TABLE "DMS"."DM_EMP_DM_TYPE_MAP" 
   (	"EMPNO" CHAR(5) NOT NULL ENABLE,
	"EMP_DM_TYPE" NUMBER(1,0),
	CONSTRAINT "DM_EMP_DM_TYPE_MAP_PK" PRIMARY KEY ("EMPNO") ENABLE
   );
---------------------------
--Changed TABLE
--DM_DESKMASTER
---------------------------
ALTER TABLE "DMS"."DM_DESKMASTER" ADD ("BAY" VARCHAR2(20));
ALTER TABLE "DMS"."DM_DESKMASTER" ADD ("WORK_AREA" CHAR(3));

---------------------------
--New TABLE
--DM_DESK_AREAS
---------------------------
  CREATE TABLE "DMS"."DM_DESK_AREAS" 
   (	"AREA_KEY_ID" CHAR(3) NOT NULL ENABLE,
	"AREA_DESC" VARCHAR2(60),
	"AREA_CATG_CODE" CHAR(4),
	"AREA_INFO" VARCHAR2(20),
	CONSTRAINT "DM_DESK_AREA_MASTER_PK" PRIMARY KEY ("AREA_KEY_ID") ENABLE,
	CONSTRAINT "DM_DESK_AREAS_FK1" FOREIGN KEY ("AREA_CATG_CODE")
	 REFERENCES "DMS"."DM_DESK_AREA_CATEGORIES" ("AREA_CATG_CODE") ENABLE
   );
---------------------------
--New TABLE
--DM_DESK_AREA_CATEGORIES
---------------------------
  CREATE TABLE "DMS"."DM_DESK_AREA_CATEGORIES" 
   (	"AREA_CATG_CODE" CHAR(4) NOT NULL ENABLE,
	"DESCRIPTION" VARCHAR2(100),
	CONSTRAINT "DM_DESK_AREA_CATEGORIES_PK" PRIMARY KEY ("AREA_CATG_CODE") ENABLE
   );
---------------------------
--New TABLE
--DM_EMP_DM_TYPES
---------------------------
  CREATE TABLE "DMS"."DM_EMP_DM_TYPES" 
   (	"DM_TYPE_CODE" NUMBER(1,0),
	"DM_TYPE_DESC" VARCHAR2(100)
   );
---------------------------
--New VIEW
--DM_VU_EMP_DESK_MAP
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_VU_EMP_DESK_MAP" 
 ( "EMPNO", "DESKID", "MODIFIED_ON", "MODIFIED_BY"
  )  AS 
  SELECT 
    "EMPNO","DESKID","MODIFIED_ON","MODIFIED_BY"
FROM 
    
dm_emp_desk_map;
---------------------------
--New VIEW
--DM_VU_EMP_DM_TYPE_MAP
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_VU_EMP_DM_TYPE_MAP" 
 ( "EMPNO", "EMP_DM_TYPE", "DM_TYPE_DESC"
  )  AS 
  Select
    dtm.empno, dtm.emp_dm_type, dt.dm_type_desc
From
    dm_emp_dm_type_map dtm,
    dm_emp_dm_types    dt
Where
    dt.dm_type_code = dtm.emp_dm_type;
---------------------------
--New VIEW
--DM_VU_DESK_AREAS
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_VU_DESK_AREAS" 
 ( "AREA_KEY_ID", "AREA_DESC", "IS_SHARED_AREA"
  )  AS 
  SELECT 
    "AREA_KEY_ID","AREA_DESC","IS_SHARED_AREA"
FROM 
    
dm_desk_areas;
---------------------------
--New INDEX
--DM_EMP_DESK_MAP_INDEX2
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_EMP_DESK_MAP_INDEX2" ON "DMS"."DM_EMP_DESK_MAP" ("DESKID");
---------------------------
--New INDEX
--DM_EMP_DESK_MAP_INDEX1
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_EMP_DESK_MAP_INDEX1" ON "DMS"."DM_EMP_DESK_MAP" ("EMPNO");
---------------------------
--New INDEX
--DM_DESKALLOCATION_INDEX4
---------------------------
  CREATE INDEX "DMS"."DM_DESKALLOCATION_INDEX4" ON "DMS"."DM_DESKALLOCATION" ("ASSETID");
---------------------------
--New INDEX
--DM_EMP_DM_TYPE_MAP_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_EMP_DM_TYPE_MAP_PK" ON "DMS"."DM_EMP_DM_TYPE_MAP" ("EMPNO");
---------------------------
--New INDEX
--DM_DESK_AREA_CATEGORIES_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_DESK_AREA_CATEGORIES_PK" ON "DMS"."DM_DESK_AREA_CATEGORIES" ("AREA_CATG_CODE");
---------------------------
--New INDEX
--DM_DESKALLOCATION_INDEX3
---------------------------
  CREATE INDEX "DMS"."DM_DESKALLOCATION_INDEX3" ON "DMS"."DM_DESKALLOCATION" ("DESKID","ASSETID");
---------------------------
--New INDEX
--DM_ASSET_HOME_REQUEST_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_ASSET_HOME_REQUEST_PK" ON "DMS"."DM_ASSET_HOME_REQUEST" ("UNQID","ASSETID");
---------------------------
--New INDEX
--DM_DESK_AREA_MASTER_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_DESK_AREA_MASTER_PK" ON "DMS"."DM_DESK_AREAS" ("AREA_KEY_ID");
---------------------------
--New PACKAGE
--IOT_DMS_SS_QRY
---------------------------
CREATE OR REPLACE PACKAGE "DMS"."IOT_DMS_SS_QRY" As

   Function is_asset_2_home_confirmed(
      p_empno  Varchar2,
      p_deskid Varchar2
   ) Return Number;

   Function get_desk_asset_details(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_empno       Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function is_asset_in_tbl(
      p_assetid Varchar2
   ) Return Number;

End IOT_DMS_SS_QRY;
/
---------------------------
--New PACKAGE
--IOT_DMS_SS
---------------------------
CREATE OR REPLACE PACKAGE "DMS"."IOT_DMS_SS" As

   Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;


   Procedure sp_add_asset_to_home(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_asset_to_home_array    typ_tab_string,
      p_empno            Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

End IOT_DMS_SS;
/
---------------------------
--New PACKAGE BODY
--IOT_DMS_SS_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "DMS"."IOT_DMS_SS_QRY" As

   Function is_asset_2_home_confirmed(
      p_empno  Varchar2,
      p_deskid Varchar2
   ) Return Number As
      v_confirm Number;
   Begin

      Select Distinct dahr.confirmed Into v_confirm
        From dm_asset_home_request dahr
       Where dahr.deskid = p_deskid
         And dahr.empno = p_empno;
      Return nvl(v_confirm, 0);

   End is_asset_2_home_confirmed;

   Function get_desk_asset_details(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_empno       Varchar2,

      p_row_number  Number,
      p_page_length Number

   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      /*
      v_empno := SelfService.get_empno_from_meta_id(p_meta_id);
           If v_empno = 'ERRRR' Then
               Raise e_employee_not_found;
               Return Null;
           End If;

      */

      Open c For
         Select *
           From (
                   Select du.empno As empno,
                          du.deskid As deskid,
                          dda.assetid As assetid,
                          da.assettype As asset_type,
                          da.model As description,
                          IOT_DMS_SS_QRY.is_asset_in_tbl(dda.assetid) As istaking2home,
                          iot_dms_ss_qry.is_asset_2_home_confirmed(du.empno, du.deskid) requestconfirm,
                          Row_Number() Over (Order By du.deskid Desc) As row_number,
                          Count(*) Over () As total_row
                     From dm_usermaster du,
                          dm_deskallocation dda,
                          dm_assetcode da
                    Where du.deskid = dda.deskid
                      And Trim(dda.assetid) = Trim(da.barcode)
                      And du.empno = p_empno
                    Order By decode(da.assettype, 'PC', 1, 'NB', 2, 'MO', 3, 'IP', 4, 'PR', 5) Asc
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      Return c;
   End get_desk_asset_details;

   Function is_asset_in_tbl(
      p_assetid Varchar2
   ) Return Number As
      v_retval Number := 0;
      v_count  Number := 0;
   Begin

      Select Count(*) Into v_count
        From dm_asset_home_request a
       Where a.assetid = p_assetid;

      If v_count = 0 Then 

         Select Count(*) Into v_count
           From DM_ORPHAN_ASSET a
          Where a.assetid = p_assetid;

      Else

         v_retval := 1;
         Return nvl(v_retval, 0);

      End If;

      If v_count = 0 Then
         v_retval := 0;
          Return nvl(v_retval, 0);
      Else
         v_retval := 2;
          Return nvl(v_retval, 0);
      End If;

      Return nvl(v_retval, 0);

   End is_asset_in_tbl;

End IOT_DMS_SS_QRY;
/
---------------------------
--New PACKAGE BODY
--IOT_DMS_SS
---------------------------
CREATE OR REPLACE PACKAGE BODY "DMS"."IOT_DMS_SS" As

   Procedure sp_add_asset_to_home(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_asset_to_home_array    typ_tab_string,
      p_empno            Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      strsql         Varchar2(600);
      v_mod_by_empno Varchar2(5);
      v_count        Number;
      v_status       Varchar2(5);
      v_pk           Varchar2(20);
      v_empno        Varchar2(5);
      v_assetid      Varchar2(20);
      v_desk         Varchar2(7);
   Begin

      /*
          v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

      */

      For i In 1..p_asset_to_home_array.count
      Loop

         With
            csv As (
               Select p_asset_to_home_array(i) str
                 From dual
            )
         Select Trim(regexp_substr(str, '[^~!~]+', 1, 1)) assetid,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3)) status
           Into v_assetid, v_desk, v_status
           From csv;

         v_pk := dbms_random.string('X', 20);


            Delete from dm_asset_home_request where empno = p_empno and assetid = v_assetid ;

            Delete from DM_ORPHAN_ASSET where empno = p_empno and assetid = v_assetid ;

         If v_status = 'true' Then

            Insert Into dm_asset_home_request
               (unqid, empno, deskid, assetid, createdon, createdby, confirmed, confirmon, confirmby)
            Values
               (v_pk, p_empno, v_desk, v_assetid, sysdate, p_empno, 0, Null, Null); 

         End If;

         If v_status = 'false' Then

            Insert Into DM_ORPHAN_ASSET
               (unqid, empno, deskid, assetid, createdon, createdby, confirmed, confirmon, confirmby)
            Values
               (v_pk, p_empno, v_desk, v_assetid, sysdate, p_empno, 0, Null, Null);

            Null; 
         End If;

      End Loop;
      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_asset_to_home;

End IOT_DMS_SS;
/
