Create Or Replace Package Body "TCMPL_HR"."PKG_ICARD_PHOTO_CONSENT" As

    Procedure sp_add_icard_photo_consent(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number;
        v_empno  Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into icard_photo_consent
        (
            empno,
            is_consent,
            new_img_uploaded,
            modified_on,
            modified_by,
            photo_upload_on
        )
        Values
        (
            Trim(nvl(p_empno, v_empno)),
            not_ok,
            ok,
            sysdate,
            v_empno,
            sysdate
        );

        Commit;
        p_message_type := ok;
        p_message_text := 'ICard photo added successfully..';
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'ICard photo already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_icard_photo_consent;

    Procedure sp_update_icard_photo_consent(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_is_consent       Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_empno Is Null Then
            If p_is_consent = ok Then
                Update
                    icard_photo_consent
                Set
                    is_consent = p_is_consent,
                    modified_on = sysdate,
                    modified_by = v_empno,
                    consent_on = sysdate
                Where
                    empno = Trim(v_empno);
            Else
                Update
                    icard_photo_consent
                Set
                    is_consent = p_is_consent,
                    modified_on = sysdate,
                    modified_by = v_empno,
                    photo_upload_on = sysdate
                Where
                    empno = Trim(v_empno);
            End If;
        Else
            Update
                icard_photo_consent
            Set
                is_consent = p_is_consent,
                modified_on = sysdate,
                modified_by = v_empno,
                hr_reset_on = sysdate,
                hr_reset_by = v_empno
            Where
                empno = Trim(p_empno);
        End If;
        Commit;
        p_message_type := ok;
        p_message_text := 'ICard photo updated successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'ICard photo already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_icard_photo_consent;

    Procedure sp_add_emp_icard_photo_consent(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists Number;
        v_empno  Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(empno)
        Into
            v_exists
        From
            icard_photo_consent
        Where
            empno = Trim(nvl(p_empno, v_empno));

        If v_exists = 0 Then
            pkg_icard_photo_consent.sp_add_icard_photo_consent(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_empno        => p_empno,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
        Else
            pkg_icard_photo_consent.sp_update_icard_photo_consent(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_empno        => p_empno,
                p_is_consent   => not_ok,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'ICard photo already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_emp_icard_photo_consent;

    Procedure sp_emp_update_icard_photo_consent(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_is_consent       Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number;
        v_empno  Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(empno)
        Into
            v_exists
        From
            icard_photo_consent
        Where
            empno = Trim(nvl(p_empno, v_empno));

        If v_exists = 1 Then
            pkg_icard_photo_consent.sp_update_icard_photo_consent(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_empno        => p_empno,
                p_is_consent   => p_is_consent,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );            
        Else
            Insert Into icard_photo_consent
            (
                empno,
                is_consent,
                new_img_uploaded,
                modified_on,
                modified_by,
                consent_on
            )
            Values
            (
                Trim(nvl(p_empno, v_empno)),
                ok,
                not_ok,
                sysdate,
                v_empno,
                sysdate
            );
        End If;
        
        Commit;
        p_message_type := ok;
        p_message_text := 'ICard photo updated successfully.';

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'ICard photo already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_update_icard_photo_consent;

End pkg_icard_photo_consent;