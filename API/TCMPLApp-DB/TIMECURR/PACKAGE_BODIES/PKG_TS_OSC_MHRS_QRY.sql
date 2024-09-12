Create Or Replace Package Body "TIMECURR"."PKG_TS_OSC_MHRS_QRY" As

    c_action_id Constant Char(4) := 'A134';

    Function fn_osc_mhrs_master_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_yymm           Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        tomm.oscm_id,
                        tomm.empno                                       As empno,
                        initcap(e.name)                                  emp_name,
                        tomm.parent,
                        c.name                                           parent_name,
                        tomm.assign,
                        c1.name                                          assign_name,
                        tomm.hours,
                        tomm.is_lock,
                        Case is_lock
                            When 'OK' Then
                                'Locked'
                            When 'KO' Then
                                'Not locked'
                        End                                              is_lock_status,
                        Case is_lock
                            When 'OK' Then
                                'KO'
                            When 'KO' Then
                                'OK'
                        End                                              is_lock_enable,
                        Case is_hod_approve
                            When 'OK' Then
                                'KO'
                            When 'KO' Then
                                is_lock
                        End                                              is_unlock_enable,
                        tomm.is_hod_approve,
                        Case is_hod_approve
                            When 'OK' Then
                                'Approved'
                            When 'KO' Then
                                'Not approved'
                        End                                              is_hod_approve_status,
                        Case is_lock
                            When 'OK' Then
                                Case is_hod_approve
                                    When 'KO' Then
                                        'OK'
                                    Else
                                        'KO'
                                End
                            When 'KO' Then
                                'KO'
                        End                                              is_hod_approve_enable,
                        Case is_post
                            When 'OK' Then
                                'KO'
                            When 'KO' Then
                                is_hod_approve
                        End                                              is_hod_disapprove_enable,
                        tomm.is_post,
                        Case is_post
                            When 'OK' Then
                                'Posted'
                            When 'KO' Then
                                'Not posted'
                        End                                              is_post_status,
                        Case is_hod_approve
                            When 'OK' Then
                                Case is_post
                                    When 'KO' Then
                                        'OK'
                                    Else
                                        'KO'
                                End
                            When 'KO' Then
                                'KO'
                        End                                              is_post_enable,
                        is_post                                          is_unpost_enable,
                        fn_check_processing_month(p_person_id => p_person_id,
                                                  p_meta_id   => p_meta_id,
                                                  p_yymm      => p_yymm) is_editable,
                        Row_Number() Over(Order By e.empno)              row_number,
                        Count(*) Over()                                  total_row
                    From
                        ts_osc_mhrs_master tomm,
                        emplmast           e,
                        costmast           c,
                        costmast           c1,
                        emptypemast        etm,
                        deptphase          dp
                    Where
                        e.empno          = tomm.empno
                        And c.costcode   = tomm.parent
                        And c1.costcode  = tomm.assign
                        And e.emptype    = etm.emptype
                        --And etm.tm       = 1
                        And e.assign     = dp.costcode
                        And dp.isprimary = 1
                        And (tomm.assign In (
                                Select
                                    costcode
                                From
                                    costmast
                                Where
                                    hod          = Trim(v_empno)
                                    Or secretary = Trim(v_empno)
                                Union All
                                Select
                                    costcode
                                From
                                    time_secretary
                                Where
                                    empno = Trim(v_empno)
                            )
                            Or (e.empno  = Trim(v_empno)
                                Or e.do  = Trim(v_empno)))
                        And tomm.yymm    = Trim(p_yymm)
                        And (upper(tomm.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(e.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(tomm.assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(c1.name) Like '%' || upper(Trim(p_generic_search)))
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_osc_mhrs_master_list;

    Function fn_osc_mhrs_detail_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_yymm           Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        tomm.oscm_id,
                        tomd.oscd_id,
                        tomm.empno                                       As empno,
                        initcap(e.name)                                  emp_name,
                        tomm.empno || ' ' || initcap(e.name)             empno_with_name,
                        tomm.assign,
                        c.name                                           assign_name,
                        tomm.assign || ' ' || c.name                     assign_with_name,
                        tomd.projno                                      projno,
                        p.name                                           projno_name,
                        tomd.projno || ' ' || p.name                     projno_with_name,
                        tomd.wpcode,
                        tw.wpdesc                                        wpcode_name,
                        tomd.wpcode || ' ' || tw.wpdesc                  wpcode_with_name,
                        tomd.activity,
                        am.name                                          activity_name,
                        tomd.activity || ' ' || am.name                  activity_with_name,
                        tomd.hours,
                        Case is_lock
                            When 'OK' Then
                                'KO'
                            When 'KO' Then
                                'OK'
                        End                                              can_edit_delete,
                        fn_check_processing_month(p_person_id => p_person_id,
                                                  p_meta_id   => p_meta_id,
                                                  p_yymm      => p_yymm) is_editable,
                        Row_Number() Over(Order By e.empno)              row_number,
                        Count(*) Over()                                  total_row
                    From
                        ts_osc_mhrs_master tomm,
                        ts_osc_mhrs_detail tomd,
                        emplmast           e,
                        projmast           p,
                        act_mast           am,
                        time_wpcode        tw,
                        emptypemast        etm,
                        deptphase          dp,
                        costmast           c
                    Where
                        tomm.oscm_id     = tomd.oscm_id
                        And e.empno      = tomm.empno
                        And c.costcode   = tomm.assign
                        And tomd.projno  = p.projno
                        And am.costcode  = tomm.assign
                        And am.activity  = tomd.activity
                        And tw.wpcode    = tomd.wpcode
                        And e.emptype    = etm.emptype
                        --And etm.tm       = 1
                        And e.assign     = dp.costcode
                        And dp.isprimary = 1
                        And (tomm.assign In (
                                Select
                                    costcode
                                From
                                    costmast
                                Where
                                    hod          = Trim(v_empno)
                                    Or secretary = Trim(v_empno)
                                Union All
                                Select
                                    costcode
                                From
                                    time_secretary
                                Where
                                    empno = Trim(v_empno)
                            )
                            Or (e.empno  = Trim(v_empno)
                                Or e.do  = Trim(v_empno)))
                        And tomm.yymm    = Trim(p_yymm)
                        And (upper(tomm.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(e.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(tomd.projno) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(p.name) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(tomd.wpcode) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(tw.wpdesc) Like '%' || upper(Trim(p_generic_search))
                            Or upper(tomd.activity) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(am.name) Like '%' || upper(Trim(p_generic_search)))
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_osc_mhrs_detail_list;

    Procedure sp_osc_mhrs_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_oscd_id              Varchar2,
        p_oscm_id          Out Varchar2,
        p_yymm             Out Varchar2,
        p_parent           Out Varchar2,
        p_parent_name      Out Varchar2,
        p_parent_with_name Out Varchar2,
        p_assign           Out Varchar2,
        p_assign_name      Out Varchar2,
        p_assign_with_name Out Varchar2,
        p_empno            Out Varchar2,
        p_empno_name       Out Varchar2,
        p_empno_with_name  Out Varchar2,
        p_projno           Out Varchar2,
        p_wpcode           Out Varchar2,
        p_activity         Out Varchar2,
        p_hours            Out Number,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As

        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            tomm.oscm_id,
            tomm.yymm,
            tomm.parent,
            c.name                               parent_name,
            tomm.parent || ' ' || c.name         parent_with_name,
            tomm.assign,
            c1.name                              assign_name,
            tomm.assign || ' ' || c1.name        assign_with_name,
            tomm.empno                           As empno,
            initcap(e.name)                      emp_name,
            tomm.empno || ' ' || initcap(e.name) empno_with_name,
            tomd.projno                          projno,
            tomd.wpcode,
            tomd.activity,
            tomd.hours
        Into
            p_oscm_id,
            p_yymm,
            p_parent,
            p_parent_name,
            p_parent_with_name,
            p_assign,
            p_assign_name,
            p_assign_with_name,
            p_empno,
            p_empno_name,
            p_empno_with_name,
            p_projno,
            p_wpcode,
            p_activity,
            p_hours
        From
            ts_osc_mhrs_master tomm,
            ts_osc_mhrs_detail tomd,
            emplmast           e,
            emptypemast        etm,
            deptphase          dp,
            costmast           c,
            costmast           c1
        Where
            tomm.oscm_id     = tomd.oscm_id
            And e.empno      = tomm.empno
            And e.emptype    = etm.emptype
            --And etm.tm       = 1
            And e.assign     = dp.costcode
            And dp.isprimary = 1
            And c.costcode   = tomm.parent
            And c1.costcode  = tomm.assign
            And tomd.oscd_id = Trim(p_oscd_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_osc_mhrs_detail;

    Function fn_check_processing_month(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yymm      Varchar2
    ) Return Varchar2 Is
        v_empno      Varchar2(5);
        v_pros_month tsconfig.pros_month%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return not_ok;
        End If;
        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig;

        If To_Number (v_pros_month) != To_Number (p_yymm) Then
            Return not_ok;
        End If;
        Return ok;
    Exception
        When Others Then
            Return not_ok;
    End fn_check_processing_month;

    Procedure sp_check_editable_month(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) Is
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        p_message_type := fn_check_processing_month(p_person_id => p_person_id,
                                                    p_meta_id   => p_meta_id,
                                                    p_yymm      => p_yymm);

        p_message_text := p_message_type;

    End sp_check_editable_month;

    Function fn_osc_mhrs_detail_list_4_xl(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yymm      Varchar2,
        p_action_id Varchar2 Default Null
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_action_id Is Null Then
            Open c For
                Select
                    tomm.empno                           As empno,
                    initcap(e.name)                      emp_name,
                    tomm.empno || ' ' || initcap(e.name) empno_with_name,
                    tomm.assign,
                    c.name                               assign_name,
                    tomm.assign || ' ' || c.name         assign_with_name,
                    tomd.projno                          projno,
                    p.name                               projno_name,
                    tomd.projno || ' ' || p.name         projno_with_name,
                    tomd.wpcode,
                    tw.wpdesc                            wpcode_name,
                    tomd.wpcode || ' ' || tw.wpdesc      wpcode_with_name,
                    tomd.activity,
                    am.name                              activity_name,
                    tomd.activity || ' ' || am.name      activity_with_name,
                    tomd.hours
                From
                    ts_osc_mhrs_master tomm,
                    ts_osc_mhrs_detail tomd,
                    emplmast           e,
                    projmast           p,
                    act_mast           am,
                    time_wpcode        tw,
                    emptypemast        etm,
                    deptphase          dp,
                    costmast           c
                Where
                    tomm.oscm_id     = tomd.oscm_id
                    And e.empno      = tomm.empno
                    And c.costcode   = tomm.assign
                    And tomd.projno  = p.projno
                    And am.costcode  = tomm.assign
                    And am.activity  = tomd.activity
                    And tw.wpcode    = tomd.wpcode
                    And e.emptype    = etm.emptype
                    And e.assign     = dp.costcode
                    And dp.isprimary = 1
                    And (tomm.assign In (
                            Select
                                costcode
                            From
                                costmast
                            Where
                                hod          = Trim(v_empno)
                                Or secretary = Trim(v_empno)
                            Union All
                            Select
                                costcode
                            From
                                time_secretary
                            Where
                                empno = Trim(v_empno)
                        )
                        Or (e.empno  = Trim(v_empno)
                            Or e.do  = Trim(v_empno)))
                    And tomm.yymm    = Trim(p_yymm);
        Elsif p_action_id = c_action_id Then
            Open c For
                Select
                    tomm.empno                           As empno,
                    initcap(e.name)                      emp_name,
                    tomm.empno || ' ' || initcap(e.name) empno_with_name,
                    tomm.assign,
                    c.name                               assign_name,
                    tomm.assign || ' ' || c.name         assign_with_name,
                    tomd.projno                          projno,
                    p.name                               projno_name,
                    tomd.projno || ' ' || p.name         projno_with_name,
                    tomd.wpcode,
                    tw.wpdesc                            wpcode_name,
                    tomd.wpcode || ' ' || tw.wpdesc      wpcode_with_name,
                    tomd.activity,
                    am.name                              activity_name,
                    tomd.activity || ' ' || am.name      activity_with_name,
                    tomd.hours
                From
                    ts_osc_mhrs_master tomm,
                    ts_osc_mhrs_detail tomd,
                    emplmast           e,
                    projmast           p,
                    act_mast           am,
                    time_wpcode        tw,
                    emptypemast        etm,
                    deptphase          dp,
                    costmast           c
                Where
                    tomm.oscm_id     = tomd.oscm_id
                    And e.empno      = tomm.empno
                    And c.costcode   = tomm.assign
                    And tomd.projno  = p.projno
                    And am.costcode  = tomm.assign
                    And am.activity  = tomd.activity
                    And tw.wpcode    = tomd.wpcode
                    And e.emptype    = etm.emptype
                    And e.assign     = dp.costcode
                    And dp.isprimary = 1
                    And tomm.yymm    = Trim(p_yymm);
        Else
            Return Null;
        End If;
        Return c;
    End fn_osc_mhrs_detail_list_4_xl;

End pkg_ts_osc_mhrs_qry;