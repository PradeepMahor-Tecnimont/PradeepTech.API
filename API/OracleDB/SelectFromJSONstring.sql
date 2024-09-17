
Select
    *
From
    Json_Table('[{"name":"Devendra","gender":"Male"},{"name":"rajan","gender":"Male"}]', '$[*]'
        Columns (name   Varchar2(4000)
            Path '$.name',
                 gender Varchar2(4000)
            Path '$.gender'));
            
            
/*            

With
    all_objects_data As (
        Select
            empno, name, parent
        From
            emplmast
        Where
            empno = '02320'
    )
Select
    column_name,
    column_value
From
    all_objects_data
    Unpivot (column_value
    For column_name
    In (empno as 'SP_PROC_NAME', name, parent));

*/