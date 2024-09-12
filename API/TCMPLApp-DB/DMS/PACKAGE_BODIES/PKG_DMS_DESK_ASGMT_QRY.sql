--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_ASGMT_QRY
--------------------------------------------------------

Create Or Replace Package Body dms.pkg_dms_desk_asgmt_qry As

    Function fn_assets_on_desk(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                b.assetid   As asset_id,
                a.model     description,
                a.assettype As asset_code,
                a.compname  As asset_name
            From
                dm_vu_asset_list                      a, dm_deskallocation b
            Where
                a.barcode    = b.assetid(+)
                And b.deskid = upper(Trim(p_generic_search));

        Return c;
    End fn_assets_on_desk;

    Function fn_desk_asgmt_employee(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.barcode   As asset_id,
                a.model     description,
                a.assettype As asset_code,
                a.compname  As asset_name
            From
                dm_vu_asset_list     a,
                inv_emp_item_mapping b
            Where
                a.barcode   = b.item_id
                And b.empno = upper(Trim(p_generic_search));

        Return c;
    End fn_desk_asgmt_employee;

    Procedure sp_desk_asgmt_master_details(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_generic_search     Varchar2,

        p_emp1           Out Varchar2,
        p_emp2           Out Varchar2,
        p_deskno         Out Varchar2,
        p_cabin_desk     Out Varchar2,
        p_office         Out Varchar2,
        p_floor          Out Varchar2,
        p_area           Out Varchar2,
        p_is_blocked     Out Varchar2,
        p_blocked_reason Out Varchar2,

        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        /*
         Select
                    Count(*)
                Into
                    v_count
                From
                    dm_guestmaster a
                Where
                    a.gnum          = upper(Trim(p_generic_search))
                    Or a.targetdesk = upper(Trim(p_generic_search))
                    And a.gnum = (
                        Select
                            b.empno
                        From
                            dm_usermaster b
                        Where
                            b.empno = a.gnum
                    );

                If v_count > 0 Then
                    p_is_blocked   := ok;
                    Select

                        --a.targetdesk target_desk,
                        ok,
                        'Desk booked for guest : ' || a.gnum || ' : ' || a.gname || ', From date (' || a.gfromdate || ' - ' || a.
                        gtodate || ' )'
                    Into
                       -- p_deskno,
                        p_is_blocked,
                        p_blocked_reason
                    From
                        dm_guestmaster                  a, dm_deskmaster b
                    Where
                        a.gnum          = upper(Trim(p_generic_search))
                        Or a.targetdesk = upper(Trim(p_generic_search))
                        And a.gnum = (
                        Select
                            b.empno
                        From
                            dm_usermaster b
                        Where
                            b.empno = a.gnum
                    );

                    p_message_type := 'OK';
                    p_message_text := 'Procedure executed successfully.';
                     return;

                End If;

        */

        Select
            Count(*)
        Into
            v_count
        From
            dm_deskmaster
        Where
            deskid        = upper(Trim(p_generic_search))
            And isblocked = 1;

        If v_count > 0 Then
            p_is_blocked   := ok;
            Select
                deskid || ' : Desk blocked - ' || remarks
            Into
                p_blocked_reason
            From
                dm_deskmaster
            Where
                deskid        = upper(Trim(p_generic_search))
                And isblocked = 1;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

            Return;

        End If;

        Select
            Count(*)
        Into
            v_count
        From
            dm_deskmaster
        Where
            deskid        = upper(Trim(p_generic_search))
            And isdeleted = 1;

        If v_count > 0 Then
            p_is_blocked   := ok;
            Select
                deskid || ' : Desk Deleted - ' || remarks
            Into
                p_blocked_reason
            From
                dm_deskmaster
            Where
                deskid        = upper(Trim(p_generic_search))
                And isdeleted = 1;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

            Return;

        End If;

        Select
            Count(*)
        Into
            v_count
        From
            desmas_allocation
        Where
            empno1    = upper(Trim(p_generic_search))
            Or empno2 = upper(Trim(p_generic_search))
            Or deskid = upper(Trim(p_generic_search));

        If v_count = 1 Then
            Select
                Trim(deskid),
                Trim(empno1),
                Trim(empno2),
                Trim(office),
                Trim(floor),
                Trim(cabin),
                Trim(wing)
            Into
                p_deskno,
                p_emp1,
                p_emp2,
                p_office,
                p_floor,
                p_cabin_desk,
                p_area
            From
                desmas_allocation
            Where
                empno1    = upper(Trim(p_generic_search))
                Or empno2 = upper(Trim(p_generic_search))
                Or deskid = upper(Trim(p_generic_search))
                And deskid Not In (
                    Select
                        deskid
                    From
                        dm_deskmaster
                    Where
                        deskid        = upper(Trim(p_generic_search))
                        And isblocked = 1
                        Or isdeleted  = 1
                );
        Else
            p_is_blocked := ok;
            Select
                a.targetdesk target_desk,
                ok,
                'Desk booked for guest : ' || a.gnum || ' : ' || a.gname || ', From date (' || a.gfromdate || ' - ' || a.
                gtodate || ' )'
            Into
                p_deskno,
                p_is_blocked,
                p_blocked_reason
            From
                dm_guestmaster a
            Where
                a.gnum          = upper(Trim(p_generic_search))
                Or a.targetdesk = upper(Trim(p_generic_search));

        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Err - Data not found.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_desk_asgmt_master_details;

    Procedure sp_dms_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_generic_search       Varchar2,
        p_true_flag        Out Number,
        p_desk_detail_json Out Varchar2, --Json
        p_emp_detail_json  Out Varchar2, --Json

        p_master_list      Out Sys_Refcursor,

        p_desk_assets_list Out Sys_Refcursor,
        p_emp1_assets_list Out Sys_Refcursor,
        p_emp2_assets_list Out Sys_Refcursor,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) Is
        v_count                 Number;
        v_empno                 Varchar2(5);
        item                    Varchar2(5);
        v_empno_search          Varchar2(5);
        v_deskid_search         Varchar2(5);
        v_is_blocked            Varchar2(150);
        v_blocked_reason        Varchar2(150);

        v_item_empno            Varchar2(5);
        v_item_desk             Varchar2(5);
        v_item_user_in          Varchar2(50);

        v_emp_count             Number;
        v_desk_count            Number;
        v_is_valid              Number := 0;

        v_desk_in_dms           Number;
        v_desk_in_desk_bookings Number;
        v_dms_flag              Number := 0;
        v_desk_booking_flag     Number := 0;
        v_cabin_booking_flag    Number := 0;
        v_empty_dms_flag        Number := 0;
        v_true_flag             Number := 0;
        v_deskid                Varchar2(5);
        v_generic_search        Varchar2(5);
        v_master_list_json      Varchar2(5000);
        v_cursor                Sys_Refcursor;
    Begin
        v_empno          := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_generic_search Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Value cannot be null';
            Return;
        End If;

        v_generic_search := upper(trim(p_generic_search));
        ---- DMS Flag---
        Select
            Count(*)
        Into
            v_dms_flag
        From
            dm_usermaster
        Where
            empno     = v_generic_search
            Or deskid = v_generic_search;

        If v_dms_flag > 0 Then
            v_dms_flag := 1;
        End If;

        ---- Desk Booking Flag---
        Select
            Count(*)
        Into
            v_desk_booking_flag
        From
            desk_book.db_desk_bookings
        Where
            trunc(attendance_date) = trunc(sysdate)
            And (empno             = p_generic_search
                Or deskid          = p_generic_search);

        If v_desk_booking_flag > 0 Then
            v_desk_booking_flag := 1;
        End If;

        ---- Cabin Booking Flag---
        Select
            Count(*)
        Into
            v_cabin_booking_flag
        From
            desk_book.db_cabin_bookings
        Where
            trunc(attendance_date) = trunc(sysdate)
            And (empno             = p_generic_search
                Or deskid          = p_generic_search);

        If v_cabin_booking_flag > 0 Then
            v_cabin_booking_flag := 1;
        End If;

        If (v_dms_flag + v_desk_booking_flag + v_cabin_booking_flag) > 1 Then
            v_true_flag := 0;
            p_true_flag := 0;
        Else
            v_true_flag := 1;
            p_true_flag := 1;
        End If;
        Begin
            Select
                Count(deskid)
            Into
                v_desk_in_dms
            From
                dm_usermaster
            Where
                deskid
                In (
                    Select
                        deskid
                    From
                        dm_usermaster
                    Where
                        (empno        = v_generic_search
                            Or deskid = v_generic_search)
                )
            Group By
                deskid;
        Exception
            When Others Then
                v_desk_in_dms := 0;
        End;

        If v_desk_in_dms > 1 And p_true_flag = 1 Then
            Select
            Distinct deskid
            Into
                v_generic_search
            From
                dm_usermaster
            Where
                (empno        = v_generic_search
                    Or deskid = v_generic_search);
        End If;

        Begin
            Select
                Count(deskid)
            Into
                v_desk_in_desk_bookings
            From
                desk_book.db_desk_bookings
            Where
                deskid
                In (
                    Select
                        deskid
                    From
                        desk_book.db_desk_bookings
                    Where
                        (empno        = v_generic_search
                            Or deskid = v_generic_search)
                )
                And trunc(attendance_date) = trunc(sysdate)
            Group By
                deskid;
        Exception
            When Others Then
                v_desk_in_desk_bookings := 0;
        End;

        If v_desk_in_desk_bookings > 1 And p_true_flag = 1 Then
            Select
            Distinct deskid
            Into
                v_generic_search
            From
                desk_book.db_desk_bookings
            Where
                (empno        = v_generic_search
                    Or deskid = v_generic_search)
                And trunc(attendance_date) = trunc(sysdate);
        End If;

        ----Master List

        Select
            Json_Arrayagg(
                Json_Object(
                    'Empno' Value empno,
                    'DeskId' Value deskid,
                    'UserIn' Value user_in
                )
            --Order By empno
            ) js_array
        Into
            v_master_list_json
        From
            (
                Select
                    empno, deskid, user_in
                From
                    (

                        Select
                            empno, deskid, 'Desk Booking' user_in
                        From
                            desk_book.db_desk_bookings
                        Where
                            trunc(attendance_date) = trunc(sysdate)
                        Union
                        Select
                            empno, deskid, 'DMS' user_in
                        From
                            dm_usermaster
                        Union
                        Select
                            empno, deskid, 'Cabin Bookings' user_in
                        From
                            desk_book.db_cabin_bookings
                        Where
                            trunc(attendance_date) = trunc(sysdate)
                        Union
                        Select
                            '' As empno, Trim(upper(p_generic_search)) deskid, '' user_in
                        From
                            dual
                    )
                Where
                    empno     = v_generic_search
                    Or deskid = v_generic_search
            ) t_master_list_json;

        Open v_cursor For
            Select
                empno, deskid, user_in
            From
                (
                    Select
                        a.empno, a.deskid, a.userin As user_in
                    From
                        Json_Table(
                            v_master_list_json,
                            '$[*]' Columns (
                                empno  varchar Path '$.Empno',
                                deskid varchar Path '$.DeskId',
                                userin varchar Path '$.UserIn'
                            )
                        ) a
                )
            Where
                empno     = v_generic_search
                Or deskid = v_generic_search;

        Open p_master_list For
            Select
                empno, deskid, user_in
            From
                (
                    Select
                        a.empno, a.deskid, a.userin As user_in
                    From
                        Json_Table(
                            v_master_list_json,
                            '$[*]' Columns (
                                empno  varchar Path '$.Empno',
                                deskid varchar Path '$.DeskId',
                                userin varchar Path '$.UserIn'
                            )
                        ) a
                    Where
                        a.empno Is Not Null
                        And a.userin Is Not Null
                )
            Where
                empno     = v_generic_search
                Or deskid = v_generic_search;

        ----Employee Header----------------------------------------
        If v_true_flag = 1 Then
            Select
                Json_Arrayagg(
                    Json_Object(
                        'Empno' Value empno,
                        'EmpName' Value name,
                        'Grade' Value grade,
                        'Parent' Value parent,
                        'Assign' Value assign,
                        'DeskId' Value deskid,
                        'UserIn' Value user_in,
                        'Status' Value status
                    )
                ) js_array
            Into
                p_emp_detail_json
            From
                (
                    Select
                        b.empno, b.name, b.grade, b.parent, b.assign, a.deskid, a.user_in, b.status
                    From
                        (
                            Select
                                a.empno, a.deskid, a.userin As user_in
                            From
                                Json_Table(
                                    v_master_list_json,
                                    '$[*]' Columns (
                                        empno  varchar Path '$.Empno',
                                        deskid varchar Path '$.DeskId',
                                        userin varchar Path '$.UserIn'
                                    )
                                ) a
                        )           a,
                        ss_emplmast b
                    Where
                        upper(Trim(a.empno)) In (
                            Select
                                empno
                            From
                                (
                                    Select
                                        a.empno, a.deskid, a.userin As user_in
                                    From
                                        Json_Table(
                                            v_master_list_json,
                                            '$[*]' Columns (
                                                empno  varchar Path '$.Empno',
                                                deskid varchar Path '$.DeskId',
                                                userin varchar Path '$.UserIn'
                                            )
                                        ) a
                                )
                            Where
                                empno     = v_generic_search
                                Or deskid = v_generic_search
                        )
                        And upper(Trim(a.empno)) = b.empno
                --And b.status             = 1
                ) t_employee_header;
        End If;
        -------------------------------------------------------

        ----Desk Header----------------------------------------
        If v_true_flag = 1 Then
            Select
                Json_Arrayagg(
                    Json_Object(
                        'DeskNo' Value deskid,
                        'Office' Value office,
                        'Floor' Value floor,
                        'Seatno' Value seatno,
                        'Wing' Value wing,
                        'CabinDesk' Value cabin,
                        'WorkArea' Value work_area,
                        'AreaDesc' Value area_desc,
                        'IsBlocked' Value isblocked,
                        'IsDeleted' Value isdeleted,
                        'BlockedReason' Value nvl(blocked_reason, '')
                    )
                ) js_array
            Into
                p_desk_detail_json
            From
                (
                    Select
                        a.deskid,
                        a.office,
                        a.floor,
                        a.seatno,
                        a.wing,
                        nvl(a.cabin, 'Desk') As cabin,
                        a.work_area,
                        b.area_desc,
                         ( case a.isblocked when 1 then ok else not_ok end ) As isblocked,
                        ( case a.isdeleted when 1 then ok else not_ok end ) As isdeleted,
                        Case
                            When a.isdeleted = 1 Then
                                deskid || ' : Desk Deleted - ' || a.remarks
                             When a.isblocked = 1 Then
                               deskid || ' : ' ||
                                (Select dm_desklock_reason.description from dm_desklock_reason 
                                    where reasoncode = (
                                        Select dm_desklock.blockreason 
                                        from dm_desklock 
                                        where dm_desklock.deskid = a.deskid 
                                        )
                                )||'. Remarks : '|| a.remarks 
                            Else
                                'NA'
                        End                  As blocked_reason
                    From
                        dm_deskmaster                  a, dm_desk_areas b
                    Where
                        deskid In (
                            Select
                                deskid
                            From
                                (
                                    Select
                                        a.empno, a.deskid, a.userin As user_in
                                    From
                                        Json_Table(
                                            v_master_list_json,
                                            '$[*]' Columns (
                                                empno  varchar Path '$.Empno',
                                                deskid varchar Path '$.DeskId',
                                                userin varchar Path '$.UserIn'
                                            )
                                        ) a
                                )
                            Where
                                upper(Trim(empno))     = upper(Trim(p_generic_search))
                                Or upper(Trim(deskid)) = upper(Trim(p_generic_search))
                        )
                        And a.work_area = b.area_key_id(+)
                ) t_desk_header;
        End If;
        -------------------------------------------------------

        If v_true_flag = 1 Then
            v_count := 0;
            Loop
                Fetch v_cursor Into v_item_empno, v_item_desk, v_item_user_in;
                Exit When v_cursor%notfound;

                v_count := v_count + 1;

                If v_count = 1 Then
                    If v_item_desk Is Not Null Then
                        Open p_desk_assets_list For
                            Select
                                b.assetid   As asset_id,
                                a.model     description,
                                a.assettype As asset_code,
                                a.compname  As asset_name,
                                b.deskid
                            From
                                dm_assetcode      a,
                                dm_deskallocation b
                            Where
                                a.barcode    = b.assetid
                                And b.deskid = upper(Trim(v_item_desk));
                    End If;

                    If v_item_empno Is Not Null Then
                        Open p_emp1_assets_list For
                            Select
                                b.empno,
                                a.barcode   As asset_id,
                                a.model     description,
                                a.assettype As asset_code,
                                a.compname  As asset_name
                            From
                                dm_assetcode         a,
                                inv_emp_item_mapping b
                            Where
                                a.barcode   = b.item_id
                                And b.empno = upper(Trim(v_item_empno));
                    End If;
                End If;

                If v_count = 2 Then
                    If v_item_empno Is Not Null Then
                        Open p_emp2_assets_list For
                            Select
                                b.empno,
                                a.barcode   As asset_id,
                                a.model     description,
                                a.assettype As asset_code,
                                a.compname  As asset_name
                            From
                                dm_assetcode         a,
                                inv_emp_item_mapping b
                            Where
                                a.barcode   = b.item_id
                                And b.empno = upper(Trim(v_item_empno));
                    End If;
                End If;

            End Loop;
        End If;
        p_message_type   := ok;
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End pkg_dms_desk_asgmt_qry;
/
Grant Execute On dms.pkg_dms_desk_asgmt_qry To tcmpl_app_config;