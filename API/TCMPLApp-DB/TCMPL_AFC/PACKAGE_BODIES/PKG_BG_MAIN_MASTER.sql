create or replace Package Body tcmpl_afc.pkg_bg_main_master As

    Procedure sp_bg_main_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_bgnum            Varchar2,
        p_bgdate           Date Default Null,
        p_compid           Varchar2,
        p_bgtype           Varchar2,
        p_ponum            Varchar2,
        p_projnum          Varchar2,
        p_issuebyid        Varchar2,
        p_issuetoid        Varchar2,
        p_bgvaldt          Date Default Null,
        p_bgclmdt          Date Default Null,
        p_bankid           Varchar2,
        p_remarks          Varchar2,
        p_released         Varchar2,
        p_reldt            Date Default Null,
        p_reldetails       Varchar2,
        p_amendmentnum     Varchar2,
        p_currid           Varchar2,
        p_bgamt            Varchar2,
        p_bgrecdt          Date Default Null,
        p_bgaccept         Varchar2,
        p_bgacceptrmk      Varchar2,
        p_docurl           Varchar2,
        p_convrate         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_user_tcp_ip    Varchar2(5) := 'NA';
        v_message_type   Number      := 0;
        v_refnum_new     Varchar2(11);
        v_status_type_id Varchar2(3) := 'S01';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            pkg_bg_common.fn_bg_get_new_ref_num(p_projnum)
        Into
            v_refnum_new
        From
            dual;

        If v_refnum_new Is Not Null Then
            Insert Into bg_main_master (refnum,
                bgnum,
                bgdate,
                ponum,
                issueby,
                projnum,
                issueto,
                bgvaldt,
                bgclmdt,
                bgtype,
                bankid,
                remarks,
                compid,
                released,
                reldt,
                reldetails,
                modifiedby,
                modifiedon)
            Values (v_refnum_new,
                Trim(p_bgnum),
                p_bgdate,
                Trim(p_ponum),
                Trim(p_issuebyid),
                Trim(p_projnum),
                Trim(p_issuetoid),
                p_bgvaldt,
                p_bgclmdt,
                Trim(p_bgtype),
                Trim(p_bankid),
                Trim(p_remarks),
                Trim(p_compid),
                p_released,
                p_reldt,
                Trim(p_reldetails),
                v_empno,
                sysdate);

            Insert Into bg_main_amendments (refnum,
                currid,
                bgamt,
                bgrecdt,
                bgaccept,
                bgacceptrmk,
                docurl,
                convrate,
                amendmentnum,
                modifiedby,
                modifiedon)
            Values (v_refnum_new,
                Trim(p_currid),
                Trim(p_bgamt),
                p_bgrecdt,
                Trim(p_bgaccept),
                Trim(p_bgacceptrmk),
                Trim(p_docurl),
                Trim(p_convrate),
                Trim(p_amendmentnum),
                v_empno,
                sysdate);

            pkg_bg_main_status.sp_bg_status_add(
                p_person_id      => p_person_id,
                p_meta_id        => p_meta_id,
                p_refnum         => v_refnum_new,
                p_amendmentnum   => Trim(p_amendmentnum),
                p_status_type_id => v_status_type_id,
                p_message_type   => p_message_type,
                p_message_text   => p_message_text
            );

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'BG refnumber error occured';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_bg_main_add;

    Procedure sp_bg_main_update(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_refnum           Varchar2,
        p_bgnum            Varchar2,
        p_bgdate           Date,
        p_compid           Varchar2,
        p_bgtype           Varchar2,
        p_ponum            Varchar2,
        p_projnum          Varchar2,
        p_issuebyid        Varchar2,
        p_issuetoid        Varchar2,
        p_bgvaldt          Date,
        p_bgclmdt          Date,
        p_bankid           Varchar2,
        p_remarks          Varchar2,
        p_released         Varchar2,
        p_reldt            Date,
        p_reldetails       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
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

        Update
            bg_main_master
        Set
            bgdate = p_bgdate,
            compid = p_compid,
            bgtype = p_bgtype,
            ponum = p_ponum,
            projnum = p_projnum,
            issueby = p_issuebyid,
            issueto = p_issuetoid,
            bgvaldt = p_bgvaldt,
            bgclmdt = p_bgclmdt,
            bankid = p_bankid,
            remarks = p_remarks,
            released = p_released,
            reldt = p_reldt,
            reldetails = p_reldetails,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            Trim(refnum)    = Trim(p_refnum)
            And Trim(bgnum) = Trim(p_bgnum);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_bg_main_update;

    Procedure sp_bg_main_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_refnum           Varchar2,
        p_bgnum            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
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

        Update
            bg_main_master
        Set
            isdelete = 1,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            Trim(refnum)    = Trim(p_refnum)
            And Trim(bgnum) = Trim(p_bgnum);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_bg_main_delete;

End pkg_bg_main_master;