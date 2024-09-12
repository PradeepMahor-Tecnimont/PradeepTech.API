--------------------------------------------------------
--  DDL for Package Body PKG_RAP_OSC_MASTER
--------------------------------------------------------

Create Or Replace Package Body timecurr.pkg_rap_osc_master As

    Procedure sp_add_po(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno5          Varchar2,
        p_oscm_vendor      Varchar2,
        p_po_number        Varchar2,
        p_po_date          Date,
        p_po_amt           Number,
        p_costcode         Varchar2,
        p_oscsw_id         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno     Varchar2(5);
        v_oscm_id   Varchar2(10);
        v_costcode  Char(4);
        v_counter   Number := 0;
        v_oscm_type rap_osc_master.oscm_type%Type;
        l_vc_arr2   apex_application_global.vc_arr2;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into rap_osc_master(oscm_id, oscm_date, projno5, oscm_vendor, oscm_type, po_number, po_date, po_amt, lock_orig_budget,
            modified_by, modified_on, cur_po_amt, oscsw_id)
        Values(dbms_random.string('X', 10), sysdate, p_projno5,
            p_oscm_vendor,
            '-',
            Trim(p_po_number),
            p_po_date,
            p_po_amt,
            0,
            v_empno, sysdate, p_po_amt, p_oscsw_id);

        Select
            oscm_id
        Into
            v_oscm_id
        From
            (
                Select
                    oscm_id
                From
                    rap_osc_master
                Order By modified_on Desc
            )
        Where
            Rownum = 1;

        l_vc_arr2      := apex_util.string_to_table(p_costcode, ',');
        For i In 1..l_vc_arr2.count
        Loop
            v_costcode := l_vc_arr2(i);

            pkg_rap_osc_detail.sp_add_costcode(p_person_id => p_person_id, p_meta_id => p_meta_id, p_oscm_id => v_oscm_id,
                                               p_costcode => v_costcode, p_message_type => p_message_type, p_message_text =>
                                               p_message_text);

            If p_message_type = c_not_ok Then
                p_message_type := c_not_ok;
                p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
                Return;

            End If;

            v_counter  := v_counter + 1;
        End Loop;

        If v_counter > 1 Then
            v_oscm_type := c_multi;
        Else
            v_oscm_type := c_mono;
        End If;

        Update
            rap_osc_master
        Set
            oscm_type = v_oscm_type
        Where
            oscm_id = Trim(v_oscm_id);

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_po;

    Procedure sp_update_po(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,
        p_projno5          Varchar2,
        p_oscm_vendor      Varchar2,
        p_po_number        Varchar2,
        p_po_date          Date,
        p_po_amt           Number,
        p_cur_po_amt       Number,
        p_lock_orig_budget Number,
        p_costcode         Varchar2 Default Null,
        p_oscsw_id         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno     Varchar2(5);
        v_costcode  Char(4);
        n_count     Number;
        v_counter   Number := 0;
        v_oscm_type rap_osc_master.oscm_type%Type;
        l_vc_arr2   apex_application_global.vc_arr2;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --Start : Insert costcodes into gtt 
        If p_lock_orig_budget = 0 Then
            l_vc_arr2 := apex_util.string_to_table(p_costcode, ',');
            For i In 1..l_vc_arr2.count
            Loop
                v_costcode := l_vc_arr2(i);
                Insert Into rap_gtt_osc_detail(oscm_id, costcode) Values(p_oscm_id, v_costcode);
            End Loop;

            Commit;
        End If;
        --End : Insert costcodes into gtt

        If p_lock_orig_budget = 0 Then
            For i In 1..l_vc_arr2.count
            Loop
                v_costcode := l_vc_arr2(i);
                Select
                    Count(costcode)
                Into
                    n_count
                From
                    rap_osc_detail
                Where
                    costcode    = Trim(v_costcode)
                    And oscm_id = Trim(p_oscm_id);

                If n_count = 0 Then
                    pkg_rap_osc_detail.sp_add_costcode(p_person_id => p_person_id, p_meta_id => p_meta_id, p_oscm_id => p_oscm_id,
                                                       p_costcode => v_costcode, p_message_type => p_message_type, p_message_text =>
                                                       p_message_text);

                    If p_message_type = c_not_ok Then
                        p_message_type := c_not_ok;
                        p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
                        Return;
                    End If;
                End If;
                v_counter  := v_counter + 1;
            End Loop;

            Update
                rap_osc_master
            Set
                projno5 = p_projno5,
                oscm_vendor = p_oscm_vendor,
                oscm_type = Case v_counter
                                When 1 Then
                                    c_mono
                                Else
                                    c_multi
                            End,
                po_number = Trim(p_po_number),
                po_date = p_po_date,
                po_amt = p_po_amt,
                cur_po_amt = p_cur_po_amt,
                oscsw_id = p_oscsw_id,
                modified_by = v_empno,
                modified_on = sysdate
            Where
                oscm_id = Trim(p_oscm_id);
                                    
            --Start : Delete costcodes 
            Delete
                From rap_osc_hours
            Where
                oscd_id In
                (
                    Select
                        rod.oscd_id
                    From
                        rap_osc_detail                     rod, rap_osc_master rom
                    Where
                        rom.oscm_id     = rod.oscm_id
                        And rom.oscm_id = Trim(p_oscm_id)
                        And rod.costcode Not In (
                            Select
                                costcode
                            From
                                rap_gtt_osc_detail
                            Where
                                oscm_id = Trim(p_oscm_id)
                        )
                );

            Delete
                From rap_osc_detail
            Where
                costcode Not In
                (
                    Select
                        costcode
                    From
                        rap_gtt_osc_detail
                    Where
                        oscm_id = Trim(p_oscm_id)
                )
                And oscm_id = Trim(p_oscm_id);
            --End : Delete costcodes 
            Delete
                From rap_gtt_osc_detail
            Where
                oscm_id = Trim(p_oscm_id);

        Else
            Update
                rap_osc_master
            Set
                po_number = Trim(p_po_number),
                cur_po_amt = p_cur_po_amt,
                modified_by = v_empno,
                modified_on = sysdate
            Where
                oscm_id = Trim(p_oscm_id);
        End If;

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_po;

    Procedure sp_delete_po(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno    Varchar2(5);
        v_oscm_id  Varchar2(10);
        v_costcode Char(4);
        n_count    Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From rap_osc_ses
        Where
            oscm_id = Trim(p_oscm_id);

        Delete
            From rap_osc_hours
        Where
            oscd_id In
            (
                Select
                    rod.oscd_id
                From
                    rap_osc_detail                     rod, rap_osc_master rom
                Where
                    rom.oscm_id     = rod.oscm_id
                    And rom.oscm_id = Trim(p_oscm_id)
            );

        Delete
            From rap_osc_detail
        Where
            oscm_id = Trim(p_oscm_id);

        Delete
            From rap_osc_master
        Where
            oscm_id = Trim(p_oscm_id);

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_po;

    Procedure sp_lock_po(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_oscm_id          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno    Varchar2(5);
        v_oscm_id  Varchar2(10);
        v_costcode Char(4);
        n_count    Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            rap_osc_master
        Set
            lock_orig_budget = 1
        Where
            oscm_id = p_oscm_id;

        Commit;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_lock_po;

End pkg_rap_osc_master;
/
Grant Execute On "TIMECURR"."PKG_RAP_OSC_MASTER" To "TCMPL_APP_CONFIG";