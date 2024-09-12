--------------------------------------------------------
--  File created - Thursday-March-17-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--DM_USERMASTER_SNAPSHOT
---------------------------
  CREATE TABLE "DMS"."DM_USERMASTER_SNAPSHOT" 
   (	"SNAPSHOT_DATE" DATE,
	"EMPNO" CHAR(5),
	"DESKID" VARCHAR2(7),
	"COSTCODE" CHAR(4),
	"DEP_FLAG" NUMBER(1,0)
   );
---------------------------
--New TABLE
--DM_DESKLOCK_SNAPSHOT
---------------------------
  CREATE TABLE "DMS"."DM_DESKLOCK_SNAPSHOT" 
   (	"SNAPSHOT_DATE" DATE,
	"UNQID" VARCHAR2(20),
	"EMPNO" CHAR(5),
	"DESKID" VARCHAR2(7),
	"TARGETDESK" NUMBER(1,0),
	"BLOCKFLAG" NUMBER(1,0),
	"BLOCKREASON" NUMBER(2,0)
   );
---------------------------
--New TABLE
--DM_DESKALLOCATION_SNAPSHOT
---------------------------
  CREATE TABLE "DMS"."DM_DESKALLOCATION_SNAPSHOT" 
   (	"SNAPSHOT_DATE" DATE,
	"DESKID" VARCHAR2(7),
	"ASSETID" VARCHAR2(20)
   );
---------------------------
--New TABLE
--DM_USERMASTER_SWP_PLAN
---------------------------
  CREATE TABLE "DMS"."DM_USERMASTER_SWP_PLAN" 
   (	"FK_WEEK_KEY_ID" VARCHAR2(8),
	"EMPNO" CHAR(5),
	"DESKID" VARCHAR2(7),
	"COSTCODE" CHAR(4),
	"DEP_FLAG" NUMBER(1,0)
   );
---------------------------
--New TABLE
--DM_DESKLOCK_SWP_PLAN
---------------------------
  CREATE TABLE "DMS"."DM_DESKLOCK_SWP_PLAN" 
   (	"FK_WEEK_KEY_ID" VARCHAR2(8),
	"UNQID" VARCHAR2(20),
	"EMPNO" CHAR(5),
	"DESKID" VARCHAR2(7),
	"TARGETDESK" NUMBER(1,0),
	"BLOCKFLAG" NUMBER(1,0),
	"BLOCKREASON" NUMBER(2,0)
   );
---------------------------
--New TABLE
--DM_DESK_BAYS
---------------------------
  CREATE TABLE "DMS"."DM_DESK_BAYS" 
   (	"BAY_KEY_ID" CHAR(4) NOT NULL ENABLE,
	"BAY_DESC" VARCHAR2(20),
	CONSTRAINT "DM_DESK_BAYS_PK" PRIMARY KEY ("BAY_KEY_ID") ENABLE
   );
---------------------------
--New TABLE
--DM_SUB_ASSETTYPE
---------------------------
  CREATE TABLE "DMS"."DM_SUB_ASSETTYPE" 
   (	"SUB_ASSET_TYPE" VARCHAR2(5) NOT NULL ENABLE,
	"DESCRIPTION" VARCHAR2(60),
	"SORT_ORDER" NUMBER(2,0),
	CONSTRAINT "DM_SUB_ASSETTYPE_PK" PRIMARY KEY ("SUB_ASSET_TYPE") ENABLE
   );
---------------------------
--Changed TABLE
--DM_DESKMASTER
---------------------------
ALTER TABLE "DMS"."DM_DESKMASTER" ADD CONSTRAINT "DM_DESKMASTER_PK" PRIMARY KEY ("DESKID") ENABLE;

---------------------------
--New TABLE
--DM_DESKALLOCATION_SWP_PLAN
---------------------------
  CREATE TABLE "DMS"."DM_DESKALLOCATION_SWP_PLAN" 
   (	"FK_WEEK_KEY_ID" VARCHAR2(8),
	"DESKID" VARCHAR2(7),
	"ASSETID" VARCHAR2(20)
   );
