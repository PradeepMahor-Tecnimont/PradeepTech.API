
set define off;
Create Or Replace Package Body "TCMPL_HR"."PKG_EMP_LOA_ADDENDUM_ACCEPTANCE_QRY" As

    Function fn_emp_loa_addendum_acceptance_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
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
                    with loa_events as (
                                 select event_id,
                                        empno
                                   from emp_loa_addendum_events
                                  where event_id = 2
                              )
                              select laa.empno as empno,
                                     get_emp_name(
                                        laa.empno
                                     ) as emp_name,
                                     e.parent
                                     || ' '
                                     || c.name as parent,
                                     e.assign
                                     || ' '
                                     || c1.name as assign,
                                     e.emptype as emptype,
                                     laa.acceptance_status as acceptance_status_val,
                                     fn_get_emp_relatives_loa_status(
                                        laa.acceptance_status
                                     ) as acceptance_status_text,
                                     laa.acceptance_date as acceptance_date,
                                     (
                                        case
                                           when laa.acceptance_status in ( 1,
                                                                           2 )
                                              and loa_ev.event_id is null then
                                              'No'
                                           when laa.acceptance_status in ( 1,
                                                                           2 )
                                              and loa_ev.event_id is not null then
                                              'Yes'
                                           else
                                              ''
                                        end
                                     ) as email_status,
                                     row_number()
                                     over(
                                         order by laa.empno
                                     ) row_number,
                                     count(*)
                                     over() total_row
                                from emp_loa_addendum_acceptance laa,
                                     vu_emplmast e,
                                     vu_costmast c,
                                     vu_costmast c1,
                                     loa_events loa_ev
                               where laa.empno = e.empno
                                 and c.costcode = e.parent
                                 and c1.costcode = e.assign
                                 and e.emptype in ( 'R',
                                                    'F' )
                                 and e.empno = loa_ev.empno (+)
                        And (upper(laa.empno) Like '%' || upper(Trim(p_generic_search)) || '%')
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_emp_loa_addendum_acceptance_list;

    Procedure sp_emp_loa_addendum_acceptance_details(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_empno                      Varchar2 Default Null,
        p_acceptance_status_val  Out Number,
        p_acceptance_status_text Out Varchar2,
        p_acceptance_date        Out Date,
        P_acceptance_text        Out Varchar2,
        P_Communication_Date       Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            acceptance_status,
            fn_get_emp_relatives_loa_status(acceptance_status),
            acceptance_date,
            fn_get_loa_status_text(empno,acceptance_status,acceptance_date)
        Into
            p_acceptance_status_val,
            p_acceptance_status_text,
            p_acceptance_date,
            P_acceptance_text
        From
            emp_loa_addendum_acceptance
        Where
            empno = nvl(p_empno, v_empno);
            
         Select to_char(
            communication_date,
            'dd-Mon-yyyy'
         )
           Into P_Communication_Date
           From emp_relatives_as_colleagues_comm;
         
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'No matching Emp l.o.a. addendum acceptance exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_loa_addendum_acceptance_details;

    Function fn_get_emp_relatives_loa_status(
        p_status_code In Number
    ) Return Varchar2 As
        v_status_desc emp_relatives_loa_status_mast.status_desc%Type;
    Begin
        Select
            status_desc
        Into
            v_status_desc
        From
            emp_relatives_loa_status_mast
        Where
            status_code = p_status_code;

        Return v_status_desc;
    Exception
        When Others Then
            Return '';
    End fn_get_emp_relatives_loa_status;

    Procedure sp_emp_loa_addendum_acceptance_widget(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_addendum_acceptance_rating Out Varchar2,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_count_accepted Number;
        v_count_total    Number;
    Begin
        v_empno                      := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(empno)
        Into
            v_count_accepted
        From
            emp_loa_addendum_acceptance
        Where
            acceptance_status = 1;

        Select
            Count(empno)
        Into
            v_count_total
        From
            emp_loa_addendum_acceptance;

        p_addendum_acceptance_rating := v_count_accepted || '/' || v_count_total;
        p_message_type               := ok;
        p_message_text               := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_addendum_acceptance_rating := '0';
            p_message_type               := not_ok;
            p_message_text               := 'Error in rating !!!';
    End;

  function fn_get_loa_status_text (
      p_empno           in varchar2,
      p_status_code     in number,
      p_Acceptance_Date in date default null
   ) return varchar2 as
      v_status_desc varchar2(100) :='';
      v_count       number;
   begin
      if ( p_status_code = 0 ) then
            return 'NA';
      elsif ( p_status_code = 1 ) then
         v_status_desc := 'Accepted the above terms & conditions on ' || to_char(p_Acceptance_Date, 'dd-Mon-yyyy HH24:mi:ss' );
      elsif ( p_status_code = 2 ) then
         v_status_desc := 'Deemed Confirmation on ' || to_char( p_Acceptance_Date, 'dd-Mon-yyyy HH24:mi:ss' );      
      end if;

      select count(*)
        into v_count
        from emp_loa_addendum_events
       where empno = p_empno
         and event_id != 2;
         
       if ( v_count = 0 ) then
            v_status_desc := v_status_desc || '.  Email_Pending';
         end if;
      
      return v_status_desc;
   exception
      when others then
         return 'exception' || p_Acceptance_Date;
   end fn_get_loa_status_text;
 
End pkg_emp_loa_addendum_acceptance_qry;