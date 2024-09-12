--------------------------------------------------------
--  File created - Sunday-August-07-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace Constant Number := 1;
    c_smart_workspace Constant Number := 2;
    c_not_in_mum_office Constant Number := 3;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    );

    Procedure sp_smart_ws_weekly_summary(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_assign_code                   Varchar2,
        p_date                          Date,

        p_emp_count_smart_workspace Out Number,
        p_emp_count_mon             Out Number,
        p_emp_count_tue             Out Number,
        p_emp_count_wed             Out Number,
        p_emp_count_thu             Out Number,
        p_emp_count_fri             Out Number,
        p_costcode_desc             Out Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    );

    Procedure sp_sys_assign_sws_desk(
        p_empno            Varchar2,
        p_attendance_date  Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_weekly_attendance(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_date             Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
    Procedure sp_add_weekly_attendance(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_date             Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
End iot_swp_smart_workspace;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list_for_smart(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_desk_list_for_office(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date Default Null,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_dept_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_grade_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4desk_plan(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_emp_list4wp_details(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_swp_type_list(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor;

    Function fn_emp_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_swp_type_list_4_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_exclude_sws_type Varchar2 Default Null
    ) Return Sys_Refcursor;

End iot_swp_select_list_qry;
/
---------------------------
--New PACKAGE
--IOT_SWP_EMPLOYEES_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMPLOYEES_QRY" As

    Function fn_swp_employees(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;
End iot_swp_employees_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    c_qry_office_planning Varchar2(4000) := ' 

With
    params As (
        Select
            :p_person_id      As p_person_id,
            :p_meta_id        As p_meta_id,
            :p_row_number     As p_row_number,
            :p_page_length    As p_page_length,

            :p_assign_code    As p_assign_code,
            :p_emptype_csv    As p_emptype_csv,
            :p_grades_csv     As p_grades_csv,
            :p_generic_search As p_generic_search,
            :p_desk_assignment_status as p_desk_assignment_status
        From
            dual
    ),
    last_status As(
        Select
            empno, Max(start_date) start_date
        From
            swp_primary_workspace
        Group By
            empno
    ),
    primary_ws As (
        Select
            pw.*
        From
            swp_primary_workspace pw, last_status
        Where
            pw.empno                 = last_status.empno
            And pw.start_date        = last_status.start_date
            And pw.primary_workspace = 1
    )
Select
    full_data.*
From
    (
        Select
            data.*,
            Row_Number() Over(Order By planned , employee_name) As row_number,
            Count(*) Over()                   As total_row
        From
            (
                Select
                    base_data.*,
                    case when base_data.deskid is null then 0 else 1 end planned
                From
                    (

                        Select
                            e.empno                                                                         As empno,
                            e.name                                                                          As employee_name,
                            e.parent                                                                        As parent,
                            e.grade                                                                         As emp_grade,
                            iot_swp_common.get_emp_work_area(params.p_person_id, params.p_meta_id, e.empno) As work_area,
                            e.emptype                                                                       As emptype,
                            e.assign                                                                        As assign,
                            iot_swp_common.get_swp_planned_desk(e.empno)                                    As deskid
                        From
                            ss_emplmast e,
                            primary_ws  pws,
                            params
                        Where
                            e.status     = 1
                            And e.empno  = pws.empno

                            And e.assign = params.p_assign_code
                            
                            !GENERIC_SEARCH!            
                            And e.emptype In (
                            !EMPTYPE_SUBQUERY!
                            )
                            !GRADES_SUBQUERY!

                    ) base_data, params
                    !DESK_ASSIGNMENT_STATUS!
            ) data
    ) full_data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length) order by planned, employee_name';

    where_clause_generic_search Varchar2(200) := ' and (e.name like params.p_generic_search or e.empno like params.p_generic_search ) ';

    sub_qry_emptype_default Varchar2(200) := ' 
Select
    emptype
From
    swp_include_emptype
';

    sub_qry_emptype_csv Varchar2(400) := ' 
Select
    regexp_substr(params.p_emptype_csv, ''[^,]+'', 1, level) emptype
From
    dual
Connect By
    level <=
    length(params.p_emptype_csv) - length(replace(params.p_emptype_csv, '','')) + 1
';

    sub_qry_grades_csv Varchar2(400) := ' and e.grade in (
Select
    regexp_substr(params.p_grades_csv, ''[^,]+'', 1, level) grade
From
    dual
Connect By
    level <=
    length(params.p_grades_csv) - length(replace(params.p_grades_csv, '','')) + 1 )
';

    Cursor cur_general_area_list(p_office      Varchar2,
                                 p_floor       Varchar2,
                                 p_wing        Varchar2,
                                 p_row_number  Number,
                                 p_page_length Number) Is

        Select
            *
        From
            (
                Select
                Distinct a.office,
                    a.floor,
                    a.wing,
                    a.work_area,
                    a.area_desc,
                    a.area_catg_code,
                    a.total,
                    a.occupied,
                    a.available,
                    Row_Number() Over (Order By office Desc) As row_number,
                    Count(*) Over ()                         As total_row
                From
                    swp_vu_area_list a
                Where
                    a.area_catg_code = 'A002'
                Order By a.area_desc, a.office, a.floor                 
            /*
             From SWP_VU_AREA_LIST a
              Where a.AREA_CATG_CODE = 'KO'
                And Trim(a.office) = Trim(p_office)
                And Trim(a.floor) = Trim(p_floor)
              Order By a.area_desc, a.office, a.floor
            */
            )
        Where
            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

    Type typ_area_list Is Table Of cur_general_area_list%rowtype;

    Function fn_office_planning(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date,

        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,

        p_row_number             Number,
        p_page_length            Number
    ) Return Sys_Refcursor;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_office      Varchar2 Default Null,
        p_floor       Varchar2 Default Null,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

End iot_swp_office_workspace_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_attendance_for_period(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    Function fn_attendance_for_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    Function fn_attendance_for_prev_day(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

    ) Return Sys_Refcursor;

    Function fn_attendance_for_month(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_yyyymm                  Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    --
    Function fn_week_number_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yyyymm    Varchar2

    ) Return Sys_Refcursor;
End iot_swp_attendance_qry;
/
---------------------------
--Changed PACKAGE BODY
--PRINT_LOG_MIS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PRINT_LOG_MIS" As

    Procedure generate_html As
        l_xmltype     Xmltype;
        lhtmloutput   Xmltype;
        lxsl          Clob;
        lretval       Clob;
        param_success Varchar2(60);
        param_message Varchar2(200);
    Begin
        l_xmltype   := dbms_xmlgen.getxmltype(
                           'select * from 
              (
                  select PARENT, empno, emp_name, USER_NAME, PERIOD, PAGECOUNT
                      from SS_VU_PRINT_LOG_PIVOT where parent=''' || '0106' || '''
               ) 
              pivot (sum(pagecount) for (period) in 
                  (''' ||
                           '201505_B_W' || ''' ,''' || '201505_COLOR' || ''' ,''' || '201504_B_W' || ''',''' || '201504_COLOR' ||
                           ''',
                    ''' || '201503_B_W' || ''',''' || '201503_COLOR' || ''',''' || '201502_B_W' ||
                           ''',''' || '201502_COLOR' || '''))'
                       );

        lxsl        := lxsl || q'[<?xml version="1.0" encoding="ISO-8859-1"?>]';
        lxsl        := lxsl || q'[<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">]';
        lxsl        := lxsl || q'[ <xsl:output method="html"/>]';
        lxsl        := lxsl || q'[ <xsl:template match="/">]';
        lxsl        := lxsl || q'[ <html>]';
        lxsl        := lxsl || q'[  <body>]';
        lxsl        := lxsl || q'[   <table border="1">]';
        lxsl        := lxsl || q'[     <tr bgcolor="Beige">]';
        lxsl        := lxsl || q'[      <xsl:for-each select="/ROWSET/ROW[1]/*">]';
        lxsl        := lxsl || q'[       <th><xsl:value-of select="name()"/></th>]';
        lxsl        := lxsl || q'[      </xsl:for-each>]';
        lxsl        := lxsl || q'[     </tr>]';
        lxsl        := lxsl || q'[     <xsl:for-each select="/ROWSET/*">]';
        lxsl        := lxsl || q'[      <tr>]';
        lxsl        := lxsl || q'[       <xsl:for-each select="./*">]';
        lxsl        := lxsl || q'[        <td><xsl:value-of select="text()"/> </td>]';
        lxsl        := lxsl || q'[       </xsl:for-each>]';
        lxsl        := lxsl || q'[      </tr>]';
        lxsl        := lxsl || q'[     </xsl:for-each>]';
        lxsl        := lxsl || q'[   </table>]';
        lxsl        := lxsl || q'[  </body>]';
        lxsl        := lxsl || q'[ </html>]';
        lxsl        := lxsl || q'[ </xsl:template>]';
        lxsl        := lxsl || q'[</xsl:stylesheet>]';

        -- XSL transformation to convert XML to HTML --
        lhtmloutput := l_xmltype.transform(xmltype(lxsl));
        -- convert XMLType to Clob --
        lretval     := lhtmloutput.getclobval();
        lretval     := replace(lretval, '_x0027_', '');
        ss_mail.send_html_mail('d.bhavsar@ticb.com', 'Print Log', lretval, param_success, param_message);
        dbms_output.put_line(param_success);
        dbms_output.put_line(param_message);
    End generate_html;

    Function get_page_size(param_page_size Varchar2) Return Varchar2 Is
        v_actual_page_size Varchar2(60);
    Begin
        Begin
            Select
                map_paper_size
            Into
                v_actual_page_size
            From
                (
                    Select
                    Distinct map_paper_size
                    From
                        ss_paper_size_map
                    Where
                        Trim(src_paper_size) = Trim(param_page_size)
                )
            Where
                Rownum = 1;
        Exception
            When Others Then
                v_actual_page_size := param_page_size;
        End;
        Return v_actual_page_size;
    End;

    Function get_print_rate(param_page_size  Varchar2,
                            param_color_flag Number) Return Number Is
        v_count      Number;
        v_page_size  Varchar2(60);
        v_print_rate Number;
    Begin
        v_page_size := get_page_size(param_page_size);
        Begin
            Select
                rate
            Into
                v_print_rate
            From
                ss_print_rate_mast
            Where
                page_size = Trim(v_page_size)
                And color = param_color_flag;
            Return v_print_rate;
        Exception
            When Others Then
                Return 10;
        End;
    End;
    Function get_print_rate(param_page_size  Varchar2,
                            param_color_flag Varchar2) Return Number Is
        v_count      Number;
        v_color_flag Number := 1; --Color
        v_page_size  Varchar2(60);
        v_print_rate Number;
    Begin
        If upper(trim(param_color_flag)) = 'GRAYSCALE' Then
            v_color_flag := -1; --- B/W
        End If;
        v_print_rate := get_print_rate(param_page_size, v_color_flag);
        Return v_print_rate;
    End;

    Procedure update_print_log As
        Cursor cur_print_log Is
            Select
                Rownum, userid, page_size, color
            From
                ss_print_log
            Where
                empno Is Null
                And print_date > trunc(sysdate) - 3;
        --and PRINT_DATE = to_date('17-OCT-2015','dd-MON-yyyy');
        v_empno     Varchar2(5);
        v_deptno    Varchar2(4);
        v_page_type Varchar2(2);
        v_cost      Number;
    Begin
        For cur_row In cur_print_log
        Loop
            Begin
                Select
                    empno
                Into
                    v_empno
                From
                    userids
                Where
                    domain           = 'TICB'
                    And Trim(userid) = Trim(upper(cur_row.userid));
                Select
                    parent
                Into
                    v_deptno
                From
                    ss_emplmast
                Where
                    empno = v_empno;
            Exception
                When Others Then
                    Null;
            End;
            Begin
                Select
                    map_paper_size
                Into
                    v_page_type
                From
                    ss_paper_size_map
                Where
                    Trim(src_paper_size) = Trim(upper(cur_row.page_size));
                Select
                    rate
                Into
                    v_cost
                From
                    ss_print_rate_mast
                Where
                    page_size = v_page_type
                    And color = decode(Trim(cur_row.color), 'NOT GRAYSCALE', 1, - 1);
            Exception
                When Others Then
                    Null;
            End;
            If v_empno Is Not Null Or v_cost Is Not Null Then
                Update
                    ss_print_log
                Set
                    empno = v_empno, parent = v_deptno, page_type = v_page_type, cost = v_cost
                Where
                    Rownum = cur_row.rownum;
            End If;
            Commit;
        End Loop;
        --Commit;

    End;

End print_log_mis;
/
---------------------------
--Changed PACKAGE BODY
--PKG_ABSENT_TS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_ABSENT_TS" As


    Function get_payslip_month Return Varchar2 Is
        v_payslip_month_rec ss_absent_payslip_period%rowtype;
        v_ret_val           Varchar2(7);
    Begin
        Select
            *
        Into
            v_payslip_month_rec
        From
            ss_absent_payslip_period
        Where
            is_open = 'OK';

        Return v_payslip_month_rec.period;
    Exception
        When Others Then
            Return 'ERR';
    End;

    Procedure check_payslip_month_isopen(
        param_payslip_yyyymm Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
        v_open_payslip_yyyymm Varchar2(10);
    Begin
        v_open_payslip_yyyymm := get_payslip_month;
        If v_open_payslip_yyyymm <> param_payslip_yyyymm Then
            param_success := 'KO';
            param_message := 'Err - Payslip month "' || param_payslip_yyyymm || '" is not open in the system';
            Return;
        Else
            param_success := 'OK';
        End If;

    End;

    Procedure generate_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_key_id      Varchar2(8);
        v_first_day   Date;
        v_last_day    Date;
        v_requester   Varchar2(5);
        v_param_empno Varchar2(10);
    Begin
        v_first_day   := to_date(param_absent_yyyymm || '01', 'yyyymmdd');
        If param_absent_yyyymm = '202003' Then
            v_last_day := To_Date('20-Mar-2020', 'dd-Mon-yyyy');
        Else
            v_last_day := last_day(v_first_day);
        End If;

        v_key_id      := dbms_random.string('X', 8);
        v_requester   := ss.get_empno(param_requester);
        If param_empno = 'ALL' Then
            v_param_empno := '%';
        Else
            v_param_empno := param_empno || '%';
        End If;

        Delete
            From ss_absent_ts_detail
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno Like v_param_empno;
        --commit;
        --param_success   := 'OK';
        --return;
        If param_empno = 'ALL' Then
            Delete
                From ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

            Insert Into ss_absent_ts_master (
                absent_yyyymm,
                payslip_yyyymm,
                modified_on,
                modified_by,
                key_id
            )
            Values (
                param_absent_yyyymm,
                param_payslip_yyyymm,
                sysdate,
                v_requester,
                v_key_id
            );

        Else
            Select
                key_id
            Into
                v_key_id
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        End If;

        Commit;
        Insert Into ss_absent_ts_detail (
            key_id,
            absent_yyyymm,
            payslip_yyyymm,
            empno,
            absent_days,
            cl_bal,
            sl_bal,
            pl_bal,
            co_bal
        )
        Select
            v_key_id,
            param_absent_yyyymm,
            param_payslip_yyyymm,
            empno,
            absent_days,
            closingclbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) cl_bal,
            closingslbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) sl_bal,
            closingplbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) pl_bal,
            closingcobal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) co_bal
        From
            (
                Select
                    empno,
                    Listagg(dy, ', ') Within
                        Group (Order By dy) As absent_days
                From
                    (
                        Select
                            a.empno,
                            b.day_no                        dy,
                            is_emp_absent(a.empno, b.tdate) is_emp_absent
                        From
                            ss_emplmast        a,
                            ss_absent_ts_leave b
                        Where
                            b.yyyymm     = Trim(Trim(param_absent_yyyymm))
                            And a.empno  = b.empno
                            And a.status = 1
                            And a.parent Not In (
                                Select
                                    parent
                                From
                                    ss_dept_not_4_absent
                            )
                            And a.emptype In (
                                'R', 'F'
                            )
                            And a.empno Like v_param_empno
                            And b.leave_hrs > 0
                    )
                Where
                    is_emp_absent = 1
                Group By empno
            );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End generate_list;

    Procedure generate_nu_list_4_all_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_as_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        pop_timesheet_leave_data(
            param_yyyymm  => param_absent_yyyymm,
            param_success => param_success,
            param_message => param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            'ALL',
            param_requester,
            param_success,
            param_message
        );
    End generate_nu_list_4_all_emp;

    Procedure pop_timesheet_leave_data(
        param_yyyymm      Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_leave
        Where
            yyyymm = param_yyyymm;

        Insert Into ss_absent_ts_leave (
            yyyymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            tdate,
            leave_hrs
        )
        Select
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date,
            Sum(colvalue)
        From
            (
                Select
                    yymm,
                    empno,
                    projno,
                    wpcode,
                    activity,
                    day_no,
                    to_date(yymm || '-' || day_no, 'yyyymm-dd') t_date,
                    colvalue
                From
                    (
                        With
                            t As (
                                Select
                                    yymm,
                                    empno,
                                    parent,
                                    assign,
                                    a.projno,
                                    wpcode,
                                    activity,
                                    d1,
                                    d2,
                                    d3,
                                    d4,
                                    d5,
                                    d6,
                                    d7,
                                    d8,
                                    d9,
                                    d10,
                                    d11,
                                    d12,
                                    d13,
                                    d14,
                                    d15,
                                    d16,
                                    d17,
                                    d18,
                                    d19,
                                    d20,
                                    d21,
                                    d22,
                                    d23,
                                    d24,
                                    d25,
                                    d26,
                                    d27,
                                    d28,
                                    d29,
                                    d30,
                                    d31
                                From
                                    timecurr.time_daily a,
                                    timecurr.tm_leave   b
                                Where
                                    substr(a.projno, 1, 5) = b.projno
                                    And a.wpcode <> 4
                                    And yymm               = param_yyyymm
                            )
                        Select
                            yymm,
                            empno,
                            parent,
                            assign,
                            projno,
                            wpcode,
                            activity,
                            to_number(replace(col, 'D', '')) day_no,
                            colvalue
                        From
                            t Unpivot (colvalue
                            For col
                            In (d1,
                            d2,
                            d3,
                            d4,
                            d5,
                            d6,
                            d7,
                            d8,
                            d9,
                            d10,
                            d11,
                            d12,
                            d13,
                            d14,
                            d15,
                            d16,
                            d17,
                            d18,
                            d19,
                            d20,
                            d21,
                            d22,
                            d23,
                            d24,
                            d25,
                            d26,
                            d27,
                            d28,
                            d29,
                            d30,
                            d31))
                    )
                Where
                    day_no <= to_number(to_char(last_day(to_date(param_yyyymm, 'yyyymm')), 'dd'))
            )
        --Where
        --colvalue > 0
        Group By
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date;

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure update_no_mail_list(
        param_absent_yyyymm      Varchar2,
        param_payslip_yyyymm     Varchar2,
        param_emp_list_4_no_mail Varchar2,
        param_requester          Varchar2,
        param_success Out        Varchar2,
        param_message Out        Varchar2
    ) As
    Begin
        Null;
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        If Trim(param_emp_list_4_no_mail) Is Null Then
            param_success := 'KO';
            param_message := 'Err - Employee List for NO-MAIL is blank.';
            Return;
        End If;

        Update
            ss_absent_ts_detail
        Set
            no_mail = Null
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
        Update
            ss_absent_ts_detail
        Set
            no_mail = 'OK'
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_no_mail))
            );

        Commit;
        param_success := 'OK';
        param_message := 'Employee List for NO-MAIL successfully updated';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_lop(
        param_empno Varchar2,
        param_pdate Date
    ) Return Number Is
        v_lop Number;
    Begin
        Select
            half_full
        Into
            v_lop
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_pdate;

        Return v_lop;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure set_lop_4_emp(
        param_empno          Varchar2,
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(5);
        v_lop  Varchar2(5);
        v_cntr Number;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := lpad(substr(c2.column_value, 1, instr(c2.column_value, '-') - 1), 2, '0');

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(param_absent_yyyymm || v_day, 'yyyymmdd'),
                param_payslip_yyyymm,
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr > 0 Then
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                param_empno,
                param_requester,
                param_success,
                param_message
            );
        Else
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure regenerate_list_4_one_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure reset_emp_lop(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_ts_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm
            And empno                         = param_empno;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure delete_user_lop(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_absent_yyyymm  Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_lop
        Where
            empno                             = param_empno
            And payslip_yyyymm                = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure refresh_absent_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_count            Number;
        v_absent_list_date Date;
        Cursor cur_onduty Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_ondutyapp
                    Where
                        app_date >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                );

        Cursor cur_depu Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_depu
                    Where
                        (app_date >= trunc(v_absent_list_date)
                            Or chg_date >= trunc(v_absent_list_date))
                        And type In ('TR', 'DP')
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_depu_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_hist
                    Where
                        empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And type In ('TR', 'DP')
                        And chg_date >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );

        Cursor cur_leave Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_leaveapp
                    Where
                        (app_date >= trunc(v_absent_list_date))
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    /*
                    Select
                        empno
                    From
                        ss_leave_adj
                    Where
                        (adj_dt >= trunc(v_absent_list_date))
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    */
                    Select
                        empno
                    From
                        ss_leaveapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveledg
                    Where
                        adj_type In ('SW', 'LC')

                        And (app_date >= v_absent_list_date)

                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)

                );
        v_sysdate          Date := sysdate;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            Select
                nvl(refreshed_on, modified_on)
            Into
                v_absent_list_date
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Absent list not yet generated for the said period.';
                Return;
        End;

        For c_empno In cur_onduty
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_depu
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_leave
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;
        Update
            ss_absent_ts_master
        Set
            refreshed_on = v_sysdate
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function is_emp_absent(
        param_empno In Varchar2,
        param_date  In Date
    ) Return Number As

        v_count             Number;
        c_is_absent         Constant Number := 1;
        c_not_absent        Constant Number := 0;
        c_leave_depu_tour   Constant Number := 2;
        v_on_ldt            Number;
        v_ldt_appl          Number;
        v_pws               Number;
        v_swp_start_date    Date;
        v_attendance_status Varchar2(100);
        c_dws               Number          := 3;
    Begin
