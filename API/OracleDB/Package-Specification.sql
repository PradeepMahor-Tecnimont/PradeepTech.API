Create Or Replace  Package schema_name.package-name As
	--PUBLIC
	
    Function fn_public_function(
        p_person_id      		Varchar2,
        p_meta_id        		Varchar2,

        p_generic_search 		Varchar2 Default Null,
        p_param_1 				Varchar2 Default Null,
        p_param_2 				Varchar2,
        
        p_row_number     		Number,
        p_page_length    		Number
    ) Return Sys_Refcursor;

    procedure sp_public_procedure(
        p_person_id      		Varchar2,
        p_meta_id        		Varchar2,

        
        p_param_1 				Varchar2 Default Null,
        p_param_2 				Varchar2,
        
        p_message_type        	Out Varchar2,
        p_message_text        	Out Varchar2
        
    ) ;

End package-name;
/