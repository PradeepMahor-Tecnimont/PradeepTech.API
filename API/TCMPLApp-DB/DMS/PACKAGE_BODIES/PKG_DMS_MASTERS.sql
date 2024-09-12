--------------------------------------------------------
--  DDL for Package Body PKG_DMS_MASTERS
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_MASTERS" As

    Procedure sp_add_deskmaster(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_office           Varchar2 Default Null,
        p_floor            Varchar2 Default Null,
        p_seat_no          Varchar2 Default Null,
        p_wing             Varchar2 Default Null,
        p_asset_code       Varchar2 Default Null,
        p_is_blocked       Varchar2 Default Null,
        p_cabin            Varchar2 Default Null,
        p_remarks          Varchar2 Default Null,
        p_deskid_old       Varchar2 Default Null,
        p_work_area_code   Varchar2 Default Null,
        p_bay              Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_cabin         Varchar2(1);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(deskid)
        Into
            v_exists
        From
            dm_deskmaster
        Where
            deskid = p_desk_id;

        If v_exists = 0 Then
            
            if p_cabin = 'Y' then
                v_cabin :='C';
            end if;
            
            Insert Into dm_deskmaster
                (deskid, office, floor, seatno, wing, assetcode, isblocked, cabin, remarks, deskid_old, work_area, bay)
            Values
            (upper(p_desk_id), Trim(p_office), p_floor, p_seat_no, p_wing, p_asset_code, p_is_blocked, v_cabin, p_remarks,
                p_deskid_old,
                p_work_area_code, p_bay);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Desk already exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_deskmaster;

    Procedure sp_update_deskmaster(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_office           Varchar2 Default Null,
        p_floor            Varchar2 Default Null,
        p_seat_no          Varchar2 Default Null,
        p_wing             Varchar2 Default Null,
        p_asset_code       Varchar2 Default Null,
        p_is_blocked       Number   Default 0,
        p_cabin            Varchar2 Default Null,
        p_remarks          Varchar2 Default Null,
        p_deskid_old       Varchar2 Default Null,
        p_work_area_code   Varchar2 Default Null,
        p_bay              Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists             Number;
        v_old_work_area      Varchar2(3);
        v_cabin         Varchar2(1);
        v_old_area_catg_code Varchar2(4);
        v_new_area_catg_code Varchar2(4);
        v_empno              Varchar2(5);
        v_user_tcp_ip        Varchar2(5) := 'NA';
        v_message_type       Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        -- Start "Get old area_catg_code and work_area"
        Select
            Count(deskid)
        Into
            v_exists
        From
            dm_deskmaster
        Where
            deskid = p_desk_id;

        Select
            d.work_area,
            (
                Select
                Distinct b.area_catg_code
                From
                    dm_desk_areas b
                Where
                    b.area_key_id = d.work_area
            ) As area_catg_code
        Into
            v_old_work_area,
            v_old_area_catg_code
        From
            dm_deskmaster d
        Where
            deskid = p_desk_id;
            
        -- End "Get old area_catg_code and work_area"           

        -- Start "Get new area_catg_code "

        Select
        Distinct b.area_catg_code
        Into
            v_new_area_catg_code
        From
            dm_desk_areas b
        Where
            b.area_key_id = p_work_area_code;
                    
        -- End "Get new area_catg_code "

        If upper(v_old_work_area) = upper(p_work_area_code) Then
            If upper(v_old_area_catg_code) = upper(v_new_area_catg_code) Then
                Null;
            End If;
        End If;

        If v_exists = 1 Then
         if p_cabin = 'Y' then
                v_cabin :='C';
            end if;
            
            Update
                dm_deskmaster
            Set
                office = Trim(p_office),
                floor = p_floor,
                seatno = p_seat_no,
                wing = p_wing,
                assetcode = p_asset_code,
                isblocked = p_is_blocked,
                cabin = upper(v_cabin),
                remarks = p_remarks,
                deskid_old = p_deskid_old,
                work_area = upper(p_work_area_code),
                bay = upper(p_bay)
            Where
                deskid = p_desk_id;

            If upper(v_old_work_area) != upper(p_work_area_code) Then
                If upper(v_old_area_catg_code) != upper(v_new_area_catg_code) Then
                    Null;
                End If;
            End If;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching desk exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_deskmaster;

    Procedure sp_delete_deskmaster(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_work_area_code   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(deskid)
        Into
            v_exists
        From
            dm_deskmaster
        Where
            deskid        = p_desk_id
            And isdeleted = 0;
        If v_exists = 1 Then
            Update
                dm_deskmaster
            Set
                isdeleted = 1,
                work_area = upper(p_work_area_code)
            Where
                deskid = p_desk_id;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching desk exists !!!';
        End If;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_deskmaster;
     
    Procedure sp_import_desk_area_desk(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_desk_area_desk        typ_tab_string,        
        p_desk_area_desk_errors Out typ_tab_string,
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
    ) As
        v_area_id      	        Varchar2(3);
        v_area_catg_code   	    Varchar2(4);
        v_desk_id 		        Varchar2(7); 
        
        v_valid_cntr            Number := 0;
        tab_desk_area_desk      typ_tab_desk_area_desk;        
        v_rec                   rec_desk_area_desk;
        v_err_num               Number;
        is_error_in_row         Boolean;
        v_count                 Number;
        v_msg_text              Varchar2(200);
        v_msg_type              Varchar2(10);
      Begin
        v_err_num := 0;
        
        /* - - - - - - - - - - - Validate data - - - - - - - - - - - */
        For i In 1..p_desk_area_desk.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_desk_area_desk(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1))         area_id,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1))         area_catg_code,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1))         desk_id
            Into
                v_area_id,
                v_area_catg_code,
                v_desk_id
            From
                csv;

            -- Area
            Select
                Count(*)
            Into
                v_count
            From
                dm_desk_areas
            Where
                upper(Trim(area_key_id)) = upper(Trim(v_area_id));

            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_desk_area_desk_errors(v_err_num) :=
                    v_err_num || '~!~' ||       --ID
                    '' || '~!~' ||              --Section
                    i || '~!~' ||               --XL row number
                    'Area' || '~!~' ||          --FieldName
                    '0' || '~!~' ||             --ErrorType
                    'Critical' || '~!~' ||      --ErrorTypeString
                    'Area not found';           --Message
                is_error_in_row := true;
            End If;

            -- Area category
            Select
                Count(*)
            Into
                v_count
            From
                dm_desk_area_categories
            Where
                upper(Trim(area_catg_code)) = upper(Trim(v_area_catg_code));
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_desk_area_desk_errors(v_err_num) :=
                    v_err_num || '~!~' ||           --ID
                    '' || '~!~' ||                  --Section
                    i || '~!~' ||                   --XL row number
                    'area_catg_code' || '~!~' ||    --FieldName
                    '0' || '~!~' ||                 --ErrorType
                    'Critical' || '~!~' ||          --ErrorTypeString
                    'Area category not found';      --Message
                is_error_in_row := true;
            End If;

            -- Desk
            Select
                Count(*)
            Into
                v_count
            From
                dm_deskmaster
            Where
                upper(Trim(deskid)) = upper(Trim(v_desk_id));
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_desk_area_desk_errors(v_err_num) :=
                    v_err_num || '~!~' ||       --ID
                    '' || '~!~' ||              --Section
                    i || '~!~' ||               --XL row number
                    'desk_id' || '~!~' ||       --FieldName
                    '0' || '~!~' ||             --ErrorType
                    'Critical' || '~!~' ||      --ErrorTypeString
                    'Desk not found';           --Message
                is_error_in_row := true;
            End If;

            If is_error_in_row = false Then
                v_valid_cntr                                    := nvl(v_valid_cntr, 0) + 1;
                tab_desk_area_desk(v_valid_cntr).area_id        := v_area_id;
                tab_desk_area_desk(v_valid_cntr).area_catg_code := v_area_catg_code;
                tab_desk_area_desk(v_valid_cntr).desk_id        := v_desk_id;
            End If;

        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        /* - - - - - - - - - - - Update database - - - - - - - - - - - */
        
        For i In 1..v_valid_cntr
        Loop
            Update dm_DeskMaster
            Set 
                work_area = tab_desk_area_desk(i).area_id
            Where
                deskid = tab_desk_area_desk(i).desk_id;            
            
            If v_msg_type <> 'OK' Then
                v_err_num := v_err_num + 1;
                p_desk_area_desk_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    v_msg_text;             --Message            
            End If;
        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;       
        
    end sp_import_desk_area_desk;

    Procedure sp_import_desk_area_user(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_desk_area_user        typ_tab_string, 
        p_office_code           Varchar2,
        p_desk_area_user_errors Out typ_tab_string,
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
    ) As
        v_area_id      	        Varchar2(3);
        v_area_catg_code   	    Varchar2(4);
        v_area_type 		    Varchar2(4); 
        v_empno 		        Varchar2(5); 
        
        s_empno 		        Varchar2(5); 
        v_valid_cntr            Number := 0;
        tab_desk_area_user      typ_tab_desk_area_user;        
        v_rec                   rec_desk_area_user;
        v_err_num               Number;
        is_error_in_row         Boolean;
        v_count                 Number;
        v_msg_text              Varchar2(200);
        v_msg_type              Varchar2(10);
      Begin
        s_empno        := get_empno_from_meta_id(p_meta_id);
        
        v_err_num := 0;
        
        /* - - - - - - - - - - - Validate data - - - - - - - - - - - */
        For i In 1..p_desk_area_user.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_desk_area_user(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1))         area_id,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1))         area_catg_code,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1))         area_type,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 4, Null, 1))         empno
            Into
                v_area_id,
                v_area_catg_code,
                v_area_type,
                v_empno
            From
                csv;

            -- Area
            Select
                Count(*)
            Into
                v_count
            From
                dm_desk_areas
            Where
                upper(Trim(area_key_id)) = upper(Trim(v_area_id));

            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_desk_area_user_errors(v_err_num) :=
                    v_err_num || '~!~' ||       --ID
                    '' || '~!~' ||              --Section
                    i || '~!~' ||               --XL row number
                    'Area' || '~!~' ||          --FieldName
                    '0' || '~!~' ||             --ErrorType
                    'Critical' || '~!~' ||      --ErrorTypeString
                    'Area not found';           --Message
                is_error_in_row := true;
            End If;

            -- Area category
            Select
                Count(*)
            Into
                v_count
            From
                dm_desk_area_categories
            Where
                upper(Trim(area_catg_code)) = upper(Trim(v_area_catg_code));
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_desk_area_user_errors(v_err_num) :=
                    v_err_num || '~!~' ||           --ID
                    '' || '~!~' ||                  --Section
                    i || '~!~' ||                   --XL row number
                    'area_catg_code' || '~!~' ||    --FieldName
                    '0' || '~!~' ||                 --ErrorType
                    'Critical' || '~!~' ||          --ErrorTypeString
                    'Area category not found';      --Message
                is_error_in_row := true;
            End If;
            
            -- Area type
            Select
                Count(*)
            Into
                v_count
            From
                dm_area_type
            Where
                upper(Trim(key_id)) = upper(Trim(v_area_type));
            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_desk_area_user_errors(v_err_num) :=
                    v_err_num || '~!~' ||           --ID
                    '' || '~!~' ||                  --Section
                    i || '~!~' ||                   --XL row number
                    'area_type' || '~!~' ||         --FieldName
                    '0' || '~!~' ||                 --ErrorType
                    'Critical' || '~!~' ||          --ErrorTypeString
                    'Area type not found';      --Message
                is_error_in_row := true;
            End If;
            
            -- Empno
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                upper(Trim(empno)) = upper(Trim(v_empno));

            If v_count = 0 Then
                v_err_num       := v_err_num + 1;
                p_desk_area_user_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Empno not found';      --Message
                is_error_in_row := true;
            End If;            

            If is_error_in_row = false Then
                v_valid_cntr                                    := nvl(v_valid_cntr, 0) + 1;
                tab_desk_area_user(v_valid_cntr).area_id        := v_area_id;
                tab_desk_area_user(v_valid_cntr).area_catg_code := v_area_catg_code;
                tab_desk_area_user(v_valid_cntr).area_type      := v_area_type;
                tab_desk_area_user(v_valid_cntr).empno          := v_empno;
            End If;

        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        /* - - - - - - - - - - - Update database - - - - - - - - - - - */
        
        For i In 1..v_valid_cntr
        Loop
            
            --Insert into dm_area_type_user_mapping(key_id, area_id, empno, modified_on, modified_by)
             --   values(dbms_random.string('X', 5), tab_desk_area_user(i).area_id, tab_desk_area_user(i).empno, sysdate, s_empno);
            
            pkg_dm_area_type_user_mapping.sp_set_area_type_user_mapping (
                p_person_id     => p_person_id,
                p_meta_id       => p_meta_id,
                p_key_id        => dbms_random.string('X', 5),
                p_area_id       => tab_desk_area_user(i).area_id,
                p_empno         => tab_desk_area_user(i).empno,
                p_office_code   => p_office_code,
                p_start_date    => sysdate,
                p_message_type  => v_msg_type,
                p_message_text  => v_msg_text
            );           
            
            If v_msg_type <> 'OK' Then
                v_err_num := v_err_num + 1;
                p_desk_area_user_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'Empno' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    v_msg_text;             --Message            
            End If;
        End Loop;
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';

        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;  
         
    end sp_import_desk_area_user;

        
End pkg_dms_masters;
/
  Grant Execute On "DMS"."PKG_DMS_MASTERS" To "TCMPL_APP_CONFIG";