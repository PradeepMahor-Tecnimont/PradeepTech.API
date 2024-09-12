create or replace Package Body tcmpl_afc.pkg_bg_main_amendment As
    Procedure sp_bg_amendment_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_refnum           Varchar2,
        p_amendmentnum     Varchar2,
        p_bgrecdt          Date default null,
        p_currid           Varchar2,
        p_bgamt            Varchar2,
        p_convrate         Varchar2,
        p_bgaccept         Varchar2,
        p_bgacceptrmk      Varchar2,
        p_docurl           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_user_tcp_ip    Varchar2(5) := 'NA';
        v_status_type_id Varchar2(3) := 'S01';
        v_message_type   Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into bg_main_amendments (refnum, amendmentnum, bgrecdt, currid,
            bgamt, convrate, bgaccept, bgacceptrmk, docurl, modifiedby, modifiedon)
        Values (p_refnum, pkg_bg_common.fn_bg_get_new_amendment_num(p_refnum), p_bgrecdt, p_currid,
            p_bgamt, p_convrate, p_bgaccept, p_bgacceptrmk, p_docurl, v_empno, sysdate);

        pkg_bg_main_status.sp_bg_status_add(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,
            p_refnum         => p_refnum,
            p_amendmentnum   => p_amendmentnum,
            p_status_type_id => v_status_type_id,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_bg_amendment_add;

    Procedure sp_bg_amendment_update(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,        
        p_refnum           Varchar2,
        p_amendmentnum     Varchar2,       
        p_currid           Varchar2, 
        p_bgamt            Varchar2,
        p_bgrecdt          Date default null,
        p_bgaccept         Varchar2,
        p_bgacceptrmk      Varchar2,
        p_docurl           Varchar2,
        p_convrate         Varchar2,
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
            bg_main_amendments
        Set
            bgrecdt = p_bgrecdt,
            currid = p_currid,
            bgamt = p_bgamt,            
            convrate = p_convrate,
            bgaccept = p_bgaccept,
            bgacceptrmk = p_bgacceptrmk,
            docurl = p_docurl,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            refnum           = p_refnum
            And amendmentnum = p_amendmentnum;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_bg_amendment_update;

    Procedure sp_bg_amendment_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_refnum           Varchar2,
        p_amendment        Varchar2,
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

        Delete
            From bg_main_amendments
        Where
            refnum           = p_refnum
            And amendmentnum = p_amendment;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_bg_amendment_delete;

End pkg_bg_main_amendment;