---------------------------
--New VIEW
--DM_VU_DESK_LOCK_SWP_PLAN
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_VU_DESK_LOCK_SWP_PLAN" 
 ( "UNQID", "EMPNO", "DESKID", "TARGETDESK", "BLOCKFLAG", "BLOCKREASON", "REASON_DESC"
  )  AS 
  Select
    dl."UNQID",dl."EMPNO",dl."DESKID",dl."TARGETDESK",dl."BLOCKFLAG",dl."BLOCKREASON", dlr.description reason_desc
From
    dm_desklock_swp_plan        dl,
    dm_desklock_reason dlr
Where
    dl.blockreason = dlr.reasoncode;
---------------------------
--Changed VIEW
--DM_ASSETCODE
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_ASSETCODE" 
 ( "BARCODE", "PONUM", "PODATE", "GRNUM", "INVOICENUM", "INVOICE_DATE", "ASSETTYPE", "PRINTFLAG", "SERIALNUM", "MODEL", "COMPNAME", "WARRANTY_END", "SAP_ASSETCODE", "SCRAP", "SCRAP_DATE", "OUT_OF_SERVICE", "OUTOFSERVICE_TYPE", "TO_BE_SCRAP", "BARCODE_OLD", "SUB_ASSET_TYPE"
  )  AS 
  SELECT
    b.barcode,
    a.sap_po_no ponum,
    a.sap_po_date podate,
    a.gr_id grnum,
    a.vend_inv_num invoicenum,
    a.vend_inv_date invoice_date,
    case when substr(TRIM(b.barcode),6,2) = 'TL' then
      'IP' else substr(TRIM(b.barcode),6,2)
      end assettype,
    a.bar_code_printed printflag,
    a.mfg_sr_no serialnum,
    a.asset_model model,
    Case when a.sub_asset_type = 'IT0PC' Then
      a.asset_name
    when a.sub_asset_type = 'IT0NB' Then
      a.asset_name      
    Else
      Null
      End compname,
    a.warranty_end_date warranty_end,
    a.sap_asset_code sap_assetcode,
    (
        SELECT
            COUNT(a.disposal_date)
        FROM
            ams.as_disposal_mast a,
            ams.as_disposal_detail b
        WHERE
            a.disposal_id = b.disposal_id
        AND
            b.ams_asset_id = TRIM(a.ams_asset_id)
    ) scrap,
    (
        SELECT
            a.disposal_date
        FROM
            ams.as_disposal_mast a,
            ams.as_disposal_detail b
        WHERE
            a.disposal_id = b.disposal_id
        AND
            b.ams_asset_id = TRIM(a.ams_asset_id)
    ) scrap_date,
    b.out_of_service,
    b.outofservice_type,
    b.to_be_scrap,
    B.Barcode_Old,
    a.sub_asset_type
FROM
    ams.as_asset_mast a,
    ams.dm_asset_mast b
WHERE
    Trim(A.Ams_Asset_Id) = Trim(B.Barcode)
ORDER BY b.barcode;
---------------------------
--Changed VIEW
--DM_VU_DESK_LIST
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_VU_DESK_LIST" 
 ( "DESKID", "OFFICE", "FLOOR", "SEATNO", "WING", "ASSETCODE", "NOEXIST", "CABIN", "REMARKS", "DESKID_OLD", "WORK_AREA", "BAY"
  )  AS 
  SELECT "DESKID","OFFICE","FLOOR","SEATNO","WING","ASSETCODE","NOEXIST","CABIN","REMARKS","DESKID_OLD","WORK_AREA","BAY"
    
FROM 
    
dm_deskmaster;
---------------------------
--New VIEW
--DM_VU_EMP_DESK_MAP_SWP_PLAN
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_VU_EMP_DESK_MAP_SWP_PLAN" 
 ( "EMPNO", "DESKID"
  )  AS 
  SELECT 
    "EMPNO","DESKID"
FROM 
    
