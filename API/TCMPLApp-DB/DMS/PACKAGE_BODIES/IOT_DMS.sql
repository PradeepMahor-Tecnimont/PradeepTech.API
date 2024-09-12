Create Or Replace Package Body "IOT_DMS" As
   
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

  GRANT EXECUTE ON "DMS"."IOT_DMS" TO "TCMPL_APP_CONFIG";