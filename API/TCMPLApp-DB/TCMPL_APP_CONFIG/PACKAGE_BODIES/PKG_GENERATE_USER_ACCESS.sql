Create Or Replace Package Body tcmpl_app_config.pkg_generate_user_access As

    Procedure sp_gen_access_for_desk_book_user
    As
        v_exists       Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_module_id    Varchar2(5) := 'M20';
        v_role_id      Varchar2(5) := 'R103';
        v_module_role  Varchar2(7) := 'M20R103';
        v_action_id    Varchar2(4) := 'A222';
        v_empno        Varchar2(5);
    Begin

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = v_module_id
            And role_id = v_role_id;

        Insert Into sec_module_users_roles_actions
        (
            module_id,
            role_id,
            action_id,
            empno
        )
        With
            emp As(
                Select
                    empno
                From
                    vu_emplmast
                Where
                    status = 1
            )
        Select
            module_id,
            role_id,
            action_id,
            empno
        From
            (
                Select
                    empno,
                    tcmpl_hr.pkg_common.fn_get_emp_office_location(
                        empno, sysdate
                    ) As office_location_code
                From
                    emp
                Union
                Select
                    empno,
                    office_location_code
                From
                    desk_book.db_map_emp_location
                Where
                    empno In (
                        Select
                            empno
                        From
                            emp
                    )
            )                       a,
            sec_module_role_actions mra
        Where
            a.office_location_code In (
                Select
                    office_location_code
                From
                    dms.dm_offices
                Where
                    smart_desk_booking_enabled = ok
            )
            And mra.module_id = v_module_id
            And mra.role_id   = v_role_id;

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = v_module_id -- M20
            And role_id = v_role_id --R103
            And empno In (
                Select
                    a.empno
                From
                    dms.dm_usermaster a,
                    dms.dm_deskmaster b
                Where
                    Trim(a.deskid) = Trim(b.deskid)
                    And b.office   = 'MOC4'
                    And Trim(a.deskid) In (
                        Select
                            Trim(deskid)
                        From
                            dms.dm_deskallocation
                        Where
                            assetid Like 'IT087PC%'
                    )
            );

        Commit;
    End;

    Procedure sp_gen_access_for_ofb_user(
        p_empno Varchar2 Default Null
    ) As
        c_role_tcmpl_user Constant Varchar2(4) := 'R001';
        c_module_ofb      Constant Varchar2(3) := 'M02';
        v_count           Number;
    Begin
        If p_empno Is Not Null Then
            Select
                Count(*)
            Into
                v_count
            From
                tcmpl_hr.ofb_emp_exits a,
                vu_emplmast            e
            Where
                a.empno      = p_empno
                And a.empno  = e.empno
                And e.status = 1;
            If v_count = 0 Then
                Return;
            End If;
            Delete sec_module_users_roles_actions
            Where
                empno         = p_empno
                And role_id   = c_role_tcmpl_user
                And module_id = c_module_ofb;
            Insert Into sec_module_users_roles_actions(
                module_id, empno, role_id, action_id
            )
            Select
                module_id, p_empno, role_id, action_id
            From
                sec_module_role_actions
            Where
                module_id   = c_module_ofb
                And role_id = c_role_tcmpl_user;
            Return;
        End If;
    End;

    Procedure prc_gen_access_for_ofb_alluser As
        c_role_tcmpl_user Constant Varchar2(4) := 'R001';
        c_module_ofb      Constant Varchar2(3) := 'M02';
        v_count           Number;
    Begin

        Delete sec_module_users_roles_actions
        Where
            role_id       = c_role_tcmpl_user
            And module_id = c_module_ofb;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )
        Select
            module_id, empno, role_id, action_id
        From
            sec_module_role_actions a,
            tcmpl_hr.ofb_emp_exits  b
        Where
            module_id   = c_module_ofb
            And role_id = c_role_tcmpl_user
            And b.empno In (
                Select
                    empno
                From
                    vu_emplmast
                Where
                    status = 1
            );

    End;

    Procedure sp_jobmaster_generate_access As
        c_module_jobmaster Constant Varchar2(3) := 'M09';
    Begin
        --Delete existing
        Delete
            From sec_module_user_roles
        Where
            module_id = c_module_jobmaster
            And role_id In (
                Select
                    app_config_role_id
                From
                    timecurr.job_responsible_roles_mst rm
                Where
                    app_config_role_id Is Not Null
            );
        --Insert default roles
        Insert Into sec_module_user_roles(module_id, empno, role_id)
        Select
        Distinct

            c_module_jobmaster,
            rd.empno,
            rm.app_config_role_id
        From
            timecurr.job_responsible_roles_defaults rd,
            timecurr.job_responsible_roles_mst      rm
        Where
            rd.job_responsible_role_id = rm.job_responsible_role_id
            And (rd.empno, rm.app_config_role_id) Not In (
                Select
                    empno, role_id
                From
                    sec_module_user_roles
                Where
                    module_id = c_module_jobmaster

            );
        -- insert project roles
        Insert Into sec_module_user_roles(module_id, empno, role_id)
        Select
        Distinct
            c_module_jobmaster,
            empno,
            app_config_role_id
        From
            timecurr.job_responsible_roles     rr,
            timecurr.job_responsible_roles_mst rm
        Where
            rr.job_responsible_role_id = rm.job_responsible_role_id
            And rm.app_config_role_id Is Not Null
            And rr.empno Is Not Null
            And (rr.empno, rm.app_config_role_id) Not In (
                Select
                    empno, role_id
                From
                    sec_module_user_roles
                Where
                    module_id = c_module_jobmaster
            );
        --delete left employees
        Delete
            From sec_module_user_roles
        Where
            empno Not In (
                Select
                    empno
                From
                    vu_emplmast
                Where
                    status = 1
            );

        --on behalf start
        Delete
            From sec_module_users_roles_actions
        Where
            role_id In (app_constants.role_id_onbehalf_erp_pm,
                app_constants.role_id_onbehalf_js,
                app_constants.role_id_onbehalf_md,
                app_constants.role_id_onbehalf_afc)
            And module_id = app_constants.mod_id_job_master;

        --ERP PM & JS
        Insert Into sec_module_users_roles_actions
        (
            module_id,
            empno,
            role_id,
            action_id
        )
        Select
        Distinct
            app_constants.mod_id_job_master,
            smd.on_behalf_empno,
            jrrm.app_config_on_behalf_role_id,
            smra.action_id
        From
            sec_module_delegate                smd,
            sec_module_role_actions            smra,
            timecurr.job_responsible_roles     jrr,
            timecurr.job_responsible_roles_mst jrrm
        Where
            smd.module_id                   = smra.module_id
            And smra.role_id                = jrrm.app_config_on_behalf_role_id
            And smd.principal_empno         = jrr.empno
            And jrr.job_responsible_role_id = jrrm.job_responsible_role_id
            And smd.module_id               = app_constants.mod_id_job_master
            And jrrm.job_responsible_role_id In ('R01', 'R02');

        --MD & AFC
        Insert Into sec_module_users_roles_actions(
            module_id,
            empno,
            role_id,
            action_id
        )
        Select
        Distinct app_constants.mod_id_job_master,
            smd.on_behalf_empno,
            jrrm.app_config_on_behalf_role_id,
            smra.action_id
        From
            sec_module_delegate                     smd,
            sec_module_role_actions                 smra,
            timecurr.job_responsible_roles_defaults jrrd,
            timecurr.job_responsible_roles_mst      jrrm
        Where
            smd.module_id                    = smra.module_id
            And smra.role_id                 = jrrm.app_config_on_behalf_role_id
            And smd.principal_empno          = jrrd.empno
            And jrrd.job_responsible_role_id = jrrm.job_responsible_role_id
            And smd.module_id                = app_constants.mod_id_job_master
            And jrrm.job_responsible_role_id In ('R10', 'R11');

        --on behalf end
    End;

    --Generate access rights for SWP Primary WorkSpace Planning
    Procedure swp_pws_planning_access As
        c_swp_module_id   Varchar2(3);
        c_swp_hod_role_id Varchar2(4);
        c_swp_sec_role_id Varchar2(4);
    Begin
        c_swp_module_id   := app_constants.mod_id_swp;
        c_swp_hod_role_id := app_constants.role_id_hod;
        c_swp_sec_role_id := app_constants.role_id_secretary;
        --HOD access

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )
        With
            hod_4_pws As(
                Select
                    hod
                From
                    vu_costmast
                Where
                    noofemps > 0
                    And costcode Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
            )
        Select
        Distinct
            module_id, hod.hod empno, role_id, action_id
        From
            sec_module_role_actions mra,
            hod_4_pws               hod
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_role_id;

        --SECRETARY Access
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )
        With
            sec_4_pws As(
                Select
                    empno
                From
                    selfservice.ss_user_dept_rights
                Where
                    parent Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
                    And parent In
                    (
                        Select
                            costcode
                        From
                            vu_costmast
                        Where
                            noofemps > 0
                    )
            )
        Select
        Distinct
            module_id, sec.empno empno, role_id, action_id
        From
            sec_module_role_actions mra,
            sec_4_pws               sec
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_role_id;
    End;

    Procedure swp_ows_sws_planning_access As
        c_swp_module_id             Varchar2(3);
        c_swp_hod_seat_plan_role_id Varchar2(4) := 'R029';
        c_swp_sec_seat_plan_role_id Varchar2(4) := 'R030';

    Begin
        c_swp_module_id := app_constants.mod_id_swp;
        --HOD SEAT PLAN access

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_seat_plan_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )

        With
            hod_4_seat_plan As(
                Select
                    hod
                From
                    vu_costmast
                Where
                    noofemps > 0
                    And costcode Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
                    And costcode In (
                        Select
                            assign
                        From
                            selfservice.swp_include_assign_4_seat_plan
                    )
            )
        Select
        Distinct
            module_id, hod.hod empno, role_id, action_id
        From
            sec_module_role_actions mra,
            hod_4_seat_plan         hod
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_hod_seat_plan_role_id;

        --SECRETARY Access
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_seat_plan_role_id;

        Insert Into sec_module_users_roles_actions(
            module_id, empno, role_id, action_id
        )
        With
            sec_4_seat_plan As(
                Select
                    empno
                From
                    selfservice.ss_user_dept_rights
                Where
                    parent Not In(
                        Select
                            assign
                        From
                            selfservice.swp_exclude_assign
                    )
                    And parent In
                    (
                        Select
                            costcode
                        From
                            vu_costmast
                        Where
                            noofemps > 0
                            And costcode In (
                                Select
                                    assign
                                From
                                    selfservice.swp_include_assign_4_seat_plan
                            )
                    )
            )
        Select
        Distinct
            module_id, sec.empno empno, role_id, action_id
        From
            sec_module_role_actions mra,
            sec_4_seat_plan         sec
        Where
            module_id   = c_swp_module_id
            And role_id = c_swp_sec_seat_plan_role_id;
    End;

    Procedure sp_rap_proj_mngr_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R022';

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, prjmngr empno, ra.role_id, ra.action_id
        From
            timecurr.projmast       p,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R022' --Project Manager
            And e.empno  = p.prjmngr
            And e.status = 1;
    End;

    Procedure sp_rap_proj_rpt_access As
    Begin

        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R021';

        --Job Incharge
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, p.prjdymngr, ra.role_id, ra.action_id
        From
            timecurr.projmast       p,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            ra.module_id   = 'M07'
            And ra.role_id = 'R021'
            And e.empno    = p.prjdymngr
            And e.status   = 1;

        --Project Secretary
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, prjoper empno, ra.role_id, ra.action_id
        From
            timecurr.projmast       p,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R021' --Project REPORTS
            And e.empno  = p.prjoper
            And e.status = 1;

    End;

    Procedure sp_rap_sec_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R003';

        --DEPT Secretary
        /*
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, rs.empno, ra.role_id, ra.action_id
        From
            timecurr.rap_secretary  rs,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R003'
            And e.empno  = rs.empno
            And e.status = 1;
        */
    End;

    Procedure sp_rap_sec_focal_point_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R023';

        --DEPT Secretary
        /*
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, rh.empno, ra.role_id, ra.action_id
        From
            timecurr.rap_hod        rh,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R023'
            And e.empno  = rh.empno
            And e.status = 1;

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, rh.empno, ra.role_id, ra.action_id
        From
            timecurr.rap_dyhod      rh,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R023'
            And e.empno  = rh.empno
            And e.status = 1;
        */
    End;

    Procedure sp_rap_hod_access As
    Begin
        --HoD
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R002';

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, cc.hod, ra.role_id, ra.action_id
        From
            vu_costmast             cc,
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id    = 'M07'
            And role_id  = 'R002'
            And e.empno  = cc.hod
            And e.status = 1
            And cc.costcode Like '02%';

    End;

    Procedure sp_rap_director_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M07'
            And role_id = 'R028';

        --Director
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, e.empno, ra.role_id, ra.action_id
        From
            sec_module_role_actions ra,
            vu_emplmast             e
        Where
            module_id      = 'M07'
            And role_id    = 'R028'
            And e.status   = 1
            And e.director = 1;

    End;

    Procedure sp_ts_sec_access As
    Begin
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M10'
            And role_id = 'R038';

        --DEPT Secretary
        /*
        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, ts.empno, ra.role_id, ra.action_id
        From
            timecurr.time_secretary  ts,
            sec_module_role_actions ra,
            vu_emplmast             e,
            timecurr.emptypemast    etm
        Where
            ra.module_id     = 'M10'
            And ra.role_id   = 'R038'
            And e.empno   = ts.empno
            And e.emptype = etm.emptype
            And etm.tm    = 1
            And e.status  = 1;
        */

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, c.secretary, ra.role_id, ra.action_id
        From
            timecurr.costmast       c,
            sec_module_role_actions ra,
            vu_emplmast             e,
            timecurr.emptypemast    etm
        Where
            ra.module_id   = 'M10'
            And ra.role_id = 'R038'
            And e.empno    = c.secretary
            And e.emptype  = etm.emptype
            And etm.tm     = 1
            And e.status   = 1;

    End;

    Procedure sp_ts_hod_access As
    Begin
        --HoD
        Delete
            From sec_module_users_roles_actions
        Where
            module_id   = 'M10'
            And role_id = 'R037';

        Insert Into sec_module_users_roles_actions(module_id, empno, role_id, action_id)
        Select
        Distinct ra.module_id, cc.hod, ra.role_id, ra.action_id
        From
            vu_costmast             cc,
            sec_module_role_actions ra,
            vu_emplmast             e,
            timecurr.emptypemast    etm
        Where
            module_id     = 'M10'
            And role_id   = 'R037'
            And e.empno   = cc.hod
            And e.emptype = etm.emptype
            And etm.tm    = 1
            And e.status  = 1;

    End;

    Procedure sp_generate1 As
        v_key_id             Varchar2(8);
        v_disable_constraint Varchar2(200) := 'Alter Table sec_module_users_roles_actions disable Constraint sec_module_users_roles_act_pk';
        v_enable_constraint  Varchar2(200) := 'Alter Table sec_module_users_roles_actions enable Constraint sec_module_users_roles_act_pk';
    Begin
        v_key_id := dbms_random.string('X', 8);

        --DISABLE CONSTRAINT
        Execute Immediate v_disable_constraint;

        -- PRIMARY Workspace planning
        Begin
            /***************************/
            /*                         */
            swp_pws_planning_access;
            /*                         */
            /***************************/

            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.swp_pws_planning_access',
                p_business_name => 'Generate SWP PWS Planning access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.swp_pws_planning_access',
                    p_business_name => 'Generate SWP PWS Planning access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --SWP DESK / OWS - SWS desk planning
        Begin
            /***************************/
            /*                         */
            swp_ows_sws_planning_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.swp_ows_sws_planning_access',
                p_business_name => 'Generate SWP OWS-SWS Desk Planning access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.swp_ows_sws_planning_access',
                    p_business_name => 'Generate SWP OWS-SWS Desk Planning access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting PROJECT Manager Access
        Begin
            /***************************/
            /*                         */
            sp_rap_proj_mngr_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_proj_mngr_access',
                p_business_name => 'Generate RAPReporting PROJ MNGR access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_proj_mngr_access',
                    p_business_name => 'Generate RAPReporting PROJ MNGR access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting PROJECT REPORTING Access
        Begin
            /***************************/
            /*                         */
            sp_rap_proj_rpt_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_proj_rpt_access',
                p_business_name => 'Generate RAPReporting PROJ REPORTING access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_proj_rpt_access',
                    p_business_name => 'Generate RAPReporting PROJ REPORTING access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting SECRETARY Access
        Begin
            /***************************/
            /*                         */
            sp_rap_sec_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_sec_access',
                p_business_name => 'Generate RAPReporting Secertary access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_sec_access',
                    p_business_name => 'Generate RAPReporting Secertary access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting Secretary FOCAL Point Access
        Begin
            /***************************/
            /*                         */
            sp_rap_sec_focal_point_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_sec_focal_point_access',
                p_business_name => 'Generate RAPReporting Secertary FOCAL Point access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_sec_access',
                    p_business_name => 'Generate RAPReporting Secertary access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting HoD Access
        Begin
            /***************************/
            /*                         */
            sp_rap_hod_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_hod_access',
                p_business_name => 'Generate RAPReporting HoD access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_hod_access',
                    p_business_name => 'Generate RAPReporting HoD access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --RAP Reporting Director Access
        Begin
            /***************************/
            /*                         */
            sp_rap_director_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_rap_director_access',
                p_business_name => 'Generate RAPReporting Director access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_rap_director_access',
                    p_business_name => 'Generate RAPReporting Director access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --JOB Master Form
        Begin
            /***************************/
            /*                         */
            sp_jobmaster_generate_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_jobmaster_generate_access',
                p_business_name => 'Generate JOB Master Roles'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_jobmaster_generate_access',
                    p_business_name => 'Generate JOB Master Roles',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --Timesheet SECRETARY Access
        Begin
            /***************************/
            /*                         */
            sp_ts_sec_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_ts_sec_access',
                p_business_name => 'Generate Timesheet Secertary access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_ts_sec_access',
                    p_business_name => 'Generate Timesheet Secertary access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        --Timesheet HoD Access
        Begin
            /***************************/
            /*                         */
            sp_ts_hod_access;
            /*                         */
            /***************************/
            task_scheduler.sp_log_success(
                p_proc_name     => 'tcmpl_app.config.sp_ts_hod_access',
                p_business_name => 'Generate Timesheet HoD access'
            );
        Exception
            When Others Then
                task_scheduler.sp_log_failure(
                    p_proc_name     => 'tcmpl_app.config.sp_ts_hod_access',
                    p_business_name => 'Generate Timesheet HoD access',
                    p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
                );
        End;

        Delete
            From sec_module_users_roles_actions
        Where
            Rowid Not In (
                Select
                    Max(Rowid)
                From
                    sec_module_users_roles_actions
                Group By
                    module_id,
                    empno,
                    role_id,
                    action_id
            );
        --DISABLE CONSTRAINT
        Execute Immediate v_enable_constraint;
    End;

    Procedure prc_auto_generate_user_access As
        Type rec_obj_proc Is Record(
                proc_name Varchar2(200),
                proc_desc Varchar2(200)
            );
        Type typ_tab_proc_list Is Table Of rec_obj_proc;

        tab_proc_list typ_tab_proc_list := typ_tab_proc_list(
                rec_obj_proc(
                    proc_name => 'pkg_generate_user_access.sp_gen_access_for_desk_book_user',
                    proc_desc => 'Generate DESK BOOk Roles'
                ),
                rec_obj_proc(
                    proc_name => 'pkg_generate_user_access.sp_jobmaster_generate_access',
                    proc_desc => 'Generate JOB Master Roles'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.prc_gen_access_for_ofb_alluser',
                    proc_desc => 'Generate OFB user access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.swp_pws_planning_access',
                    proc_desc => 'Generate SWP PWS Planning access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.swp_ows_sws_planning_access',
                    proc_desc => 'Generate SWP OWS-SWS Desk Planning access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_rap_proj_mngr_access',
                    proc_desc => 'Generate RAPReporting PROJ MNGR access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_rap_proj_rpt_access',
                    proc_desc => 'Generate RAPReporting PROJ REPORTING access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_rap_sec_access',
                    proc_desc => 'Generate RAPReporting Secertary access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_rap_sec_focal_point_access',
                    proc_desc => 'Generate RAPReporting Secertary FOCAL Point access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_rap_hod_access',
                    proc_desc => 'Generate RAPReporting HoD access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_rap_director_access',
                    proc_desc => 'Generate RAPReporting Director access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_ts_sec_access',
                    proc_desc => 'Generate Timesheet Secertary access'
                ),
                rec_obj_proc(
                    proc_name => 'PKG_GENERATE_USER_ACCESS.sp_ts_hod_access',
                    proc_desc => 'Generate Timesheet HoD access'
                )
            );
        c_plsql_block Varchar2(1000)    := 'begin  !PROC_NAME!; :p_ok := ok; exception when others then :p_ko := ''Err - ''  || sqlcode || '' - '' || sqlerrm; end;';
        v_ret_ok      Varchar2(10);
        v_ret_ko      Varchar2(1000);
        v_plsql_block Varchar2(1000);
    Begin
        For i In 1..tab_proc_list.count
        Loop
            v_ret_ok      := Null;
            v_ret_ko      := Null;
            v_plsql_block := replace(c_plsql_block, '!PROC_NAME!', tab_proc_list(i).proc_name);
            Execute Immediate v_plsql_block Using Out v_ret_ok, Out v_ret_ko;
            If v_ret_ok = ok Then
                task_scheduler.sp_log_success(
                    p_proc_name     => upper('tcmpl_app_config.' || tab_proc_list(i).proc_name),
                    p_business_name => tab_proc_list(i).proc_desc
                );
            Else
                task_scheduler.sp_log_failure(
                    p_proc_name     => upper('tcmpl_app_config.' || tab_proc_list(i).proc_name),
                    p_business_name => tab_proc_list(i).proc_desc,
                    p_message       => v_ret_ko
                );
            End If;

        End Loop;
    End;

    Procedure sp_generate As
        v_key_id             Varchar2(8);
        v_disable_constraint Varchar2(200) := 'Alter Table sec_module_users_roles_actions disable Constraint sec_module_users_roles_act_pk';
        v_enable_constraint  Varchar2(200) := 'Alter Table sec_module_users_roles_actions enable Constraint sec_module_users_roles_act_pk';
    Begin
        v_key_id := dbms_random.string('X', 8);

        --DISABLE CONSTRAINT
        Execute Immediate v_disable_constraint;

        prc_auto_generate_user_access;

        --
        Delete
            From sec_module_users_roles_actions
        Where
            Rowid Not In (
                Select
                    Max(Rowid)
                From
                    sec_module_users_roles_actions
                Group By
                    module_id,
                    empno,
                    role_id,
                    action_id
            );
        --DISABLE CONSTRAINT
        Execute Immediate v_enable_constraint;
    End;

End pkg_generate_user_access;
/