dm_usermaster_swp_plan where deskid not like 'H%';
---------------------------
--Changed VIEW
--DM_VU_DESK_AREAS
---------------------------
CREATE OR REPLACE FORCE VIEW "DMS"."DM_VU_DESK_AREAS" 
 ( "AREA_KEY_ID", "AREA_DESC", "AREA_CATG_CODE", "AREA_INFO"
  )  AS 
  SELECT 
    "AREA_KEY_ID","AREA_DESC","AREA_CATG_CODE","AREA_INFO"
FROM 
    
dm_desk_areas;
---------------------------
--New INDEX
--DM_SUB_ASSETTYPE_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_SUB_ASSETTYPE_PK" ON "DMS"."DM_SUB_ASSETTYPE" ("SUB_ASSET_TYPE");
---------------------------
--New INDEX
--DM_DESKMASTER_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_DESKMASTER_PK" ON "DMS"."DM_DESKMASTER" ("DESKID");
---------------------------
--New INDEX
--DM_DESK_BAYS_PK
---------------------------
  CREATE UNIQUE INDEX "DMS"."DM_DESK_BAYS_PK" ON "DMS"."DM_DESK_BAYS" ("BAY_KEY_ID");
---------------------------
--Changed PACKAGE
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

   function is_request_exists(
      p_deskid      Varchar2,
      p_empno       Varchar2
   ) Return varchar2;

   /* Get oraphan assets request list */
   function get_orphan_request_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   function get_orphan_request_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   /* Get 2home assets request list */
   function get_2home_request_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   function get_2home_request_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

    /* Get 2home gatepass list */
   function get_2home_gatepass_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;
   
   function get_2home_gatepass_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;
