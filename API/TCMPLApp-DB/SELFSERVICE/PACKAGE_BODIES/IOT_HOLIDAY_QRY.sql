--------------------------------------------------------
--  DDL for Package Body IOT_HOLIDAY_QRY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_HOLIDAY_QRY" As

   Function get_holiday_attendance(
      p_empno       Varchar2,
      p_start_date  Date,
      p_end_date    Date,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor As
      c Sys_Refcursor;
   Begin
      Open c For
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As applied_on,
                          a.app_no As app_no,
                          a.description As description,
                          get_emp_name(lead_apprl_empno) As lead_name,
                          a.lead_apprldesc As lead_approval,
                          a.hod_apprldesc As hod_approval,
                          a.hrd_apprldesc As hr_approval,
                          a.lead_reason As lead_remarks,
                          a.pdate As holiday_attendance_date,
                          Case
                             When (a.pdate < sysdate)
                                Or (a.hod_apprl > 0)
                             Then
                                1
                             Else
                                0
                          End delete_allowed,
                          Row_Number() Over (Order By app_date Desc) row_number,
                          Count(*) Over () total_row
                     From ss_ha_app_stat a
                    Where empno = p_empno
                      And a.app_date >= nvl(p_start_date, add_months(sysdate, - 3))
                      And trunc(a.app_date) <= nvl(p_end_date, trunc(a.app_date))
                    -- empno = p_empno And a.app_date >= add_months(sysdate, - 3)
                    Order By pdate Desc
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

      Return c;

   End;

   Function fn_holiday_attendance(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_start_date  Date Default Null,
      p_end_date    Date Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
         Raise e_employee_not_found;
         Return Null;
      End If;
      c       := get_holiday_attendance(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
      Return c;
   End fn_holiday_attendance;

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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.LEAD_REASON As Lead_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where A.EmpNo = B.EmpNo
                      And (nvl(Lead_apprl, 0) = 0)
                      And (nvl(Hrd_apprl, 0) = 0)
                      And (nvl(Hod_apprl, 0) = 0)
                      And Lead_Apprl_EmpNo = Trim(v_lead_empno)
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HODREASON As hod_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (nvl(Lead_apprl, 0) In (1, 4))
                      And (nvl(Hrd_apprl, 0) = 0)
                      And (nvl(Hod_apprl, 0) = 0)
                      And A.EmpNo = B.EmpNo
                      And A.EmpNo In (Select empno From SS_EmplMast Where Mngr = Trim(v_hod_empno))
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HODREASON As hod_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (NVL(Lead_apprl, 0) In (1, 4))
                      And (NVL(Hrd_apprl, 0) = 0)
                      And (NVL(Hod_apprl, 0) = 0)
                      And A.EmpNo = B.EmpNo
                      And A.EmpNo In
                          (
                             Select empno
                               From SS_EmplMast
                              Where Mngr In
                                    (Select Mngr From SS_Delegate Where empno = Trim(v_hod_empno)
                                    )
                          )
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                  Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HRDREASON As Hr_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (nvl(Lead_apprl, 0) In (1, 4))
                      And (nvl(Hod_apprl, 0) = 1)
                      And A.EmpNo = B.EmpNo
                      And (nvl(Hrd_apprl, 0) = 0)
                    Order By Parent, A.empno

                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      Return c;
   End fn_pending_hr_approval;

Procedure sp_holiday_details(
          p_person_id            Varchar2,
          p_meta_id              Varchar2,

          p_Application_Id       Varchar2,

          P_Employee            Out Varchar2,
          P_PROJNO           Out Varchar2,
          P_Lead_Name        Out Varchar2,
          P_Attendance_Date  Out Varchar2,
          P_Punch_In_Time    Out Varchar2,
          P_Punch_Out_Time   Out Varchar2,
          P_REMARKS          Out Varchar2,
          P_Office           Out Varchar2,
          P_LEAD_APPRL       Out Varchar2,
          P_LEAD_APPRL_DATE  Out Varchar2,
          P_LEAD_APPRL_EMPNO Out Varchar2,
          P_HOD_APPRL        Out Varchar2,
          P_HOD_APPRL_DATE   Out Varchar2,
          P_HR_APPRL         Out Varchar2,
          P_HR_APPRL_DATE    Out Varchar2,
          P_DESCRIPTION      Out Varchar2,
          P_Application_Date Out Varchar2,
          P_HOD_Remarks      Out Varchar2,
          P_Hr_Remarks       Out Varchar2,
          P_Lead_Remarks     Out Varchar2,

          p_message_type     Out Varchar2,
          p_message_text     Out Varchar2
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

   Select A.EMPNO ||' - ' ||GetEmpName(A.EMPNO) As Employee,
          A.PROJNO As PROJNO,
          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
          to_char(A.PDATE, 'dd-Mon-yyyy') As Attendance_Date,
          to_char(A.START_HH)
          || ':'
          || to_char(A.START_MM) As Punch_In_Time,
          to_char(A.END_HH)
          || ':'
          || to_char(A.END_MM) As Punch_Out_Time,
          A.REMARKS As,
          A.LOCATION As office,
          Case A.LEAD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end  As Lead_Apprl,
          to_char(A.LEAD_APPRL_DATE, 'dd-Mon-yyyy') As LEAD_APPRL_DATE,
          A.LEAD_APPRL_EMPNO As LEAD_APPRL_EMPNO,
          Case A.HOD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end As HOD_APPRL,
          to_char(A.HOD_APPRL_DATE, 'dd-Mon-yyyy') As HOD_APPRL_DATE,
          Case A.HRD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end  As HR_APPRL,
          to_char(A.HRD_APPRL_DATE, 'dd-Mon-yyyy') As HR_APPRL_DATE,
          A.DESCRIPTION As DESCRIPTION,
          to_char(A.app_date, 'dd-Mon-yyyy') As Application_Date,
          A.HODREASON As HOD_Remarks,
          A.HRDREASON As Hr_Remarks,
          A.LEAD_REASON As Lead_Remarks
     Into P_Employee,
          P_PROJNO,
          P_Lead_Name,
          P_Attendance_Date,
          P_Punch_In_Time,
          P_Punch_Out_Time,
          P_REMARKS,
          P_Office,
          P_LEAD_APPRL,
          P_LEAD_APPRL_DATE,
          P_LEAD_APPRL_EMPNO,
          P_HOD_APPRL,
          P_HOD_APPRL_DATE,
          P_HR_APPRL,
          P_HR_APPRL_DATE,
          P_DESCRIPTION,
          P_Application_Date,
          P_HOD_Remarks,
          P_Hr_Remarks,
          P_Lead_Remarks
     From SS_HOLIDAY_ATTENDANCE A
    Where A.APP_NO = P_Application_Id;

   p_message_type := 'OK';
   p_message_text := 'Procedure executed successfully.';

   Exception
   When Others Then
      p_message_type := 'KO';
      p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

End sp_holiday_details;

   --  GRANT EXECUTE ON "IOT_HOLIDAY_QRY" TO "TCMPL_APP_CONFIG";

End iot_holiday_qry;
/

Grant Execute On "SELFSERVICE"."IOT_HOLIDAY_QRY" To "TCMPL_APP_CONFIG";