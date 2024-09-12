Create Or Replace Package Body "COMMONMASTERS"."PKG_ENVIRONMENT" As

    c_production_host_name       Constant Varchar2(30) := 'TPLOraDB';
    c_staging_host_name          Constant Varchar2(30) := 'TPLDevOraDB1';
    c_development_host_name      Constant Varchar2(30) := 'TPLDevOraDB1';

    c_production_db_unique_name  Constant Varchar2(30) := 'TPL11g';
    c_staging_db_unique_name     Constant Varchar2(30) := 'PDB_QUAL';
    c_development_db_unique_name Constant Varchar2(30) := 'PDB_DEV';

    ok                           Constant Char(2)      := 'OK';
    not_ok                       Constant Char(2)      := 'KO';

    --Database HostName
    Function fn_server_host_name Return Varchar2 Is
    Begin
        Return sys_context('USERENV', 'SERVER_HOST');
    End;

    --Database Unique Name
    Function fn_db_unique_name Return Varchar2 Is
    Begin
        Return sys_context('USERENV', 'DB_NAME');
    End;

    --Return DB Session User
    Function fn_db_session_user Return Varchar2 As
    Begin
        Return sys_context('USERENV', 'SESSION_USER');
    End;

    --Return Environment name
    Function fn_db_env_name Return Varchar2 Is
    Begin
        If is_development = ok Then
            Return 'Development';
        Elsif is_staging = ok Then
            Return 'Staging';
        Elsif is_production = ok Then
            Return 'Production';
        Else
            Return 'Unknown';
        End If;
    End;

    --Is Development OK\KO
    Function is_development Return Varchar2 As
        v_db_unique_name  Varchar2(30);
        v_server_hostname Varchar2(30);
    Begin
        v_server_hostname := fn_server_host_name;
        v_db_unique_name  := fn_db_unique_name;

        If upper(v_server_hostname) = upper(c_development_host_name) And upper(v_db_unique_name) = upper(c_development_db_unique_name)
        Then
            Return ok;
        Else
            Return not_ok;
        End If;

    End;

    --Is Staging OK\KO
    Function is_staging Return Varchar2 As
        v_db_unique_name  Varchar2(30);
        v_server_hostname Varchar2(30);
    Begin
        v_server_hostname := fn_server_host_name;
        v_db_unique_name  := fn_db_unique_name;

        If upper(v_server_hostname) = upper(c_staging_host_name) And upper(v_db_unique_name) = upper(c_staging_db_unique_name)
        Then
            Return ok;
        Else
            Return not_ok;
        End If;
    End;

    --Is Production OK\KO
    Function is_production Return Varchar2 As
        v_db_unique_name  Varchar2(30);
        v_server_hostname Varchar2(30);
    Begin
        v_server_hostname := fn_server_host_name;
        v_db_unique_name  := fn_db_unique_name;

        If upper(v_server_hostname) = upper(c_production_host_name) And upper(v_db_unique_name) = upper(c_production_db_unique_name)
        Then
            Return ok;
        Else
            Return not_ok;
        End If;
    End;

End;