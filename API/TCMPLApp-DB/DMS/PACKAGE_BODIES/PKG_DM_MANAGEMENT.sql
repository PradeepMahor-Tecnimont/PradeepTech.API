Create Or Replace Package Body dms.pkg_dm_management As

    Procedure sp_remove_airoli_emp_frm_dm_usermaster(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into remove_airoli_emp_frm_dm_usermaster (
            key_id,
            empno,
            deskid,
            costcode,
            dep_flag,
            modified_on,
            modified_by
        )
        (
            Select
                dbms_random.string('X', 10),
                empno,
                deskid,
                costcode,
                dep_flag,
                sysdate,
                v_empno
            From
                dm_usermaster
            Where
                dm_usermaster.empno In (
                    With
                        emp_location As (
                            Select
                                empno, tcmpl_hr.pkg_common.fn_get_emp_office_location(a.empno) As office_location_code
                            From
                                ss_emplmast a
                            Where
                                a.status = 1
                                And a.empno Not In (
                                    Select
                                        empno
                                    From
                                        emp_exclude_from_moc5
                                )
                        )
                    Select
                        el.empno
                    From
                        emp_location                 el, ss_emplmast e, dm_usermaster du,
                        dm_deskmaster dm
                    Where
                        office_location_code = '02'
                        And el.empno         = e.empno
                        And el.empno         = du.empno
                        And e.status         = 1
                        And du.deskid        = dm.deskid
                        And dm.office        = 'MOC4'
                        And dm.work_area != 'A55'
                )
                And deskid In (
                    Select
                        dd.deskid
                    From
                        dms.dm_deskallocation dd,
                        dms.dm_assetcode      da
                    Where
                        da.barcode       = dd.assetid
                        And da.assettype = 'PC'
                )
                And empno Not In (
                    Select
                        empno
                    From
                        desk_book.db_map_emp_location
                )
        );

        Delete
            From dm_usermaster
        Where
            dm_usermaster.empno In (
                With
                    emp_location As (
                        Select
                            empno, tcmpl_hr.pkg_common.fn_get_emp_office_location(a.empno) As office_location_code
                        From
                            ss_emplmast a
                        Where
                            a.status = 1
                            And a.empno Not In (
                                Select
                                    empno
                                From
                                    emp_exclude_from_moc5
                            )
                    )
                Select
                    el.empno
                From
                    emp_location                 el, ss_emplmast e, dm_usermaster du,
                    dm_deskmaster dm
                Where
                    office_location_code = '02'
                    And el.empno         = e.empno
                    And el.empno         = du.empno
                    And e.status         = 1
                    And du.deskid        = dm.deskid
                    And dm.office        = 'MOC4'
                    And dm.work_area != 'A55'
            )
            And deskid In (
                Select
                    dd.deskid
                From
                    dms.dm_deskallocation dd,
                    dms.dm_assetcode      da
                Where
                    da.barcode       = dd.assetid
                    And da.assettype = 'PC'
            )
            And empno Not In (
                Select
                    empno
                From
                    desk_book.db_map_emp_location
            );

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_remove_airoli_emp_frm_dm_usermaster;

End pkg_dm_management;