--------------------------------------------------------
--  File created - Wednesday-September-29-2021   
--------------------------------------------------------
---------------------------
--New TABLE
--SS_ONDUTY_SUB_TYPE
---------------------------
  CREATE TABLE "SELFSERVICE"."SS_ONDUTY_SUB_TYPE" 
   (	"OD_SUB_TYPE" NUMBER(1,0) NOT NULL ENABLE,
	"DESCRIPTION" VARCHAR2(100),
	CONSTRAINT "SS_ONDUTY_SUB_TYPE_PK" PRIMARY KEY ("OD_SUB_TYPE") ENABLE
   );
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY" As

    Procedure sp_onduty_details(
        p_empno               Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,
        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_onduty_app ss_ondutyapp%rowtype;
        v_depu       ss_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin
        v_empno        := p_empno;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            Select
                *
            Into
                v_onduty_app
            From
                ss_ondutyapp
            Where
                Trim(app_no) = Trim(p_application_id);
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                Select
                    *
                Into
                    v_depu
                From
                    ss_depu
                Where
                    Trim(app_no) = Trim(p_application_id);
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        p_emp_name     := get_emp_name(v_empno);
        If v_onduty_app.empno Is Not Null Then
            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;
            If nvl(v_onduty_app.odtype, 0) <> 0 Then
                Select
                    description
                Into
                    p_onduty_type
                From
                    ss_onduty_sub_type
                Where
                    od_sub_type = v_onduty_app.odtype;
                p_onduty_sub_type := v_onduty_app.odtype || ' - ' || p_onduty_sub_type;
            End If;

            p_start_date    := to_char(v_onduty_app.pdate, 'dd-Mon-yyyy');
            p_hh1           := lpad(v_onduty_app.hh, 2, '0');
            p_mi1           := lpad(v_onduty_app.mm, 2, '0');
            p_hh2           := lpad(v_onduty_app.hh1, 2, '0');
            p_mi2           := lpad(v_onduty_app.mm1, 2, '0');
            p_reason        := v_onduty_app.reason;

            p_lead_name     := get_emp_name(v_onduty_app.lead_apprl_empno);
            p_lead_approval := ss.approval_text(v_onduty_app.lead_apprl);
            p_hod_approval  := ss.approval_text(v_onduty_app.hod_apprl);
            p_hr_approval   := ss.approval_text(v_onduty_app.hrd_apprl);

        Elsif v_depu.empno Is Not Null Then

            p_start_date    := to_char(v_depu.bdate, 'dd-Mon-yyyy');
            p_end_date      := to_char(v_depu.edate, 'dd-Mon-yyyy');
            p_reason        := v_depu.reason;

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;

            p_lead_name     := get_emp_name(v_depu.lead_apprl_empno);

            p_lead_approval := ss.approval_text(v_depu.lead_apprl);
            p_hod_approval  := ss.approval_text(v_depu.hod_apprl);
            p_hr_approval   := ss.approval_text(v_depu.hrd_apprl);

        End If;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_punch_entry_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno         Varchar2(5);
        v_count         Number;
        v_lead_approval Number := 0;
        v_hod_approval  Number := 0;
        v_desc          Varchar2(60);
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => v_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => to_number(Trim(p_hh1)),
            p_mi            => to_number(Trim(p_mi1)),
            p_hh1           => to_number(Trim(p_hh2)),
            p_mi1           => to_number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_punch_entry_4_self;

    Procedure sp_add_punch_entry_4_other As
    Begin
        -- TODO: Implementation required for Procedure IOT_ONDUTY.sp_add_punch_entry_4_other
        Null;
    End sp_add_punch_entry_4_other;

    Procedure sp_add_depu_tour_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;

    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_2(
            p_empno         => v_empno,
            p_od_type       => p_type,
            p_b_yyyymmdd    => to_char(p_start_date, 'yyyymmdd'),
            p_e_yyyymmdd    => to_char(p_end_date, 'yyyymmdd'),
            p_entry_by      => v_empno,
            p_lead_approver => p_lead_approver,
            p_user_ip       => Null,
            p_reason        => p_reason,
            p_success       => p_message_type,
            p_message       => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_depu_tour_4_self;

    Procedure sp_add_depu_tour_4_other As
    Begin
        -- TODO: Implementation required for Procedure IOT_ONDUTY.sp_add_depu_tour_4_other
        Null;
    End sp_add_depu_tour_4_other;

    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count        := 0;
        v_empno        := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(p_app_no   => p_application_id,
                   p_tab_from => v_tab_from);
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_4_self;

    Procedure sp_onduty_details_for_self(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count := 0;
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sp_onduty_details(
            p_empno           => v_empno,

            p_application_id  => p_application_id,

            p_emp_name        => p_emp_name,

            p_onduty_type     => p_onduty_type,
            p_onduty_sub_type => p_onduty_sub_type,
            p_start_date      => p_start_date,
            p_end_date        => p_end_date,

            p_hh1             => p_hh1,
            p_mi1             => p_mi1,
            p_hh2             => p_hh2,
            p_mi2             => p_mi2,

            p_reason          => p_reason,

            p_lead_name       => p_lead_name,
            p_lead_approval   => p_lead_approval,
            p_hod_approval    => p_hod_approval,
            p_hr_approval     => p_hr_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_details_for_other(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,
        p_emp_no              Varchar2,
        
        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
    Begin
        Null;
    End;

End iot_onduty;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY_QRY" As

    Function fn_get_onduty_applications(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        a.pdate                                 As application_for_date,
                        description,
                        a.type                                  As onduty_type,
                        get_emp_name(a.lead_apprl_empno)        As lead_name,
                        a.lead_apprldesc                        As lead_approval,
                        hod_apprldesc                           As hod_approval,
                        hrd_apprldesc                           As hr_approval,
                        a.can_delete_app                        As can_delete_app,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odappstat a
                    Where
                        a.empno = p_empno
                        And a.pdate >= add_months(sysdate, - 24)
                    Order By app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

  Function fn_get_onduty_lead_approval(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
         v_empno varchar2(5):='01296';
    Begin
        Open c For
            Select
                *
            From
                (
					Select			
						to_char(a.app_date, 'dd-Mon-yyyy')			As application_date ,
						a.app_no							        As application_id,								
						to_char(bdate, 'dd-Mon-yyyy')				As start_date ,
						to_char(edate, 'dd-Mon-yyyy')				As end_date ,
						type			                            As onduty_type ,    
						dm_get_emp_office(a.empno) 		            As office,
						a.empno ||' - '|| name						As emp_name,
                        a.empno                 					As emp_no,
						parent										As parent,
						getempname(lead_apprl_empno)				As lead_name,
                        lead_reason                                 As lead_remarks,
						Row_Number() Over (Order By a.app_date) 	As row_number,
						Count(*) Over ()                        	As total_row
					From
						ss_odapprl a,
						ss_emplmast e
					Where                        
                            ( nvl(lead_apprl, 0) = 0 )
                        And ( nvl(hrd_apprl, 0) = 0 )
                        And ( nvl(hod_apprl, 0) = 0 )
                        And a.empno = e.empno
                        And a.empno In ( Select empno From ss_emplmast Where lead_apprl_empno = Trim(v_empno) )
                    Order By parent, a.empno
                    )
						Where
							row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

  Function fn_get_onduty_hod_approval(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
        v_empno varchar2(5):='02346';
    Begin
    
        Open c For
            Select
                *
            From
                (
					Select			
						to_char(a.app_date, 'dd-Mon-yyyy')			As application_date ,
						a.app_no							        As application_id,								
						to_char(bdate, 'dd-Mon-yyyy')				As start_date ,
						to_char(edate, 'dd-Mon-yyyy')				As end_date ,
						type			                            As onduty_type ,    
						dm_get_emp_office(a.empno) 		            As office,
						a.empno ||' - '|| name						As emp_name,
                        a.empno                 					As emp_no,
						parent										As parent,
						getempname(lead_apprl_empno)				As lead_name,
                        hodreason                                   As hod_remarks,
						Row_Number() Over (Order By a.app_date) 	As row_number,
						Count(*) Over ()                        	As total_row
					From
						ss_odapprl a,
						ss_emplmast e
					Where
                            ( nvl(lead_apprl, 0) In ( 1, 4 ) )
                        And ( nvl(hrd_apprl, 0) = 0 ) 
                        And ( nvl(hod_apprl, 0) = 0 )    
                        And a.empno = e.empno
                        And a.empno In ( Select empno From ss_emplmast Where mngr = Trim(v_empno) )
                        Order By parent, a.empno
                    )
						Where
							row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;

    Function fn_get_onduty_hr_approval(
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
					Select			
						to_char(a.app_date, 'dd-Mon-yyyy')			As application_date ,
						a.app_no							        As application_id,								
						to_char(bdate, 'dd-Mon-yyyy')				As start_date ,
						to_char(edate, 'dd-Mon-yyyy')				As end_date ,
						type			                            As onduty_type ,    
						dm_get_emp_office(a.empno) 		            As office,
						a.empno ||' - '|| name						As emp_name,
                        a.empno                 					As emp_no,
						parent										As parent,
						getempname(lead_apprl_empno)				As lead_name,
                        HRDREASON                                   As hr_remarks,
						Row_Number() Over (Order By a.app_date) 	As row_number,
						Count(*) Over ()                        	As total_row
					From
						ss_odapprl a,
						ss_emplmast
					Where
						( nvl(hod_apprl, 0) = 1 )
						And a.empno = ss_emplmast.empno
						And ( nvl(hrd_apprl, 0) = 0 )
						 Order By app_date Desc						
				)
						Where
							row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;


    Function fn_onduty_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        Select
            empno
        Into
            v_empno
        From
            ss_emplmast
        Where
            empno      = p_empno
            And status = 1;
        c := fn_get_onduty_applications(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_applications_4_other;

    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_person_id(p_person_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := fn_get_onduty_applications(v_empno, p_row_number, p_page_length);
        Return c;

    End fn_onduty_applications_4_self;

    Function fn_onduty_lead_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        
        c := fn_get_onduty_lead_approval(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_lead_approval;

    Function fn_onduty_hod_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        
        c := fn_get_onduty_hod_approval(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_hod_approval;

    Function fn_onduty_hr_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        
        c := fn_get_onduty_hr_approval(v_empno, p_row_number, p_page_length);
        Return c;
    End fn_onduty_hr_approval;

End iot_onduty_qry;
/