End IOT_DMS_SS_QRY;
/
---------------------------
--Changed PACKAGE
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

   Procedure sp_discard_asset_to_home(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_unqid            Varchar2,
      p_empno            Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   procedure sp_update_orphan_asset(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_asset_to_home_array      typ_tab_string,      

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   procedure sp_update_asset_2home(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_asset_to_home_array      typ_tab_string,      

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

End IOT_DMS_SS;
/
---------------------------
--New PACKAGE
--IOT_DMS_QRY
---------------------------
CREATE OR REPLACE PACKAGE "DMS"."IOT_DMS_QRY" As
   
   /* DESK MASETR */

   Function deskmaster_list_count
      Return Number;

   Function deskmaster_list( 
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function deskmaster_detail(
      p_deskid      Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function bay_list
        Return Sys_Refcursor;

   Function workarea_list
        Return Sys_Refcursor;

End IOT_DMS_QRY;
/
---------------------------
--New PACKAGE
--IOT_DMS
---------------------------
CREATE OR REPLACE PACKAGE "DMS"."IOT_DMS" As
   
   /* DESK MASETR */   

   Procedure sp_add_desk( 
        p_deskid           Varchar2,        
        p_office           Varchar2,
        p_floor            Varchar2,
        p_seatno           Varchar2,
        p_wing             Varchar2,
        p_assetcode        Varchar2, 
        p_noexists         Varchar2,
        p_cabin            Varchar2,
        p_remarks          Varchar2,
        p_bay              Varchar2,
        p_workarea         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
   ) ;

   Procedure sp_edit_desk(
        p_deskid           Varchar2,
        p_noexists         Varchar2,
        p_cabin            Varchar2,
        p_remarks          Varchar2,
        p_bay              Varchar2,
        p_workarea         Varchar2,      

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
   ) ;

End IOT_DMS;
/
---------------------------
--New PACKAGE BODY
--IOT_DMS_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "DMS"."IOT_DMS_QRY" As
   
   /* DESK MASETR */

   Function deskmaster_list_count
      Return Number as     
        v_count   number;
      Begin
        Select 
            count(*) into v_count 
        From 
            dm_deskmaster 
        Where 
            deskid not like 'H%';        
        return nvl(v_count, 0);    
    End deskmaster_list_count;

   Function deskmaster_list( 
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c        Sys_Refcursor;     
     Begin
       Open c For
        select 
            *
        from 
            dm_deskmaster
        where 
            deskid not like 'H%'
        order by 
            deskid;
       Return c;     
   End deskmaster_list;

   Function deskmaster_detail(
      p_deskid      Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
     c        Sys_Refcursor;     
     Begin
       Open c For
        select 
            *
        from 
            dm_deskmaster
        where 
            deskid not like 'H%'
        order by 
            deskid;
       Return c;
    End deskmaster_detail;

    Function bay_list
        Return Sys_Refcursor As
        c     Sys_Refcursor;       
      Begin        
        Open c For
            Select
                bay_key_id As data_value_field,
                bay_desc As data_text_field
            From
                dm_desk_bays           
            Order By
                bay_desc;
        Return c;
    End bay_list;

    Function workarea_list
        Return Sys_Refcursor As
        c     Sys_Refcursor;       
      Begin        
        Open c For
            Select
                area_key_id As data_value_field,
                area_desc As data_text_field
            From
                dm_desk_areas           
            Order By
                area_desc;
        Return c;
    End workarea_list;

End IOT_DMS_QRY;
/
---------------------------
--Changed PACKAGE BODY
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
      strsql            varchar2(1000);
      v_mod_by_empno    varchar2(5);
      v_count           number;
      v_status          varchar2(5);
      v_pk              varchar2(20);
      v_empno           varchar2(5);
      v_assetid         varchar2(20);
      v_desk            varchar2(7);
   Begin

      /*
          v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

      */
      v_pk := dbms_random.string('X', 20);

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


        delete from dm_asset_home_request where empno = p_empno and assetid = v_assetid;             
        delete from dm_orphan_asset where empno = p_empno and assetid = v_assetid;               
         If v_status = 'true' Then            
            Insert Into dm_asset_home_request
               (unqid, empno, deskid, assetid, createdon, createdby, confirmed, confirmon, confirmby)
            Values
               (v_pk, p_empno, v_desk, v_assetid, sysdate, p_empno, 0, null, null);                
         End If;

         If v_status = 'false' Then              
            Insert Into dm_orphan_asset
               (unqid, empno, deskid, assetid, createdon, createdby, confirmed, confirmon, confirmby)
            Values
               (v_pk, p_empno, v_desk, v_assetid, sysdate, p_empno, 0, null, null);            
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

    Procedure sp_discard_asset_to_home(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_unqid            Varchar2,
      p_empno            Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As      
      v_cnt_home         Number;
      v_cnt_orphan       Number;       
   Begin
      select 
        count(*) into v_cnt_home 
      from 
        dm_asset_home_request dahr 
      where 
          dahr.unqid = p_unqid and
          dahr.empno = p_empno and
          dahr.confirmed = 1;

      select 
        count(*) into v_cnt_orphan 
      from 
          dm_orphan_asset doa 
      where 
          doa.unqid = p_unqid and
          doa.empno = p_empno and
          doa.confirmed = 1;

        If v_cnt_home = 0 and v_cnt_orphan = 0 then
            delete from 
                dm_asset_home_request 
            where 
                unqid = p_unqid and
                empno = p_empno;

            delete from 
                dm_orphan_asset 
            where 
                unqid = p_unqid and
                empno = p_empno;
            p_message_type := 'OK';
            p_message_text := 'Request deleted successfully.';        
        Else
            p_message_type := 'KO';
            p_message_text := 'Partially approved can not be deleted.';
        End If;
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_discard_asset_to_home;

    procedure sp_update_orphan_asset(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_asset_to_home_array      typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_mod_by_empno    varchar2(5); 
        v_unqid           varchar2(20);
        v_assetid         varchar2(20);
        v_status          varchar2(5);         
    Begin    
        /*v_mod_by_empno := selfservice.get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        For i In 1..p_asset_to_home_array.count
        Loop
            With csv As (
                Select p_asset_to_home_array(i) str
                From dual
            )
            Select Trim(regexp_substr(str, '[^~!~]+', 1, 1)) unqid,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) assetid,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3)) status
                Into v_unqid, v_assetid, v_status
            From csv;

            If v_status = 'true' Then         
                update dm_orphan_asset
                set confirmed = 1,
                    confirmby = v_mod_by_empno,
                    confirmon = sysdate
                where unqid = v_unqid and 
                    trim(assetid) = trim(v_assetid);
              End If;    

        End Loop;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Request executed successfully';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                            || sqlcode
                            || ' - '
                            || sqlerrm;
    End sp_update_orphan_asset;

    procedure sp_update_asset_2home(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_asset_to_home_array      typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_mod_by_empno    varchar2(5); 
        v_unqid           varchar2(20);
        v_assetid         varchar2(20);
        v_status          varchar2(5);
        v_homedesk        varchar2(7);
    Begin    
        /*v_mod_by_empno := selfservice.get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;*/

        For i In 1..p_asset_to_home_array.count
        Loop
            With csv As (
                Select p_asset_to_home_array(i) str
                From dual
            )
            Select Trim(regexp_substr(str, '[^~!~]+', 1, 1)) unqid,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) assetid,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3)) status
                Into v_unqid, v_assetid, v_status
            From csv;

            If v_status = 'true' Then         
                update dm_asset_home_request
                set confirmed = 1,
                    confirmby = v_mod_by_empno,
                    confirmon = sysdate
                where unqid = v_unqid and 
                    trim(assetid) = trim(v_assetid); 

                select 
                    distinct 'H'||empno into v_homedesk
                from 
                    dm_asset_home_request 
                where 
                    unqid = v_unqid;

                Insert Into dm_deskallocation
                   (deskid, assetid)
                Values
                   (v_homedesk, trim(v_assetid)); 
            End If;
        End Loop;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Request executed successfully';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                            || sqlcode
                            || ' - '
                            || sqlerrm;
    End sp_update_asset_2home;

End IOT_DMS_SS;
/
---------------------------
--Changed PACKAGE BODY
--IOT_DMS_SS_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "DMS"."IOT_DMS_SS_QRY" As

    Function is_asset_2_home_confirmed(
        p_empno     varchar2,
        p_deskid    varchar2
      ) Return number as
        v_confirm   number;
      Begin
        select 
            distinct dahr.confirmed into v_confirm
        from 
            dm_asset_home_request dahr
        where 
            dahr.deskid = p_deskid and 
            dahr.empno = p_empno;
        return nvl(v_confirm, 0);    
    End is_asset_2_home_confirmed;
    
    Function is_asset_in_tbl(
        p_assetid Varchar2
      ) Return Number As
        v_retval Number := 0;
        v_count  Number := 0;
      Begin

      Select 
        Count(*) Into v_count
      From 
        dm_asset_home_request a
      Where 
        a.assetid = p_assetid;
    
      If v_count != 0 Then 
        v_retval := 1;       
        Return nvl(v_retval, 0);         
      End If;
    
      /*Select Count(*) Into v_count
      From dm_orphan_asset a
      Where a.assetid = p_assetid;
    
      If v_count != 0 Then 
      v_retval := 2;       
      Return nvl(v_retval, 0);         
      End If;*/
    
      Return nvl(v_retval, 0);
   End is_asset_in_tbl;
   
   function is_request_exists(
      p_deskid      Varchar2,
      p_empno       Varchar2
   ) Return Varchar2
   As
      v_unqid   varchar2(20);
   Begin
    Select distinct unqid into v_unqid
    from
        (Select 
            distinct a.unqid 
        From 
            dm_asset_home_request a
        Where 
            a.deskid = p_deskid and
            a.empno = p_empno
        union all
        Select 
            distinct b.unqid 
        From 
            dm_orphan_asset b
        Where 
            b.deskid = p_deskid and
            b.empno = p_empno);
       return v_unqid;
   End is_request_exists;
   
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
         Select iot_dms_ss_qry.is_request_exists(deskid, empno) unqid,
                          empno,
                          deskid,
                          assetid,
                          asset_type,
                          description,
                          istaking2home,
                          requestconfirm,
                          row_number,                          
                          total_row,
                          sum(istaking2home) Over () As home_count
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
                          dm_assetcode da,
                          dm_sub_assettype dsa
                    Where du.deskid = dda.deskid
                      And Trim(dda.assetid) = Trim(da.barcode)
                      And da.sub_asset_type = dsa.sub_asset_type
                      And du.empno = p_empno
                    Order by dsa.sort_order asc
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      Return c;
   End get_desk_asset_details;

   /* Get oraphan assets request list */
   function get_orphan_request_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor; 
   Begin
      Open c for
      select * from    
          (Select unqid,
                 empno,
                 name,
                 deskid,                          
                 Row_Number() Over (Order By unqid Desc) As row_number,
                 Count(*) Over () As total_row
          From (
                   Select 
                        distinct doa.unqid,
                        doa.empno,
                        e.name,
                        doa.deskid
                   From 
                        dm_orphan_asset doa,
                        ss_emplmast e
                   Where 
                        doa.empno = e.empno and
                        doa.confirmed = 0                                  
                   Order By 
                        doa.deskid
                ))
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_orphan_request_list;
   
   /* Get oraphan assets request detail */
   function get_orphan_request_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c                    Sys_Refcursor;      
   Begin
      Open c for
      select * from    
          (
            Select 
                doa.unqid,
                du.empno,
                e.name,
                du.deskid,
                dda.assetid,
                da.assettype As asset_type,
                da.model As description,                          
                Row_Number() Over (Order By du.deskid Desc) As row_number,
                Count(*) Over () As total_row
             From dm_usermaster du,
                dm_deskallocation dda,
                dm_assetcode da,
                dm_orphan_asset doa,
                ss_emplmast e,
                dm_sub_assettype dsa
            Where du.deskid = dda.deskid and
                doa.deskid = dda.deskid and
                trim(dda.assetid) = trim(da.barcode) and
                trim(doa.assetid) = trim(da.barcode) and
                da.sub_asset_type = dsa.sub_asset_type and
                du.empno = doa.empno and
                du.empno = e.empno and
                doa.unqid = p_unqid and
                doa.confirmed = 0
            Order by dsa.sort_order asc
          )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_orphan_request_detail;
   
   
   /* Get 2home assets request detail */
   function get_2home_request_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;     
   Begin
        Open c for
          select * from 
           (
            Select 
                dah.unqid,
                du.empno As empno,
                du.deskid As deskid,
                dda.assetid As assetid,
                da.assettype As asset_type,
                da.model As description,                          
                Row_Number() Over (Order By du.deskid Desc) As row_number,
                Count(*) Over () As total_row
            From 
                dm_usermaster du,
                dm_deskallocation dda,
                dm_assetcode da,
                dm_asset_home_request dah,
                dm_sub_assettype dsa
            Where 
                du.deskid = dda.deskid and
                dah.deskid = dda.deskid and
                trim(dda.assetid) = trim(da.barcode) and
                trim(dah.assetid) = trim(da.barcode) and
                da.sub_asset_type = dsa.sub_asset_type and
                du.empno = dah.empno and                
                dah.unqid = p_unqid and
                dah.confirmed = 0
            Order by dsa.sort_order asc
           )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_request_detail;
    
   /* Get 2home assets request list */
   function get_2home_request_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;      
   Begin
        Open c for
          select * from 
           (Select unqid,
                  empno,
                  name,
                  deskid,                          
                  Row_Number() Over (Order By unqid Desc) As row_number,
                  Count(*) Over () As total_row
           From (
                   Select 
                        distinct doa.unqid,
                        doa.empno As empno,
                        e.name,
                        doa.deskid As deskid
                   From 
                        dm_asset_home_request doa,
                        ss_emplmast e
                   Where 
                        doa.empno = e.empno and
                        doa.confirmed = 0                    
                   Order By 
                        doa.deskid
                ))
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_request_list;
   
    /* Get 2home gatepass list */
   function get_2home_gatepass_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;      
   Begin
        Open c for
          select * from 
           (Select unqid,
                  empno,
                  name,
                  deskid,                          
                  Row_Number() Over (Order By unqid Desc) As row_number,
                  Count(*) Over () As total_row
           From (
                   Select 
                        distinct doa.unqid,
                        doa.empno As empno,
                        e.name,
                        doa.deskid As deskid
                   From 
                        dm_asset_home_request doa,
                        ss_emplmast e
                   Where 
                        doa.empno = e.empno and
                        doa.confirmed = 1                    
                   Order By 
                        doa.deskid
                ))
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_gatepass_list;
   
   /* Get 2home gatepass detail */
   function get_2home_gatepass_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;     
   Begin
        Open c for
          --select * from 
           --(
            Select 
                dah.unqid,
                du.empno As empno,
                du.deskid As deskid,
                dda.assetid As assetid,
                da.assettype As asset_type,
                da.model As description,                          
                Row_Number() Over (Order By du.deskid Desc) As row_number,
                Count(*) Over () As total_row
            From 
                dm_usermaster du,
                dm_deskallocation dda,
                dm_assetcode da,
                dm_asset_home_request dah,
                dm_sub_assettype dsa
            Where 
                du.deskid = dda.deskid and
                dah.deskid = dda.deskid and
                trim(dda.assetid) = trim(da.barcode) and
                trim(dah.assetid) = trim(da.barcode) and
                da.sub_asset_type = dsa.sub_asset_type and
                du.empno = dah.empno and                
                dah.unqid = p_unqid and
                dah.confirmed = 1
            Order by dsa.sort_order asc;
           --)
          --Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_gatepass_detail;
End IOT_DMS_SS_QRY;
/
---------------------------
--New PACKAGE BODY
--IOT_DMS
---------------------------
CREATE OR REPLACE PACKAGE BODY "DMS"."IOT_DMS" As
   
   /* DESK MASETR */   

   Procedure sp_add_desk( 
        p_deskid           Varchar2,        
        p_office           Varchar2,
        p_floor            Varchar2,
        p_seatno           Varchar2,
        p_wing             Varchar2,
        p_assetcode        Varchar2, 
        p_noexists         Varchar2,
        p_cabin            Varchar2,
        p_remarks          Varchar2,
        p_bay              Varchar2,
        p_workarea         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
   ) as
        v_exists           number;
    begin
        select
            count(deskid) into v_exists
        from 
            dm_deskmaster
        where deskid = p_deskid;        

        If v_exists = 0 Then
            insert into dm_deskmaster (
                deskid,
                office,
                floor,
                seatno,
                wing,
                assetcode,                
                noexist,
                cabin,
                remarks,
                work_area,
                bay
            ) values (
                upper(p_deskid),
                p_office,
                p_floor,
                p_seatno,
                p_wing,
                upper(p_assetcode),
                p_noexists,
                upper(p_cabin),
                p_remarks,
                upper(p_workarea),
                upper(p_bay)
            );
            commit;
            p_message_type := 'OK';
        Else
            p_message_type := 'KO';
            p_message_text := 'Desk already exists !!!';
        End If;

      Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
   End sp_add_desk;

   Procedure sp_edit_desk(
        p_deskid           Varchar2,
        p_noexists         Varchar2,
        p_cabin            Varchar2,
        p_remarks          Varchar2,
        p_bay              Varchar2,
        p_workarea         Varchar2,      

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
   ) as
        v_exists           Number;
    begin
        select
            count(deskid) into v_exists
        from 
            dm_deskmaster
        where deskid = p_deskid;        

        If v_exists = 1 Then
            update dm_deskmaster 
                set noexist = p_noexists,
                    cabin = upper(p_cabin),
                    remarks = p_remarks,
                    work_area = upper(p_workarea),
                    bay = upper(p_bay)
            where deskid = upper(p_deskid);
            commit;
            p_message_type := 'OK';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching desk exists !!!';
        End If;

      Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
   End sp_edit_desk;

End IOT_DMS;
/
