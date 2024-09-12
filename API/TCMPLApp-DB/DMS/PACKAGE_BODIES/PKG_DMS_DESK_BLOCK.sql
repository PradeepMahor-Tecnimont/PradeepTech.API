create or replace PACKAGE BODY "DMS"."PKG_DMS_DESK_BLOCK" AS
    
    procedure sp_add_desk_block(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_remarks          Varchar2,
        p_blockreason      Number,        
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) as
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
     Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        Update 
            dm_deskmaster 
        Set 
            isblocked = 1,
            remarks = Trim(p_remarks)
        where 
            Trim(deskid) = Trim(p_deskid);         
        
        Select
            Count(*)
        Into
            v_exists
        From
            dm_desklock
        Where
            Trim(deskid) = Trim(p_deskid);
        
        If v_exists = 0 Then
            Insert Into dm_desklock
                (unqid, empno, deskid, targetdesk, blockflag, blockreason)
            Values
                (p_remarks, 'Y', Trim(upper(p_deskid)), 0, 1, p_blockreason);
        End If;
        
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Desk blocked successfully.';
        
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            
    end sp_add_desk_block;

    procedure sp_update_desk_block(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,        
        p_remarks          Varchar2,
        p_blockreason      Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) as
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
     Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        Update 
            dm_deskmaster 
        Set 
            isblocked = 1,
            remarks = Trim(p_remarks)
        where 
            Trim(deskid) = Trim(p_deskid);         
        
        Select
            Count(*)
        Into
            v_exists
        From
            dm_desklock
        Where
            Trim(deskid) = Trim(p_deskid);
        
        If v_exists = 0 Then
            Insert Into dm_desklock
                (unqid, empno, deskid, targetdesk, blockflag, blockreason)
            Values
                (p_remarks, 'Y', Trim(p_deskid), 0, 1, p_blockreason);
        Else
            Update 
                dm_desklock 
            Set 
                unqid = Trim(p_remarks),                 
                blockreason = p_blockreason
            where 
                Trim(deskid) = Trim(p_deskid);
        End If;
        
        Commit;
        
        p_message_type := 'OK';
        p_message_text := 'Desk updated successfully.';
        
    end sp_update_desk_block;
	
    procedure sp_remove_desk_block(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) as
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
     Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        Update 
            dm_deskmaster 
        Set 
            isblocked = 0,
            remarks = ''
        where 
            Trim(deskid) = Trim(p_deskid);         
        
        Select
            Count(*)
        Into
            v_exists
        From
            dm_desklock
        Where
            Trim(deskid) = Trim(p_deskid);
        
        If v_exists = 1 Then
            Delete from 
                dm_desklock
            Where
                Trim(deskid) = Trim(p_deskid);            
        End If;
        
        Commit;
        
        p_message_type := 'OK';
        p_message_text := 'Desk block removed successfully.';
        
    end sp_remove_desk_block;
    
END PKG_DMS_DESK_BLOCK;

/

Grant Execute On "DMS"."PKG_DMS_DESK_BLOCK" To "TCMPL_APP_CONFIG";