/*
        v_swp_start_date := To_Date('18-Apr-2022', 'dd-Mon-yyyy');
        If param_date >= v_swp_start_date Then
            v_pws               := iot_swp_common.fn_get_emp_pws(
                                       p_empno => param_empno,
                                       p_date  => param_date
                                   );

            If v_pws = c_dws Then
                Return c_not_absent;
            End If;

            v_attendance_status := iot_swp_common.fn_get_attendance_status(
                                       p_empno => param_empno,
                                       p_date  => param_date,
                                       p_pws   => v_pws
                                   );
            If v_attendance_status = 'Absent' Then
                Return c_is_absent;
            Else
                Return c_not_absent;
            End If;
        End If;
*/
        v_on_ldt         := isleavedeputour(param_date, param_empno);
        If v_on_ldt = 1 Then
            Return c_not_absent;
        End If;
        v_ldt_appl       := isldt_appl(param_empno, param_date);
        If v_ldt_appl > 0 Then
            Return c_not_absent;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_date;

        If v_count > 0 Then
            Return c_not_absent;
        End If;
        Return c_is_absent;
    End is_emp_absent;

    Procedure reverse_lop_4_emp(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(8);
        v_lop  Varchar2(5);
        v_cntr Number;
        v_date Date;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            v_date := to_date(param_payslip_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;

        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := substr(c2.column_value, 1, instr(c2.column_value, '-') - 1);

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop_reverse (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(v_day, 'yyyymmdd'),
                to_char(v_date, 'yyyymm'),
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr = 0 Then
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        Else
            param_success := 'OK';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure send_absent_email(
        p_payslip_yyyymm Varchar2,
        p_absent_yyyymm  Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast e
                    Where
                        e.empno In (
                            Select
                                empno
                            From
                                ss_absent_ts_detail
                            Where
                                absent_yyyymm          = p_absent_yyyymm
                                And payslip_yyyymm     = p_payslip_yyyymm
                                And nvl(no_mail, 'KO') = 'KO'
                                And empno Not In ('04600', '04132')
                        )
                        And email Is Not Null
                    Order By e.empno
                )
            Group By
                group_id;

        v_subject           Varchar2(1000);
        v_msg_body          Varchar2(2000);
        v_mail_csv          Varchar2(2000);
        v_success           Varchar2(100);
        v_message           Varchar2(500);
        v_absent_month_date Date;
        v_absent_month_text Varchar2(30);
    Begin
        Begin
            v_absent_month_date := to_date(p_absent_yyyymm, 'yyyymm');
            v_absent_month_text := regexp_replace(to_char(v_absent_month_date, 'Month-yyyy'), '\s{2,}', ' ');
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;
        v_msg_body := replace(c_absent_mail_body, '!@MONTH@!', v_absent_month_text);
        v_subject  := 'SELFSERVICE : ' || replace(c_absent_mail_sub, '!@MONTH@!', v_absent_month_text);

        For email_csv_row In cur_mail_list
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => 'a.kotian@tecnimont.in;',
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;
        p_success  := 'OK';
        p_message  := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;



End pkg_absent_ts;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    c_planning_future  Constant Number(1) := 2;
    c_planning_current Constant Number(1) := 1;
    c_planning_is_open Constant Number(1) := 1;
    Procedure del_emp_sws_atend_plan(
        p_empno            Varchar2,
        p_date             Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
        v_plan_start_date         Date;
        v_plan_end_date           Date;
        v_planning_exists         Varchar2(2);
        v_planning_open           Varchar2(2);
        v_message_type            Varchar2(10);
        v_message_text            Varchar2(1000);

        v_general_area            Varchar2(4) := 'A002';
        v_count                   Number;
        rec_config_week           swp_config_weeks%rowtype;
    Begin
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            empno           = p_empno
            And week_key_id = rec_config_week.key_id;
        If v_count < 2 Then
            p_message_type := 'KO';
            p_message_text := 'Only one attendance day availabe. Hence cannot delete.';
            Return;
        End If;
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
        Exception
            When no_data_found Then
                Return;
        End;
        --Delete from Planning table

        Delete
            From swp_smart_attendance_plan
        Where
            key_id = rec_smart_attendance_plan.key_id;

        --Check if the desk is General desk.
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

        If Not iot_swp_common.is_desk_in_general_area(rec_smart_attendance_plan.deskid) Then
            Return;
        End If;
        --

        iot_swp_dms.sp_unlock_desk(
            p_person_id   => Null,
            p_meta_id     => Null,

            p_deskid      => rec_smart_attendance_plan.deskid,
            p_week_key_id => rec_config_week.key_id
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_status                  Varchar2(5);
        v_mod_by_empno            Varchar2(5);
        v_pk                      Varchar2(10);
        v_fk                      Varchar2(10);
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        ---    
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace a
        Where
            Trim(a.empno)                 = Trim(p_empno)
            And Trim(a.primary_workspace) = 2
            And trunc(a.start_date)       = (
                      Select
                          Max(trunc(start_date))
                      From
                          swp_primary_workspace b
                      Where
                          b.empno = a.empno
                          And b.start_date <= rec_config_week.end_date
                  );

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        For i In 1..p_weekly_attendance.count
        Loop

            With
                csv As (
                    Select
                        p_weekly_attendance(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            If v_status = 0 Then
                del_emp_sws_atend_plan(
                    p_empno        => v_empno,
                    p_date         => trunc(v_attendance_date),
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
                Return;
            End If;
            Begin
                Select
                    *
                Into
                    rec_smart_attendance_plan
                From
                    swp_smart_attendance_plan
                Where
                    empno               = v_empno
                    And attendance_date = v_attendance_date;
            Exception
                When Others Then
                    Null;
            End;
            If v_status = '1' Then
                If rec_smart_attendance_plan.empno Is Null Then
                    v_pk := dbms_random.string('X', 10);

                    ---    
                    Select
                        key_id
                    Into
                        v_fk
                    From
                        swp_primary_workspace a
                    Where
                        Trim(a.empno)                 = Trim(p_empno)
                        And Trim(a.primary_workspace) = 2
                        And trunc(a.start_date)       = (
                                  Select
                                      Max(trunc(start_date))
                                  From
                                      swp_primary_workspace b
                                  Where
                                      b.empno = a.empno
                                      And b.start_date <= rec_config_week.end_date
                              );

                    --Check attendance date is holiday
                    Select
                        Count(*)
                    Into
                        v_count
                    From
                        ss_holidays
                    Where
                        holiday = v_attendance_date;
                    If v_count > 0 Then
                        p_message_type := 'KO';
                        p_message_text := 'Cannot assign holiday as attendance day.';
                        Continue;
                    End If;

                    --Insert into Attendance Plan
                    Insert Into swp_smart_attendance_plan
                    (
                        key_id,
                        ws_key_id,
                        empno,
                        attendance_date,
                        deskid,
                        modified_on,
                        modified_by,
                        week_key_id
                    )
                    Values
                    (
                        v_pk,
                        v_fk,
                        v_empno,
                        v_attendance_date,
                        v_desk,
                        sysdate,
                        v_mod_by_empno,
                        rec_config_week.key_id
                    );
                Else
                    Update
                        swp_smart_attendance_plan
                    Set
                        deskid = v_desk, modified_on = sysdate, modified_by = v_mod_by_empno
                    Where
                        key_id = rec_smart_attendance_plan.key_id;
                End If;
                If iot_swp_common.is_desk_in_general_area(v_desk) Then
                    /*
                    iot_swp_dms.sp_clear_desk(
                        p_person_id => Null,
                        p_meta_id   => p_meta_id,

                        p_deskid    => v_desk

                    );
                    */
                    iot_swp_dms.sp_lock_desk(
                        p_person_id => Null,
                        p_meta_id   => Null,

                        p_deskid    => v_desk
                    );
                End If;
            End If;

        End Loop;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || v_desk || ' is not available. It has be assigned to other Employee.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_atnd;

    Procedure sp_delete_weekly_attendance(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_date              Date,
        p_deskid            Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
    Begin
        del_emp_sws_atend_plan(
            p_empno        => p_empno,
            p_date         => p_date,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
    End;

    Procedure sp_add_weekly_attendance(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_date              Date,
        p_deskid            Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        strsql                    Varchar2(600);
        v_count                   Number;
        v_status                  Varchar2(5);
        v_mod_by_empno            Varchar2(5);
        v_pk                      Varchar2(10);
        v_fk                      Varchar2(10);
        v_empno                   Varchar2(5);
        v_attendance_date         Date;
        v_desk                    Varchar2(20);
        rec_config_week           swp_config_weeks%rowtype;
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
    Begin

        v_mod_by_empno    := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future
            And sws_open  = c_planning_is_open;

        ---    
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace a
        Where
            Trim(a.empno)                 = Trim(p_empno)
            And Trim(a.primary_workspace) = 2
            And trunc(a.start_date)       = (
                      Select
                          Max(trunc(start_date))
                      From
                          swp_primary_workspace b
                      Where
                          b.empno = a.empno
                          And b.start_date <= rec_config_week.end_date
                  );

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;
        /*
                For i In 1..p_weekly_attendance.count
                Loop

                    With
                        csv As (
                            Select
                                p_weekly_attendance(i) str
                            From
                                dual
                        )
                    Select
                        Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                        To_Date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                        Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                        Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
                    Into
                        v_empno, v_attendance_date, v_desk, v_status
                    From
                        csv;
                        del_emp_sws_atend_plan(
                            p_empno        => v_empno,
                            p_date         => trunc(v_attendance_date),
                            p_message_type => p_message_type,
                            p_message_text => p_message_text
                        );
                        Return;
                        */
        v_attendance_date := p_date;
        v_empno           := p_empno;
        v_desk            := p_deskid;
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = v_empno
                And attendance_date = v_attendance_date;
        Exception
            When Others Then
                Null;
        End;

        If rec_smart_attendance_plan.empno Is Null Then
            v_pk := dbms_random.string('X', 10);

            ---    
            Select
                key_id
            Into
                v_fk
            From
                swp_primary_workspace a
            Where
                Trim(a.empno)                 = Trim(p_empno)
                And Trim(a.primary_workspace) = 2
                And trunc(a.start_date)       = (
                          Select
                              Max(trunc(start_date))
                          From
                              swp_primary_workspace b
                          Where
                              b.empno = a.empno
                              And b.start_date <= rec_config_week.end_date
                      );

            --Check attendance date is holiday
            Select
                Count(*)
            Into
                v_count
            From
                ss_holidays
            Where
                holiday = v_attendance_date;
            If v_count > 0 Then
                p_message_type := 'KO';
                p_message_text := 'Cannot assign holiday as attendance day.';
                Return;
            End If;

            --Insert into Attendance Plan
            Insert Into swp_smart_attendance_plan
            (
                key_id,
                ws_key_id,
                empno,
                attendance_date,
                deskid,
                modified_on,
                modified_by,
                week_key_id
            )
            Values
            (
                v_pk,
                v_fk,
                v_empno,
                v_attendance_date,
                v_desk,
                sysdate,
                v_mod_by_empno,
                rec_config_week.key_id
            );
        Else
            Update
                swp_smart_attendance_plan
            Set
                deskid = v_desk, modified_on = sysdate, modified_by = v_mod_by_empno
            Where
                key_id = rec_smart_attendance_plan.key_id;
        End If;
        If iot_swp_common.is_desk_in_general_area(v_desk) Then
            /*
            iot_swp_dms.sp_clear_desk(
                p_person_id => Null,
                p_meta_id   => p_meta_id,

                p_deskid    => v_desk

            );
            */
            iot_swp_dms.sp_lock_desk(
                p_person_id => Null,
                p_meta_id   => Null,

                p_deskid    => v_desk
            );
        End If;
        --          End If;

        --        End Loop;
        Commit;

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || v_desk || ' is not available. It has be assigned to other Employee.';

        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_attendance;

    Procedure sp_smart_ws_weekly_summary(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_assign_code                   Varchar2,
        p_date                          Date,

        p_emp_count_smart_workspace Out Number,
        p_emp_count_mon             Out Number,
        p_emp_count_tue             Out Number,
        p_emp_count_wed             Out Number,
        p_emp_count_thu             Out Number,
        p_emp_count_fri             Out Number,
        p_costcode_desc             Out Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As
        v_start_date Date;
        v_end_date   Date;
        Cursor cur_summary(cp_start_date Date,
                           cp_end_date   Date) Is
            Select
                attendance_day, Count(empno) emp_count
            From
                (
                    Select
                        e.empno, to_char(attendance_date, 'DY') attendance_day
                    From
                        ss_emplmast               e,
                        swp_smart_attendance_plan wa
                    Where
                        e.assign    = p_assign_code
                        And attendance_date Between cp_start_date And cp_end_date
                        And e.empno = wa.empno(+)
                        And status  = 1
                        And emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )
                )
            Group By
                attendance_day;

    Begin
        v_start_date   := iot_swp_common.get_monday_date(p_date);
        v_end_date     := iot_swp_common.get_friday_date(p_date);
        Select
            costcode || ' - ' || name
        Into
            p_costcode_desc
        From
            ss_costmast
        Where
            costcode = p_assign_code;

        For c1 In cur_summary(trunc(v_start_date), trunc(v_end_date))
        Loop
            If c1.attendance_day = 'MON' Then
                p_emp_count_mon := c1.emp_count;
            Elsif c1.attendance_day = 'TUE' Then
                p_emp_count_tue := c1.emp_count;
            Elsif c1.attendance_day = 'WED' Then
                p_emp_count_wed := c1.emp_count;
            Elsif c1.attendance_day = 'THU' Then
                p_emp_count_thu := c1.emp_count;
            Elsif c1.attendance_day = 'FRI' Then
                p_emp_count_fri := c1.emp_count;
            End If;
        End Loop;

        --Total Count
        Select
            --e.empno, emptype, status, aw.primary_workspace
            Count(*)
        Into
            p_emp_count_smart_workspace
        From
            ss_emplmast           e,
            swp_primary_workspace aw

        Where
            e.assign                 = p_assign_code
            And e.empno              = aw.empno
            And status               = 1
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And aw.primary_workspace = 2
            And
            trunc(aw.start_date)     = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = aw.empno
                        And b.start_date <= v_end_date
                );

        /*

                Select
                    Count(*)
                Into
                    p_emp_count_smart_workspace
                From
                    swp_primary_workspace
                Where
                    primary_workspace = 2
                    And empno In (
                        Select
                            empno
                        From
                            ss_emplmast
                        Where
                            status     = 1
                            And assign = p_assign_code
                    );
        */
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_sys_assign_sws_desk(
        p_empno            Varchar2,
        p_attendance_date  Date,
        p_deskid           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count         Number;
        v_pk            Varchar2(10);
        v_fk            Varchar2(10);
        rec_config_week swp_config_weeks%rowtype;
    Begin

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = c_planning_future;

        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = 2;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        --Check attendance date is holidy
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_attendance_date;
        If v_count > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Cannot assign holiday as attendance day.';
            Return;
        End If;

        v_pk           := dbms_random.string('X', 10);

        Select
            key_id
        Into
            v_fk
        From
            swp_primary_workspace pws
        Where
            Trim(pws.empno)           = Trim(p_empno)
            And pws.primary_workspace = 2
            And trunc(pws.start_date) = (
                Select
                    Max(trunc(start_date))
                From
                    swp_primary_workspace b
                Where
                    b.empno = pws.empno
                    And b.start_date <= rec_config_week.end_date
            );

        Insert Into swp_smart_attendance_plan
        (
            key_id,
            ws_key_id,
            empno,
            attendance_date,
            deskid,
            modified_on,
            modified_by,
            week_key_id
        )
        Values
        (
            v_pk,
            v_fk,
            p_empno,
            p_attendance_date,
            p_deskid,
            sysdate,
            'Sys',
            rec_config_week.key_id
        );
        If iot_swp_common.is_desk_in_general_area(p_deskid) Then

            iot_swp_dms.sp_lock_desk(
                p_person_id => Null,
                p_meta_id   => Null,

                p_deskid    => p_deskid
            );
        End If;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_sys_assign_sws_desk;

End iot_swp_smart_workspace;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_EMPLOYEES_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMPLOYEES_QRY" As

    Function fn_swp_employees(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                empno, name As employee_name, emptype, grade, parent, assign
            From
                ss_emplmast e
            Where
                (
                e.status = 1

                )
                And e.emptype In (
                    Select
                        emptype
                    From
                        swp_include_emptype
                )
                And e.assign Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And e.grade <> v_exclude_grade;
        Return c;
    End fn_swp_employees;

End iot_swp_employees_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_attendance_for_period(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                p_end_date                                                 As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;

        Return c;

    End;

    Function fn_attendance_for_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_start_date Is Null Then
            raise_application_error(-20003, 'Invalid date provided.');

            Return Null;
        End If;

        Select
            Count(holiday)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_start_date;
        If v_count > 0 Then
            raise_application_error(-20002, 'Date provided is a holiday');
            Return Null;
        End If;
        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required

            From
                (
                    Select
                        *
                    From
                        (
                            Select
                                e.empno                                                       As empno,
                                e.name                                                        As employee_name,
                                e.email                                                       As email,
                                e.parent                                                      As parent,
                                e.assign                                                      As assign,
                                e.emptype                                                     As emp_type,
                                e.grade                                                       As grade,
                                e.doj                                                         As doj,
                                trunc(p_start_date)                                           As d_date,
                                to_char(e.status)                                             As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, p_start_date)) n_pws,
                                Case iot_swp_common.fn_can_work_smartly(empno)
                                    When 1 Then
                                        'Yes'
                                    Else
                                        'No'
                                End                                                           As can_work_smartly
                            From
                                ss_emplmast e
                            Where
                                status = 1
                                And emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And assign Not In(
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And grade <> v_exclude_grade
                                And doj <= p_start_date
                        )
                ) data;

        Return c;

    End;

    Function fn_attendance_for_prev_day(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor As
        v_prev_date Date;
    Begin
        v_prev_date := iot_swp_common.fn_get_prev_work_date(trunc(sysdate) - 1);

        Return fn_attendance_for_day(
                p_person_id               => p_person_id,
                p_meta_id                 => p_meta_id,

                p_start_date              => v_prev_date,

                p_is_exclude_x1_employees => 0

            );
    End;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

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
                        dd.d_day As d_days, dd.d_date d_date_list
                    From
                        ss_days_details dd
                    Where
                        d_date Between p_start_date And p_end_date
                        And dd.d_date Not In (
                            Select
                                holiday
                            From
                                ss_holidays
                            Where
                                ss_holidays.holiday Between p_start_date And p_end_date
                        )
                )
            Order By
                d_date_list;
        Return c;

    End;

    Function fn_week_number_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yyyymm    Varchar2

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_temp_date          Date;
        v_mm                 Varchar2(2);
        v_yyyy               Varchar2(4);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_yyyymm Is Null Then
            raise_application_error(-20003, 'Invalid month provided.');

            Return Null;
        End If;
        --
        --Check p_yyyymm is valid
        Begin
            v_temp_date := To_Date(p_yyyymm, 'yyyymm');
            v_mm        := substr(p_yyyymm, 5, 2);
            v_yyyy      := substr(p_yyyymm, 1, 4);
        Exception
            When Others Then
                raise_application_error(-20002, 'Invalid yyyymm.');
                Return Null;
        End;
        --

        Open c For
            With
                params As (
                    Select
                        n_getstartdate(v_mm, v_yyyy) As start_date,
                        n_getenddate(v_mm, v_yyyy)   As end_date
                    From
                        dual
                )
            Select
                d_date,
                'Week_' || to_char(trunc((Rownum - 1) / 7) + 1) As week_name
            From
                ss_days_details dd, params
            Where
                d_date Between params.start_date And params.end_date
                And dd.d_date Not In (
                    Select
                        holiday
                    From
                        ss_holidays, params
                    Where
                        ss_holidays.holiday Between params.start_date And params.end_date
                );
        Return c;

    End;

    Function fn_swp_day_attendance_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                p_end_date                                                 As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;

        Return c;

    End;

    Function fn_attendance_for_month(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_yyyymm                  Varchar2,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
        v_temp_date          Date;
        v_mm                 Varchar2(2);
        v_yyyy               Varchar2(4);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_yyyymm Is Null Then
            raise_application_error(-20003, 'Invalid month provided.');

            Return Null;
        End If;
        --
        --Check p_yyyymm is valid
        Begin
            v_temp_date := To_Date(p_yyyymm, 'yyyymm');
            v_mm        := substr(p_yyyymm, 5, 2);
            v_yyyy      := substr(p_yyyymm, 1, 4);
        Exception
            When Others Then
                raise_application_error(-20002, 'Invalid yyyymm.');
                Return Null;
        End;
        --
        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (

                            With
                                params As (
                                    Select
                                        n_getstartdate(v_mm, v_yyyy) As start_date,
                                        n_getenddate(v_mm, v_yyyy)  As end_date
                                    From
                                        dual
                                ),
                                days_details As (
                                    Select
                                        d_date,
                                        'Week_' || to_char(trunc((Rownum - 1) / 7) + 1) As week_num
                                    From
                                        ss_days_details, params
                                    Where
                                        d_date Between params.start_date And params.end_date
                                ),
                                work_days As (
                                    Select
                                        *
                                    From
                                        days_details d, params
                                    Where
                                        d.d_date Between params.start_date And nvl(params.end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays, params
                                            Where
                                                holiday Between params.start_date And nvl(params.end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                params.end_date                                            As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) As n_pws,
                                wd.week_num                                                As week_num
                            From
                                ss_emplmast e,
                                work_days   wd,
                                params
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;
        Return c;

    End;

End iot_swp_attendance_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY_QRY" As

    Function fn_get_onduty_applications(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_onduty_type  Varchar2 Default Null,
        p_start_date   Date     Default Null,
        p_end_date     Date     Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.empno,
                        app_date,
                        to_char(a.app_date, 'dd-Mon-yyyy')             As application_date,
                        a.app_no                                       As application_id,
                        a.pdate                                        As application_for_date,
                        a.start_date                                   As start_date,
                        description,
                        a.type                                         As onduty_type,
                        get_emp_name(a.lead_apprl_empno)               As lead_name,
                        a.lead_apprldesc                               As lead_approval,
                        hod_apprldesc                                  As hod_approval,
                        hrd_apprldesc                                  As hr_approval,
                        Case
                            When p_req_for_self = 'OK' Then
                                a.can_delete_app
                            Else
                                0
                        End                                            As can_delete_app,
                        Row_Number() Over (Order By a.start_date Desc) As row_number,
                        Count(*) Over ()                               As total_row
                    From
                        ss_vu_od_depu a
                    Where
                        a.empno    = p_empno
                        And a.pdate >= add_months(sysdate, -24)
                        And a.type = nvl(p_onduty_type, a.type)
                        And a.pdate Between trunc(nvl(p_start_date, a.pdate)) And trunc(nvl(p_end_date, a.pdate))
                    Order By start_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                start_date Desc;
        Return c;

    End;

    Function fn_onduty_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_self_empno         Varchar2(5);
        v_req_for_self       Varchar2(2);
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_self_empno := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            empno
        Into
            v_for_empno
        From
            ss_emplmast
        Where
            empno = p_empno;
        --And status = 1;
        If v_self_empno = v_for_empno Then
            v_req_for_self := 'OK';
        Else
            v_req_for_self := 'KO';
        End If;

        c            := fn_get_onduty_applications(v_for_empno, v_req_for_self, p_onduty_type, p_start_date, p_end_date, p_row_number,
                                                   p_page_length);
        Return c;
    End fn_onduty_applications_4_other;

    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
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
        c       := fn_get_onduty_applications(v_empno, 'OK', p_onduty_type, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;

    End fn_onduty_applications_4_self;

    Function fn_pending_lead_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_lead_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_lead_empno := get_empno_from_meta_id(p_meta_id);
        If v_lead_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        lead_reason                             As lead_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And a.lead_apprl_empno = Trim(v_lead_empno)
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_lead_approval;

    Function fn_pending_hod_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hodreason                               As hod_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And e.mngr             = Trim(v_hod_empno)
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_onbehalf_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hodreason                               As hod_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = Trim(v_hod_empno)
                        )
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')             As application_date,
                        a.app_no                                       As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')                  As start_date,
                        to_char(edate, 'dd-Mon-yyyy')                  As end_date,
                        type                                           As onduty_type,
                        dm_get_emp_office(a.empno)                     As office,
                        a.empno || ' - ' || name                       As emp_name,
                        a.empno                                        As emp_no,
                        parent                                         As parent,
                        getempname(lead_apprl_empno)                   As lead_name,
                        hrdreason                                      As hr_remarks,
                        Row_Number() Over (Order By e.parent, e.empno) As row_number,
                        Count(*) Over ()                               As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, 0)     = 1)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And (nvl(hrd_apprl, 0) = 0)
                    Order By e.parent, e.empno Asc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hr_approval;

End iot_onduty_qry;
/
