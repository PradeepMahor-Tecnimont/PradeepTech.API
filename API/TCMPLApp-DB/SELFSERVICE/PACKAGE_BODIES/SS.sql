--------------------------------------------------------
--  DDL for Package Body SS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SS" as

    function ss_false return number as
    begin
    /* TODO implementation required */
        return n_false;
    end ss_false;

    function ss_true return number as
    begin
        return n_true;
    end;

    function ot_approved return number as
    begin
        return n_ot_approved;
    end;

    function ot_rejected return number as
    begin
        return n_ot_rejected;
    end;

    function ot_re_apply return number as
    begin
        return n_ot_re_apply;
    end;

    function ot_pending return number as
    begin
        return n_ot_pending;
    end;

    function ot_lead_none return varchar2 as
    begin
        return c_ot_lead_none;
    end;

    function ot_apprl_none return number as
    begin
        return n_ot_apprl_none;
    end;

    function approved return number as
    begin
        return n_ot_approved;
    end;

    function rejected return number as
    begin
        return n_ot_rejected;
    end;

    function disapproved return number as
    begin
        return n_disapproved;
    end;

    function re_apply return number as
    begin
        return n_ot_re_apply;
    end;

    function pending return number as
    begin
        return n_ot_pending;
    end;


    function lead_none return varchar2 as
    begin
        return c_ot_lead_none;
    end;

    function apprl_none return number as
    begin
        return n_ot_apprl_none;
    end;

    function success return number as
    begin
        return n_success;
    end;

    function failure return number as
    begin
        return n_failure;
    end;

    function warning return number as
    begin
        return n_warning;
    end;

    function rep_srv_nm return varchar2 as
    begin
        return c_rep_srv_nm;
    end rep_srv_nm;

    function rep_srv_url return varchar2 as
    begin
        return c_rep_srv_url;
    end rep_srv_url;

    function rep_env_id return varchar2 as
    begin
        return c_rep_env_id;
    end rep_env_id;

    function webutil_upload_dir return varchar2 as
    begin
        return c_webutil_upload_dir;
    end webutil_upload_dir;

    function opening_bal return number as
    begin
        return n_opening_bal;
    end;

    function closing_bal return number as
    begin
        return n_closing_bal;
    end;

    function application_url return varchar2 is
    begin
        return c_appl_url;
    end;

    function approval_text (
        param_status number
    ) return varchar2 is
        v_status    number;
        v_ret_val   varchar2(30);
    begin
        v_status   := nvl(param_status,ss.pending);
        case
            when v_status = ss.pending then
                v_ret_val   := 'Pending';
            when v_status = ss.approved then
                v_ret_val   := 'Approved';
            when v_status = ss.disapproved then
                v_ret_val   := 'Rejected';
            when v_status = ss.rejected then
                v_ret_val   := 'Rejected';
            when v_status = ss.ot_apprl_none then
                v_ret_val   := 'NONE';
            else
                v_status   := '';
        end case;

        return v_ret_val;
    end;

    function csv_to_table (
        p_list in varchar2
    ) return typ_str_tab
        pipelined
    as
        l_string        long := p_list || ',';
        l_comma_index   pls_integer;
        l_index         pls_integer := 1;
    begin
        loop
            l_comma_index   := instr(l_string,',',l_index);
            exit when l_comma_index = 0;
            pipe row ( trim(substr(l_string,l_index,l_comma_index - l_index) ) );
            l_index         := l_comma_index + 1;
        end loop;

        return;
    end csv_to_table;

    function get_empno (
        param_user_id varchar2
    ) return varchar2 is
        v_user_domain   varchar2(30);
        v_user_id       varchar2(30);
        v_empno         varchar2(5);
    begin
        if instr(param_user_id,'\') > 0 then
            v_user_domain   := substr(param_user_id,1,instr(param_user_id,'\') - 1);

            v_user_id       := substr(param_user_id,instr(param_user_id,'\') + 1);
            begin
                select
                    a.empno
                into v_empno
                from
                    userids a,
                    ss_emplmast b
                where
                    a.empno = b.empno
                    and userid = upper(trim(v_user_id) )
                    and domain = upper(trim(v_user_domain) )
                    and b.status = 1;

                return v_empno;
            exception
                when others then
                    return 'FALSE';
            end;

        elsif instr(param_user_id,'@') > 0 then
            select
                empno
            into v_empno
            from
                ss_emplmast
            where
                email = param_user_id
                and status = 1;

            return v_empno;
        end if;

        return nvl(v_empno,'XYZ11');
    end;

    function ldt_onduty return number is
    begin
        return n_ldt_onduty;
    end;

    function ldt_missed_punch return number is
    begin
        return n_ldt_missed_punch;
    end;

    function ldt_depu return number is
    begin
        return n_ldt_depu;
    end;

    function ldt_leave return number is
    begin
        return n_ldt_leave;
    end;

end ss;


/

  GRANT EXECUTE ON "SELFSERVICE"."SS" TO "TCMPL_APP_CONFIG";
