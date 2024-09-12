
    procedure sp_procedure(
        p_person_id      		Varchar2,
        p_meta_id        		Varchar2,

        
        p_param_1 				Varchar2 Default Null,
        p_param_2 				Varchar2,
        
        p_message_type        	Out Varchar2,
        p_message_text        	Out Varchar2
        
    ) As
        v_empno        Varchar2(5);
        Cursor C1 is select * from tab;
		Type typ_tab_c1 is table of c1%rowtype;
		tab_c1 typ_tab_c1;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
		
        Open C1;
        Loop
		
            Fetch C1 Bulk Collect Into tab_c1 Limit 50;
            For i In 1..tab_c1.count Loop
				--Business Logic
                null;
			End Loop;
		
			Exit when c1%notfound;

		End Loop;
		
		
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
	
	End;