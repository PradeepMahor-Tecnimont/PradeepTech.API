--------------------------------------------------------
--  DDL for Procedure VACCINE_BATCH_SEND_MAIL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."VACCINE_BATCH_SEND_MAIL" (
    param_batch_id In Varchar2
) As

    Cursor cur_emp_list Is
    Select
        e.empno,
        e.name emp_name,
        Nvl(email, ad.emp_upn) emp_email,
        time_slot,
        transport,
        be.jab_for_this_slot,
        bus_route_id,
        bus_pickup_points,
        bus_start_time,
        bus_mobile
    From
        ss_emplmast                    e,
        commonmasters.emp_ad_details   ad,
        swp_tpl_vaccine_batch_emp      be
    Where
        e.empno = be.empno
        And e.empno = ad.empno (+)
        And e.empno In (
            '11606',
            '03824'
        )
        And e.empno Not In (
            Select
                empno
            From
                swp_mail_log
        )
    Order By
        e.empno;

    Type type_tab_emp_list Is
        Table Of cur_emp_list%rowtype;
    tab_emp_list        type_tab_emp_list;
    v_null              Varchar2(1);
    v_mail_subject      Varchar2(200);
    v_mail_body         Varchar2(4000);
    v_mail_body_const   Varchar2(4000);
    v_success           Varchar2(100);
    v_message           Varchar2(1000);
Begin
    v_mail_subject      := 'TCMPL Vaccination Drive on 12th June 2021';
    v_mail_body_const   := '
	<p>Dear <EMPNAME>,</p>
	<p>Your vaccination has been scheduled on Saturday 12<sup>th</sup> June 2021 at TCMPL Office Premises Mumbai &ndash; MOC1 following your successful registration for the TCMPL Vaccination Drive.</p>
	<p>You will travel by Own arrangement/ Office Bus as opted by you at the time of Registration.</p>
	<p>Please refer below for further details.</p>
	<table style="border-collapse: collapse; width: 600px; min-hieght: 154px;" border="1">
	<tbody>
	<tr style="min-hieght: 18px;">
	<td style="width: 34.1339%; min-hieght: 18px;">Time Slot</td>
	<td style="width: 61.6448%; min-hieght: 18px;">!TIMESLOT!</td>
	</tr>
	<tr style="min-hieght: 18px;">
	<td style="width: 34.1339%; min-hieght: 18px;">Mode of Transport</td>
	<td style="width: 61.6448%; min-hieght: 18px;">!TRANSPORT!</td>
	</tr>
	<tr style="min-hieght: 18px;">
	<td style="width: 34.1339%; min-hieght: 18px;">Bus Route no.</td>
	<td style="width: 61.6448%; min-hieght: 18px;">!BUSROUTE!</td>
	</tr>
	<tr style="min-hieght: 18px;">
	<td style="width: 34.1339%; min-hieght: 18px;">Bus Pickup Points</td>
	<td style="width: 61.6448%; min-hieght: 18px;">!BUSPICKUPPOINT!</td>
	</tr>
	<tr style="min-hieght: 18px;">
	<td style="width: 34.1339%; min-hieght: 18px;">Bus First Pickup Time</td>
	<td style="width: 61.6448%; min-hieght: 18px;">!BUSSTARTTIME!</td>
	</tr>
	<tr style="min-hieght: 18px;">
	<td style="width: 34.1339%; min-hieght: 18px;">Driver / Coordinator Contact No</td>
	<td style="width: 61.6448%; min-hieght: 18px;">!BUSMOBILE!</td>
	</tr>
	</tbody>
	</table>
	<p>&nbsp;</p>
	<p>Requesting your Cooperation</p>
	<p>&nbsp;</p>
	<p>Regards,</p>
	<p>GENSE</p>
'
    ;
    Open cur_emp_list;
    Loop
        Fetch cur_emp_list Bulk Collect Into tab_emp_list Limit 100;
        For i In 1..tab_emp_list.count Loop
            v_mail_body   := v_mail_body_const;
            If tab_emp_list(i).emp_email Is Not Null Then
                v_mail_body   := Replace(v_mail_body, '"', Chr(39));
                v_mail_body   := Replace(v_mail_body, Chr(10), '');
                v_mail_body   := Replace(v_mail_body, Chr(13), '');
                v_mail_body   := Replace(v_mail_body, '<EMPNAME>', tab_emp_list(i).empno || ' - ' || tab_emp_list(i).emp_name);

                v_mail_body   := Replace(v_mail_body, '!TIMESLOT!', Replace(Replace(Replace(tab_emp_list(i).time_slot, Chr(10), '')
                , Chr(13), ''), '"', ''));

                v_mail_body   := Replace(v_mail_body, '!TRANSPORT!', Replace(Replace(Replace(tab_emp_list(i).transport, Chr(10), ''
                ), Chr(13), ''), '"', ''));

                v_mail_body   := Replace(v_mail_body, '!BUSROUTE!', Replace(Replace(Replace(tab_emp_list(i).bus_route_id, Chr(10), ''
                ), Chr(13), ''), '"', ''));

                v_mail_body   := Replace(v_mail_body, '!BUSPICKUPPOINT!', Replace(Replace(Replace(tab_emp_list(i).bus_pickup_points
                , Chr(10), ''), Chr(13), ''), '"', ''));

                v_mail_body   := Replace(v_mail_body, '!BUSSTARTTIME!', Replace(Replace(Replace(tab_emp_list(i).bus_start_time, Chr
                (10), ''), Chr(13), ''), '"', ''));

                v_mail_body   := Replace(v_mail_body, '!BUSMOBILE!', Replace(Replace(Replace(Replace(tab_emp_list(i).bus_mobile, Chr
                (10), ''), Chr(13), '<br />'), '"', ''), '"', ''));

                send_mail_from_api(
                    p_mail_to        => tab_emp_list(i).emp_email,
                    p_mail_cc        => Null,
                    p_mail_bcc       => Null,
                    p_mail_subject   => v_mail_subject,
                    p_mail_body      => v_mail_body,
                    p_mail_profile   => 'GENSE',
                    p_mail_format    => 'HTML',
                    p_success        => v_success,
                    p_message        => v_message
                );

                Insert Into swp_mail_log (
                    empno,
                    msg,
                    modified_on
                ) Values (
                    tab_emp_list(i).empno,
                    v_success || ' - ' || v_message || ' - ' || tab_emp_list(i).emp_email,
                    Sysdate
                );

                Commit;
            End If;

            v_mail_body   := Null;
        End Loop;

        Exit When cur_emp_list%notfound;
    End Loop;

    Close cur_emp_list;
End vaccine_batch_send_mail;


/
