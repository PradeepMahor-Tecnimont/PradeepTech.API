Create Or Replace Package Body schema_name.package-name As
	--PRIVATE
	
    Function fnc_PRIVATE_function(
        p_person_id      		Varchar2,
        p_meta_id        		Varchar2
    ) return Varchar2 as
        v_empno               Varchar2(5);
        v_hod_sec_assign_code Varchar2(4);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
		
		return 'XYZ';
	End;


    Procedure prc_private_procedure(
        p_person_id      	Varchar2,
        p_meta_id        	Varchar2,

        p_param_1 			Varchar2 Default Null,
        p_param_2 			Varchar2,
        
        p_message_type        	Out Varchar2,
        p_message_text        	Out Varchar2
        
    ) As
        v_empno        Varchar2(5);
        
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
		
		--Business Logic
		
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
	
	End;


	--PUBLIC
	
    Function fn_public_function(
        p_person_id      		Varchar2,
        p_meta_id        		Varchar2,

        p_generic_search 		Varchar2 Default Null,
        p_param_1 				Varchar2 Default Null,
        p_param_2 				Varchar2,
        
        p_row_number     		Number,
        p_page_length    		Number
    ) Return Sys_Refcursor is
		c                     Sys_Refcursor;
        v_count               Number;
        v_empno               Varchar2(5);
        v_hod_sec_assign_code Varchar2(4);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Null Then
            v_generic_search := '%';
        Else
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        End If;
		
        Open c For
            Select
                *
            From
                (

                    Select
                        a.*,
                        Row_Number() Over (Order By 1 Desc, 2) row_number,
                        Count(*) Over ()                                         total_row
                    From
                        tab a
                        where a.tname like v_generic_search
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        		
		return c;
	End;

    procedure sp_public_procedure(
        p_person_id      		Varchar2,
        p_meta_id        		Varchar2,

        
        p_param_1 				Varchar2 Default Null,
        p_param_2 				Varchar2,
        
        p_message_type        	Out Varchar2,
        p_message_text        	Out Varchar2
        
    ) As
        v_empno        Varchar2(5);
        
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
		
		--Business Logic
		
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
	p_message_text := log_db_exception(
                                  p_backtrace_message => dbms_utility.format_error_backtrace,
                                  p_error_message     => sqlerrm,
                                  p_emp_id            => p_meta_id / v_empno / null
                              );
	End;
	
End package-name;
/