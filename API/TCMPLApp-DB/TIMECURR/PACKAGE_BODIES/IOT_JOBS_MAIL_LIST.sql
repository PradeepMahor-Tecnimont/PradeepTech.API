--------------------------------------------------------
--  DDL for Package Body IOT_JOBS_MAIL_LIST
--------------------------------------------------------

Create Or Replace Package Body timecurr.iot_jobs_mail_list As

    Procedure sp_insert_into_mail_list(
        p_costcode Varchar2,
        p_projno   Varchar2

    ) As

    Begin
        Insert Into job_mail_list_costcodes(projno, costcode) Values (p_projno, p_costcode);
    Exception
        When Others Then
            Null;
    End;

    Procedure sp_normalize_legacy As
        Cursor c1 Is
            Select
                *
            From
                jobmaster;
        Type typ_tab_jobmaster Is Table Of c1%rowtype;
        tab_jobmaster typ_tab_jobmaster;
    Begin

        Open c1;

        Loop
            Fetch c1 Bulk Collect Into tab_jobmaster Limit 50;
            For i In 1..tab_jobmaster.count
            Loop
                If tab_jobmaster(i).proj = '[X]' Then
                    sp_insert_into_mail_list('0251', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).qual = '[X]' Then
                    sp_insert_into_mail_list('0210', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).procs = '[X]' Then
                    sp_insert_into_mail_list('0240', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).stequ = '[X]' Then
                    sp_insert_into_mail_list('0260', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).pipin = '[X]' Then
                    sp_insert_into_mail_list('0221', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).elect = '[X]' Then
                    sp_insert_into_mail_list('0226', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).instr = '[X]' Then
                    sp_insert_into_mail_list('0227', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).civi = '[X]' Then
                    sp_insert_into_mail_list('0225', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).mach = '[X]' Then
                    sp_insert_into_mail_list('0258', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).hse = '[X]' Then
                    sp_insert_into_mail_list('0220', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).procu = '[X]' Then
                    sp_insert_into_mail_list('0360', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).inspx = '[X]' Then
                    sp_insert_into_mail_list('0261', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).proco = '[X]' Then
                    sp_insert_into_mail_list('0321', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).edp = '[X]' Then
                    sp_insert_into_mail_list('0192', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).const = '[X]' Then
                    sp_insert_into_mail_list('0331', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).amfi = '[X]' Then
                    sp_insert_into_mail_list('0190', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).hrd = '[X]' Then
                    sp_insert_into_mail_list('0180', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cosec = '[X]' Then
                    sp_insert_into_mail_list('0104', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).subcont = '[X]' Then
                    sp_insert_into_mail_list('0264', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).tracu = '[X]' Then
                    sp_insert_into_mail_list('0262', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).procrd = '[X]' Then
                    sp_insert_into_mail_list('0268', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).preng = '[X]' Then
                    sp_insert_into_mail_list('0229', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).elin = '[X]' Then
                    sp_insert_into_mail_list('0342', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_237 = '[X]' Then
                    sp_insert_into_mail_list('0237', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_251 = '[X]' Then
                    sp_insert_into_mail_list('0251', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_290 = '[X]' Then
                    sp_insert_into_mail_list('0290', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_292 = '[X]' Then
                    sp_insert_into_mail_list('0292', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_246 = '[X]' Then
                    sp_insert_into_mail_list('0246', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_247 = '[X]' Then
                    sp_insert_into_mail_list('0247', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_217 = '[X]' Then
                    sp_insert_into_mail_list('0217', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_211 = '[X]' Then
                    sp_insert_into_mail_list('0211', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_296 = '[X]' Then
                    sp_insert_into_mail_list('0296', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_285 = '[X]' Then
                    sp_insert_into_mail_list('0285', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_242 = '[X]' Then
                    sp_insert_into_mail_list('0242', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_360 = '[X]' Then
                    sp_insert_into_mail_list('0360', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_204 = '[X]' Then
                    sp_insert_into_mail_list('0204', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_302 = '[X]' Then
                    sp_insert_into_mail_list('0302', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_320 = '[X]' Then
                    sp_insert_into_mail_list('0320', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_385 = '[X]' Then
                    sp_insert_into_mail_list('0385', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_330 = '[X]' Then
                    sp_insert_into_mail_list('0330', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_252 = '[X]' Then
                    sp_insert_into_mail_list('0252', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_283 = '[X]' Then
                    sp_insert_into_mail_list('0283', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_286 = '[X]' Then
                    sp_insert_into_mail_list('0286', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_214 = '[X]' Then
                    sp_insert_into_mail_list('0214', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_234 = '[X]' Then
                    sp_insert_into_mail_list('0234', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_343 = '[X]' Then
                    sp_insert_into_mail_list('0343', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_331 = '[X]' Then
                    sp_insert_into_mail_list('0331', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_334 = '[X]' Then
                    sp_insert_into_mail_list('0334', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_307 = '[X]' Then
                    sp_insert_into_mail_list('0307', tab_jobmaster(i).projno);
                End If;
                If tab_jobmaster(i).cc_284 = '[X]' Then
                    sp_insert_into_mail_list('0284', tab_jobmaster(i).projno);
                End If;

            End Loop;
            Exit When c1%notfound;
        End Loop;

    End;

    Procedure sp_add_mail_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_costcode         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

    Begin
        Insert Into job_mail_list_costcodes(
            projno,
            costcode
        )
        Values (
            p_projno,
            p_costcode
        );
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_delete_mail_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_costcode         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

    Begin
        Delete
            From job_mail_list_costcodes
        Where
            projno       = p_projno
            And costcode = p_costcode;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully';

        Commit;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_insert_mail_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_tmagroup         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Insert Into job_mail_list_costcodes
        Select
            Trim(p_projno), costcode
        From
            job_tmagroup_mail_map
        Where
            tmagroup = Trim(p_tmagroup);
    
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;
    
    Procedure sp_modify_mail_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_tmagroup         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Delete
            From job_mail_list_costcodes
        Where
            costcode Not In (
                Select
                    costcode
                From
                    job_tmagroup_mail_map
                Where
                    tmagroup = Trim(p_tmagroup)
            )
            And projno = Trim(p_projno);
    
        Insert Into job_mail_list_costcodes
        Select
            Trim(p_projno), costcode
        From
            job_tmagroup_mail_map
        Where
            tmagroup = Trim(p_tmagroup)
            And costcode Not In (
                Select
                    costcode
                From
                    job_mail_list_costcodes
                Where
                    projno = Trim(p_projno)
            );
    
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully';

    Exception
        When Others Then
        p_message_type := c_not_ok;
        p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;


End;