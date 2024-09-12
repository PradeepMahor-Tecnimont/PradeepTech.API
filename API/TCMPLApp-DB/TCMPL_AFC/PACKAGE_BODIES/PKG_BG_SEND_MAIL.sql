create or replace Package Body tcmpl_afc.pkg_bg_send_mail As

    Procedure proc_notification_mail(
        p_refnum           Varchar2,
        p_projno           Varchar2,
        p_compid           Varchar2,
        p_expiry_param     Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        Cursor cur_mail Is
            Select
                group_id,
                Listagg(email, ';') Within
                    Group (Order By
                        empno) email
            From
                (
                    Select
                        empno,
                        replace(email, ',', '.')                       email,

                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                            Distinct
                                prjmngr                                empno,
                                pkg_bg_common.fn_bg_get_email(prjmngr) email
                            From
                                vu_projmast
                            Where
                                proj_no = p_projno
                            Union
                            Select
                                empno,
                                pkg_bg_common.fn_bg_get_email(empno) email
                            From
                                bg_payable_mast
                            Where
                                compid        = p_compid
                                And isvisible = 1
                                And isdeleted = 0
                            Union
                            Select
                                empno,
                                pkg_bg_common.fn_bg_get_email(empno) email
                            From
                                bg_proj_contl_mast
                            Where
                                compid        = p_compid
                                And isvisible = 1
                                And isdeleted = 0
                            Union
                            Select
                                empno,
                                pkg_bg_common.fn_bg_get_email(empno) email
                            From
                                bg_proj_dir_mast
                            Where
                                compid        = p_compid
                                And isvisible = 1
                                And isdeleted = 0
                        )
                    Order By empno
                )
            Group By
                group_id;

        v_mail    Varchar2(4000);
        v_success Varchar2(1000);
        v_message Varchar2(500);

    Begin
        For email_row In cur_mail
        Loop
            v_mail := email_row.email;

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => v_mail,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => get_notification_mail_subject(p_refnum),
                p_mail_body1   => get_notification_mail_body(p_refnum, p_expiry_param),
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => c_mail_from,
                p_message_type => v_success,
                p_message_text => v_message
            );
        End Loop;
        p_message_type := c_ok;
        p_message_text := 'Success';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End proc_notification_mail;

    Function get_notification_mail_subject(p_refnum Varchar2) Return Varchar2 Is
        v_subject Varchar2(1000);
    Begin
        Select
        Distinct
            'Bank Guarantee - expiration - ' || mm.projnum || ' - ' || p.name || ' - ' || bm.bankname
        Into
            v_subject
        From
            vu_projmast                   p, bg_main_master mm, bg_bank_mast bm
        Where
            substr(p.projno, 1, 5) = mm.projnum
            And bm.bankid          = mm.bankid
            And mm.refnum          = Trim(p_refnum);

        Return v_subject;
    Exception
        When Others Then
            Return 'Error';

    End get_notification_mail_subject;

    Function get_notification_mail_body(p_refnum       Varchar2,
                                        p_expiry_param Varchar2) Return Varchar2 Is
        v_msg_body    Varchar2(4000);
        v_bgnum       bg_main_master.bgnum%Type;
        v_issued_by   bg_issued_by_mast.issuedby%Type;
        v_issuer_name bg_bank_mast.bankname%Type;
        v_ponum       bg_main_master.ponum%Type;
        v_projnum     Varchar2(120);
        v_bgtype      bg_main_master.bgtype%Type;
        v_bgvaldt     bg_main_master.bgvaldt%Type;
        v_bgclmdt     bg_main_master.bgclmdt%Type;
        v_bgamt       bg_main_amendments.bgamt%Type;
    Begin
        Select
        Distinct
            mm.bgnum,
            ibm.issuedby,
            bm.bankname,
            mm.ponum,
            mm.projnum || ' - ' || p.name,
            mm.bgtype,
            mm.bgvaldt,
            mm.bgclmdt,
            ma.bgamt
        Into
            v_bgnum, v_issued_by, v_issuer_name, v_ponum, v_projnum, v_bgtype, v_bgvaldt, v_bgclmdt, v_bgamt
        From
            vu_projmast                   p, bg_main_master mm, bg_main_amendments ma, bg_bank_mast bm, bg_issued_by_mast
            ibm

        Where
            ma.amendmentnum            =
                       (
                           Select
                               lpad(Max(To_Number(amendmentnum)), 3, '0')

                           From
                               bg_main_status
                           Where
                               refnum = ma.refnum
                       )
            And substr(p.projno, 1, 5) = mm.projnum
            And mm.refnum              = ma.refnum
            And mm.issueby             = ibm.issuedbyid
            And mm.bankid              = bm.bankid
            And mm.refnum              = Trim(p_refnum);

        v_msg_body := '<p>Dear All,</p>' || chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<p>Details of Bank Guarantee(s) expiring in next ' || p_expiry_param || '...</p>' ||
                      chr(10) ||chr(13) || chr(10) || chr(13);

        v_msg_body := v_msg_body || '<table style="border-collapse: collapse;width:75%; max-width:500px;" border="1"><tbody>';
        v_msg_body := v_msg_body || '<tr><td>BG No</td>' || '<td></td><td></td><td></td><td>' || v_bgnum || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>Issued By</td>' || '<td></td><td></td><td></td><td>' || v_issued_by || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>Issuer Name</td>' || '<td></td><td></td><td></td><td>' || v_issuer_name || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>PO Name</td>' || '<td></td><td></td><td></td><td>' || v_ponum || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>Project</td>' || '<td></td><td></td><td></td><td>' || v_projnum || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>BG Type</td>' || '<td></td><td></td><td></td><td>' || v_bgtype || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>BG Validity</td>' || '<td></td><td></td><td></td><td>' || v_bgvaldt || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>BG Claim Date</td>' || '<td></td><td></td><td></td><td>' || v_bgclmdt || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<tr><td>BG Amount</td>' || '<td></td><td></td><td></td><td>' || v_bgamt || '</td></tr>' ||
                      chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '</tbody></table>';

        v_msg_body := v_msg_body || '<p>Request you to advice on Encashment / Extension (with Period) of the expiring Bank Guarantees to AFC BG ';
        v_msg_body := v_msg_body || 'Desk within 7 days from the receipt of the mail for further actions.</p>' || chr(10) ||
                      chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<p>AFC BG Desk</p>' || chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || '<p>This is system generated email.</p>';

        Return v_msg_body;
    End get_notification_mail_body;

    --	Grant execute on pkg_bg_send_mail to tcmpl_app_config;

End pkg_bg_send_mail;