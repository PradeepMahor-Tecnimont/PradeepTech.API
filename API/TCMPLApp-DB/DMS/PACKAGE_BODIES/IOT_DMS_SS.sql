--------------------------------------------------------
--  DDL for Package IOT_DMS_SS
--------------------------------------------------------

Create Or Replace Package Body "DMS"."IOT_DMS_SS" As

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

Grant Execute On "DMS"."IOT_DMS_SS" To "TCMPL_APP_CONFIG";