--------------------------------------------------------
--  DDL for Package Body OD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "OD" 
AS
    PROCEDURE nu_app_send_mail(
        param_app_no VARCHAR2, param_success out number, param_message out varchar2)
    AS
      v_count number;
      v_lead_code varchar2(5);
      v_lead_apprl number;
      v_empno varchar2(5);
      v_email_id varchar2(60);
      vsubject varchar2(100);
      vbody varchar2(5000);
    BEGIN
      Select count(*) into v_count from ss_ondutyapp where trim(APP_NO) = trim(param_app_no);
      If v_count <> 1 Then
          return;
      End If;
      select lead_code, lead_apprl, empno into v_lead_code, v_lead_apprl , v_empno
        from ss_ondutyapp where  trim(APP_NO) = trim(param_app_no);
      
      If trim(nvl(v_lead_code, ss.lead_none)) = trim(ss.lead_none) then
          select email into v_email_id from ss_emplmast where empno = (Select mngr from ss_emplmast where empno = v_empno);
      Else
          select email into v_email_id from ss_emplmast where empno = v_lead_code;
      End If;
      If v_email_id is null Then
          param_success := ss.failure;
          param_message := 'Email Id of the approver found blank. Cannot send email.';
          return ;
      End If;
        --v_email_id := 'd.bhavsar@ticb.com';
        vSubject := 'Application of ' || v_empno;

        vBody := 'There is ' || vSubject || '. Kindly click the following URL to do the needful.';
        vBody := vBody || '!nuLine!' || ss.application_url || '/SS_OD.asp?App_No=' || param_app_no;
        vBody := vBody || '!nuLine!'  || '!nuLine!'  || '!nuLine!'  || '!nuLine!'  || 'Note : This is a system generated message.';

      SS_MAIL.send_mail(v_email_id,vSubject,vBody,param_success, param_message );
      
    END nu_app_send_mail;
    
    
    FUNCTION test_func
      RETURN NUMBER
    IS
    BEGIN
      RETURN 1;
    END test_func;


    procedure approve_od
    ( param_array_app_no varchar2, param_array_rem varchar2, param_array_od_type varchar2, param_array_apprl_type varchar2, 
        param_approver_profile number,
        param_approver_code varchar2 , param_approver_ip varchar2, param_success out varchar2 , param_message out varchar2 ) 
    as
        OnDuty constant number := 2;
        Deputation Constant number := 3;
        v_count number;
        Type type_app is table of varchar2(30) index by binary_integer;
        Type type_rem is table of varchar2(31) index by binary_integer;
        type type_od is table of varchar2(3) index by binary_integer;
        Type type_apprl is table of varchar2(3) index by binary_integer;
        
        tab_app type_app;
        tab_rem type_rem;
        tab_od type_od;
        tab_apprl type_apprl;
        v_rec_count number;
        
        sqlPartOD varchar2(60) := 'Update SS_OnDutyApp ';
        sqlPartDP varchar2(60) := 'Update SS_Depu ';
        sqlPart2 varchar2(500);
        strSql varchar2(600);
    begin
        sqlPart2 := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';

        If param_approver_profile = user_profile.type_HOD Or  param_approver_profile = user_profile.type_SEC  Then
            sqlPart2 := replace(sqlPart2,'ApproverProfile','HOD');
        ElsIf param_approver_profile = user_profile.type_HRD Then
            sqlPart2 := replace(sqlPart2,'ApproverProfile','HRD');
        ElsIf param_approver_profile = user_profile.type_Lead Then
            sqlPart2 := replace(sqlPart2,'ApproverProfile','LEAD');
        End If;
        
        with tab as (select param_array_app_no as txt_app from dual)
          select  REGEXP_SUBSTR (txt_app, '[^,]+', 1, level) bulk collect into tab_app
            from tab
          connect by level <= length(regexp_replace(txt_app,'[^,]*'));
        v_rec_count := Sql%rowcount;
        with tab as (select '  ' || param_array_rem as txt_rem from dual)
          select  REGEXP_SUBSTR (txt_rem, '[^,]+', 1, level) bulk collect into tab_rem
            from tab
          connect by level <= length(regexp_replace(txt_rem,'[^,]*'))+1;
        
        with tab as (select param_array_od_type as txt_od from dual)
          select  REGEXP_SUBSTR (txt_od, '[^,]+', 1, level) bulk collect into tab_od
            from tab
          connect by level <= length(regexp_replace(txt_od,'[^,]*'))+1;

        with tab as (select param_array_apprl_type as txt_apprl from dual)
          select  REGEXP_SUBSTR (txt_apprl, '[^,]+', 1, level) bulk collect into tab_apprl
            from tab
          connect by level <= length(regexp_replace(txt_apprl,'[^,]*'))+1;

        For indx in 1..tab_app.count loop
            If tab_od(indx) = Deputation Then
                StrSql := sqlPartDP || ' ' || sqlPart2;
            ElsIf tab_od(indx) = OnDuty Then
                StrSql := sqlPartOD || ' ' || sqlPart2;
            End If;
            EXECUTE IMMEDIATE strSql using Trim(tab_apprl(indx)), param_approver_code, param_approver_ip, trim(tab_rem(indx)), trim(tab_app(indx));
            If tab_od(indx) = OnDuty Then
            --IF 1=2 Then
                Insert into SS_OnDuty value (Select EmpNo, HH, MM, PDate, 0, dd,mon,yyyy,type,App_No, Description,GetODHH(app_no,1),
                  GetODMM(app_no,1),app_date,reason,ODType 
                  from SS_OnDutyApp where Trim(App_No) = Trim(tab_app(indx)));
                Insert into SS_OnDuty value (Select EmpNo, HH1, MM1, PDate, 0, dd,mon,yyyy,type,App_No, Description,GetODHH(app_no,2),
                  GetODMM(app_no,2),app_date,reason,ODType 
                  from SS_OnDutyApp where Trim(App_No) = Trim(tab_app(indx)) and (type = 'OD' or type = 'IO'));
                If param_approver_profile = user_profile.type_HRD Then
                  GENERATE_AUTO_PUNCH_4OD(Trim(tab_app(indx)));
                End If;
            End If;
        end loop;
        Commit;
        Param_Success := 'SUCCESS';
    Exception
      When Others then
        Param_Success := 'FAILURE';
        param_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    end;
END od;

/
