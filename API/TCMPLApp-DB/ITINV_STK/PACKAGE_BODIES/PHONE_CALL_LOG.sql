--------------------------------------------------------
--  DDL for Package Body PHONE_CALL_LOG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."PHONE_CALL_LOG" As
    /*
    C O M M A   delimited to  T A B L E
    */

        Function comma_to_table ( p_list In Varchar2 ) Return typ_str_tab
                Pipelined
        As
                l_string Long := p_list || ',';
                l_comma_index Pls_Integer;
                l_index Pls_Integer := 1;
        Begin
                Loop
                        l_comma_index := instr(l_string,',',l_index);
                        Exit When l_comma_index = 0;
                        Pipe Row ( trim(substr(l_string,l_index,l_comma_index - l_index) ) );
                        l_index := l_comma_index + 1;
                End Loop;

                return;
        End comma_to_table;
   /*
    GET  C O U N T R Y   D E T A I L S  from Phone Number
    */

        Function get_country_details_from_phone ( param_phone_no Varchar2 ) Return ph_country_master%rowtype Is
                v_cn_dial_code Number(6);
                Type type_num_ary Is
                        Varray ( 5 ) Of Number;
                v_ary_nums type_num_ary := type_num_ary(6,4,3,2,1);
                v_cntry_row ph_country_master%rowtype;
        Begin
                If
                        substr(param_phone_no,1,2) <> '00'
                Then
                        Return Null;
                End If;

                For indx In 1..v_ary_nums.count Loop
                        Begin
                                Select
                                        *
                                Into
                                        v_cntry_row
                                From ph_country_master Where
                                        dial_code = to_number(substr(param_phone_no,1,v_ary_nums(indx) + 2) );

                                Exit;
                        Exception
                                When Others Then
                                        Null;
                        End;
                End Loop;

                Return v_cntry_row;
        Exception
                When Others Then
                        Return v_cntry_row;
        End get_country_details_from_phone;
    /*
    GET  C O U N T R Y  from Phone Number
    */

        Function get_phone_country ( param_phone_no Varchar2 ) Return Varchar2 As
                v_cntry_row ph_country_master%rowtype;
        Begin
                v_cntry_row := get_country_details_from_phone(param_phone_no);
                If
                        v_cntry_row.dial_code Is Not Null
                Then
                        Return v_cntry_row.country_name;
                End If;
                Return Null;
        End get_phone_country;
    /*
    GET  R A T E  from Phone Number
    */

        Function get_phone_rate ( param_phone_no Varchar2 ) Return Varchar2 As
                v_cntry_row ph_country_master%rowtype;
        Begin
                v_cntry_row := get_country_details_from_phone(param_phone_no);
                If
                        v_cntry_row.dial_code Is Not Null
                Then
                        Return v_cntry_row.rate_per_min;
                End If;
                Return Null;
        End get_phone_rate;
    
    /*
    INTERNATIONAL CALL REPORT
    */

        Function isd_call_report ( param_start_date varchar2,param_end_date varchar2,param_extensions Varchar2 ) Return typ_tab_call_log
                pipelined
        As
                v_end_date varchar2(20) ;
                v_ary_ext typ_str_tab;
                v_table_call_log typ_tab_call_log;
        Begin
                If
                        param_start_date Is Null 
                Then
                        return ;
                        --pipe row(v_table_call_log);
                End If;
                v_end_date := nvl(param_end_date,param_start_date) || '2359';
                If
                        param_extensions Is Not Null
                Then
                        Select call_start,call_from,call_to,call_to_final,call_connect,call_dis_connect,last_redirect_dn,call_duration,call_cntry,rate_per_min
                                ,round(call_duration / 60 * rate_per_min,2) call_cost Bulk Collect Into
                                v_table_call_log
                        From
                                ( Select a.call_start,a.call_from,a.call_to,a.call_to_final,a.call_connect,a.call_dis_connect,a.last_redirect_dn,a.call_duration,phone_call_log
                                        .get_phone_country(a.call_to) call_cntry,phone_call_log.get_phone_rate(a.call_to) rate_per_min From
                                        ss_vu_phone_call_log a
                                Where
                                        a.call_start Between To_Date(param_start_date,'dd-Mon-yyyy') And To_Date(v_end_date,'dd-Mon-yyyyHH24MI') And a.call_from Like '104%' And a.call_to
                                        Like '00%' And call_from In ( Select column_value From Table ( comma_to_table(param_extensions) ) )
                                );

                Else
                        Select call_start,call_from,call_to,call_to_final,call_connect,call_dis_connect,last_redirect_dn,call_duration,call_cntry,rate_per_min
                                ,round(call_duration / 60 * rate_per_min,2) call_cost Bulk Collect Into
                                v_table_call_log
                        From
                                ( Select a.call_start,a.call_from,a.call_to,a.call_to_final,a.call_connect,a.call_dis_connect,a.last_redirect_dn,a.call_duration,phone_call_log
                                        .get_phone_country(a.call_to) call_cntry,phone_call_log.get_phone_rate(a.call_to) rate_per_min From
                                        ss_vu_phone_call_log a
                                Where
                                        a.call_start Between To_Date(param_start_date,'dd-Mon-yyyy') And To_Date(v_end_date,'dd-Mon-yyyyHH24MI') And a.call_from Like '104%' And a.call_to
                                        Like '00%' 
                                );

                End If;
                
                for indx in 1..v_table_call_log.count loop
                        Pipe Row(v_table_call_log(indx));
                end loop;
                
                --return (v_table_call_log);
                
/*
                Select
                        *
                Bulk Collect Into
                        v_tab_call_log
                From ss_vu_phone_call_log Where
                        call_from In ( Select column_value From Table ( comma_to_table(param_extensions) ) );
*/
        End;

End phone_call_log;

/
