namespace WinFormsCodeGenerator.CustomClass
{
    public class PackageBady
    {
        public string schemaName = " ";
        public string packageName = "";

        public string start = "";

        public string tableName = "";
        public string titleNameInMsg = "";
        public string tableColsName = "";
        public string tableColsType = "";
        public string tableColsList = "";

        public string add = "";
        public string update = "";
        public string delete = "";

        public string end = "";

        public string GeneratePackage(string vSchemaName, string vPackageName, string vTableName, string vTitleNameInMsg, List<OraDbObjects> listOraDbObjects)
        {
            schemaName = vSchemaName;
            packageName = vPackageName;
            tableName = vTableName;
            titleNameInMsg = vTitleNameInMsg.ToLower();
            titleNameInMsg = char.ToUpper(titleNameInMsg[0]) + titleNameInMsg[1..];

            start = "Create Or Replace Package Body \"" + vSchemaName.Trim().ToUpper() + "\".\"" + vPackageName.Trim().ToUpper() + "\" As \n";

            add = $@"
                    Procedure sp_add_{vTableName}(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {AddGeneratOraInParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    ) As
                        v_exists       Number;
                        v_empno        Varchar2(5);
                        v_keyId        Varchar2({listOraDbObjects[0].ColLenth});
                        v_user_tcp_ip  Varchar2(5) := 'NA';
                        v_message_type Number      := 0;
                    Begin
                        v_empno := get_empno_from_meta_id(p_meta_id);

                        If v_empno = 'ERRRR' Then
                            p_message_type := 'KO';
                            p_message_text := 'Invalid employee number';
                            Return;
                        End If;

                        v_keyId := dbms_random.string('X', {listOraDbObjects[0].ColLenth});

                        Select
                            Count(*)
                        Into
                            v_exists
                        From
                            {vTableName}
                        Where
                            Trim(upper({listOraDbObjects[1].ColName})) = Trim(upper(p_{listOraDbObjects[1].ColName}));

                        If v_exists = 0 Then
                            {InsertGenerat(listOraDbObjects)}

                            Commit;

                            p_message_type       := 'OK';
                            p_message_text := '{titleNameInMsg} added successfully..';
                        Else
                            p_message_type := 'KO';
                            p_message_text := '{titleNameInMsg} already exists !!!';
                        End If;

                    Exception
                        When Others Then
                            p_message_type := 'KO';
                            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

                    End sp_add_{vTableName};

                ";

            update = $@"
                    Procedure sp_update_{vTableName}(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {UpdateGeneratOraInParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    ) As
                        v_exists       Number;
                        v_empno        Varchar2(5);
                        v_user_tcp_ip  Varchar2(5) := 'NA';
                        v_message_type Number      := 0;
                    Begin
                        v_empno := get_empno_from_meta_id(p_meta_id);

                        If v_empno = 'ERRRR' Then
                            p_message_type := 'KO';
                            p_message_text := 'Invalid employee number';
                            Return;
                        End If;

                        Select
                            Count(*)
                        Into
                            v_exists
                        From
                            {vTableName}
                        Where
                            {listOraDbObjects[0].ColName} = p_{listOraDbObjects[0].ColName};

                        If v_exists = 1 Then

                            {UpdateGenerat(listOraDbObjects)}

                            Commit;

                            p_message_type       := 'OK';
                            p_message_text := '{titleNameInMsg} updated successfully.';
                        Else
                            p_message_type := 'KO';
                            p_message_text := 'No matching {titleNameInMsg} exists !!!';
                        End If;
                    Exception
                        When dup_val_on_index Then
                            p_message_type := 'KO';
                            p_message_text := '{titleNameInMsg} already exists !!!';
                        When Others Then
                            p_message_type := 'KO';
                            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

                    End sp_update_{vTableName};

            ";

            delete = $@"
                    Procedure sp_delete_{vTableName}(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {DeleteGeneratOraInParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    ) As
                        v_empno        Varchar2(5);
                        v_is_used      Number;
                        v_user_tcp_ip  Varchar2(5) := 'NA';
                        v_message_type Number      := 0;
                    Begin
                        v_empno        := get_empno_from_meta_id(p_meta_id);

                        If v_empno = 'ERRRR' Then
                            p_message_type := 'KO';
                            p_message_text := 'Invalid employee number';
                            Return;
                        End If;

                       /* Select
                            Count(*)
                        Into
                            v_is_used
                        From
                            tblName
                        Where
                            keyId = p_keyId;

                        If v_is_used > 0 Then
                            p_message_type := 'KO';
                            p_message_text := 'Record cannot be delete, this record already used !!!';
                            Return;
                        End If;
                        */

                        {DeleteGenerat(listOraDbObjects)}

                        If ( Sql%rowcount > 0 ) Then
                            Commit;
                            p_message_type := 'OK';
                            p_message_text := 'Procedure executed successfully.';
                        Else
                            p_message_type := 'KO';
                            p_message_text := 'Procedure not executed.';
                        End If;

                    Exception
                        When Others Then
                            p_message_type := 'KO';
                            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

                    End sp_delete_{vTableName};

            ";

            end = $"End {vPackageName.Trim().ToLower()}; \n / \n Grant Execute On   \"{vSchemaName.Trim().ToUpper()}\".\"{vPackageName.Trim().ToUpper()}\"  To \"TCMPL_APP_CONFIG\";";

            return start + add + update + delete + end;
        }

        //v_job_key_id   := dbms_random.string('X', 8);
        private string AddGeneratOraInParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "";
            try
            {
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColDefauldVal != null)
                    {
                        if (item.ColDefauldVal.ToUpper() == "SYSDATE")
                        {
                            continue;
                        }
                    }
                    if (item.ColKeyName != "PK")
                    {
                        RetVal += $"P_{item.ColName}           {item.ColType},  \n";
                    }
                }
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string InsertGenerat(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "";
            try
            {
                RetVal = $" Insert Into {tableName}  \n";
                RetVal += $"(\n";
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    RetVal += $"{item.ColName},";
                }
                RetVal = RetVal.Trim(',');

                RetVal += $"\n)\n";
                RetVal += $"\n Values \n";
                RetVal += $"(\n";
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColDefauldVal != null)
                    {
                        if (item.ColDefauldVal.ToUpper() == "SYSDATE")
                        {
                            RetVal += $"{item.ColDefauldVal.ToLower()},";
                            continue;
                        }
                    }

                    if (item.ColType.ToUpper() == "VARCHAR2".ToUpper())
                    {
                        if (item.ColKeyName != null)
                        {
                            if (item.ColKeyName.ToUpper() == "PK")
                            {
                                RetVal += $"v_keyId ,";
                            }
                            else
                            {
                                RetVal += $"Trim(P_{item.ColName}),";
                            }
                        }
                        else
                        {
                            RetVal += $"Trim(P_{item.ColName}),";
                        }
                        //RetVal += $"Trim(P_{item.ColName}),";
                    }
                    else if (item.ColType.ToUpper() == "CHAR".ToUpper())
                    {
                        RetVal += $"Trim(P_{item.ColName}),";
                    }
                    else
                    {
                        RetVal += $"P_{item.ColName},";
                    }
                }
                RetVal = RetVal.Trim(',');
                RetVal = RetVal.Replace(",", ",\n");

                RetVal += $"\n)\n; \n";
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string UpdateGenerat(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "";
            string whereString = "";
            whereString += $"\n Where \n";
            try
            {
                /*
                  Update
                                sub_business_line
                            Set
                                short_description = Trim(upper(p_short_description)),
                                description = Trim(p_description)
                            Where
                                code = p_code;
                 */

                RetVal = $" Update {tableName}  \n";
                RetVal += $" Set \n";
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColDefauldVal != null)
                    {
                        if (item.ColDefauldVal.ToUpper() == "SYSDATE")
                        {
                            RetVal += $"{item.ColName} = {item.ColDefauldVal.ToLower()},";
                            continue;
                        }
                    }

                    if (item.ColType.ToUpper() == "VARCHAR2".ToUpper())
                    {
                        if (item.ColKeyName != null)
                        {
                            if (item.ColKeyName.ToUpper() != "PK")
                            {
                                RetVal += $"{item.ColName} = Trim(P_{item.ColName}) ,";
                            }
                        }
                        else
                        {
                            RetVal += $"{item.ColName} = Trim(P_{item.ColName}) ,";
                        }
                    }
                    else if (item.ColType.ToUpper() == "CHAR".ToUpper())
                    {
                        if (item.ColKeyName != null)
                        {
                            if (item.ColKeyName.ToUpper() != "PK")
                            {
                                RetVal += $"{item.ColName} = Trim(P_{item.ColName}) ,";
                            }
                        }
                        else
                        {
                            RetVal += $"{item.ColName} = Trim(P_{item.ColName}) ,";
                        }
                    }
                    else
                    {
                        if (item.ColKeyName != null)
                        {
                            if (item.ColKeyName.ToUpper() != "PK")
                            {
                                RetVal += $"{item.ColName} = P_{item.ColName} ,";
                            }
                        }
                        else
                        {
                            RetVal += $"{item.ColName} = P_{item.ColName} ,";
                        }
                    }

                    if (item.ColKeyName != null)
                    {
                        if (item.ColKeyName.ToUpper() == "PK")
                        {
                            whereString += $" {item.ColName} = P_{item.ColName}  \n";
                        }
                    }

                    if (item.ColKeyName != null)
                    {
                        if (item.ColKeyName.ToUpper() == "CK")
                        {
                            whereString += $" And {item.ColName} = P_{item.ColName}  \n";
                        }
                    }
                }
                RetVal = RetVal.Trim(',');
                RetVal = RetVal.Replace(",", ",\n");

                whereString += $" ; \n";

                RetVal += whereString;
                //RetVal += $" {listOraDbObjects[0].ColName} = p_{listOraDbObjects[0].ColName} ; \n";
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string DeleteGenerat(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "";
            try
            {
                RetVal = $" Delete from {tableName}  \n";

                RetVal += $" Where \n";
                RetVal += $" {listOraDbObjects[0].ColName} = p_{listOraDbObjects[0].ColName} ; \n";
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string UpdateGeneratOraInParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "";
            try
            {
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColDefauldVal != null)
                    {
                        if (item.ColDefauldVal.ToUpper() == "SYSDATE")
                        {
                            continue;
                        }
                    }
                    RetVal += $"P_{item.ColName}           {item.ColType},  \n";
                }
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string DeleteGeneratOraInParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "";
            try
            {
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColKeyName == "PK")
                    {
                        RetVal += $"P_{item.ColName}           {item.ColType},  \n";
                    }
                }
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }
    }

    public class PackageBadyQry
    {
        public string schemaName = " ";
        public string packageName = "";

        public string start = "";

        public string tableName = "";
        public string titleNameInMsg = "";
        public string tableColsName = "";
        public string tableColsType = "";
        public string tableColsList = "";

        public string list = "";
        public string details = "";
        public string xl_list = "";

        public string end = "";

        public string GeneratePackage(string vSchemaName, string vPackageName, string vTableName, string vTitleNameInMsg, List<OraDbObjects> listOraDbObjects)
        {
            schemaName = vSchemaName;
            packageName = vPackageName + "_QRY";
            tableName = vTableName;
            titleNameInMsg = vTitleNameInMsg.ToLower();
            titleNameInMsg = char.ToUpper(titleNameInMsg[0]) + titleNameInMsg[1..];

            start = "Create Or Replace Package Body \"" + schemaName.Trim().ToUpper() + "\".\"" + packageName.Trim().ToUpper() + "\" As \n";

            list = $@"
                    Function fn_{tableName}_list(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {ListOraInParams(listOraDbObjects)}

                        p_row_number     Number,
                        p_page_length    Number
                    ) Return Sys_Refcursor As
                        v_empno              Varchar2(5);
                        e_employee_not_found Exception;
                        Pragma exception_init(e_employee_not_found, -20001);
                        c       Sys_Refcursor;
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
                                    {ListGenerat(listOraDbObjects)}
                                 )
                        Where
                            row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                    Return c;

                    End fn_{tableName}_list;

                ";

            details = $@"
                    Procedure sp_{tableName}_details(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {DetailsOraInOutParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    ) As
                        v_exists       Number;
                        v_empno        Varchar2(5);
                        v_user_tcp_ip  Varchar2(5) := 'NA';
                        v_message_type Number      := 0;
                    Begin
                        v_empno := get_empno_from_meta_id(p_meta_id);

                        If v_empno = 'ERRRR' Then
                            p_message_type := 'KO';
                            p_message_text := 'Invalid employee number';
                            Return;
                        End If;

                        Select
                            Count(*)
                        Into
                            v_exists
                        From
                            {tableName}
                        Where
                            {listOraDbObjects[0].ColName} = p_{listOraDbObjects[0].ColName};

                        If v_exists = 1 Then

                            {DetailsGenerat(listOraDbObjects)}

                            p_message_type       := 'OK';
                            p_message_text := 'Procedure executed successfully.';
                        Else
                            p_message_type := 'KO';
                            p_message_text := 'No matching {titleNameInMsg} exists !!!';
                        End If;

                    Exception

                        When Others Then
                            p_message_type := 'KO';
                            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

                    End sp_{tableName}_details;

            ";

            xl_list = $@"
                    Function fn_{tableName}_xl_list(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {XLListOraInParams(listOraDbObjects)}

                    ) Return Sys_Refcursor As
                        v_empno              Varchar2(5);
                        e_employee_not_found Exception;
                        Pragma exception_init(e_employee_not_found, -20001);
                        c       Sys_Refcursor;
                    Begin

                        v_empno := get_empno_from_meta_id(p_meta_id);

                            If v_empno = 'ERRRR' Then
                                Raise e_employee_not_found;
                                Return Null;
                            End If;

                        Open c For

                           {XLListGenerat(listOraDbObjects)}

                        Return c;

                    End fn_{tableName}_xl_list;

                ";

            end = $"End {packageName.Trim().ToLower()}; \n / \n Grant Execute On   \"{schemaName.Trim().ToUpper()}\".\"{packageName.Trim().ToUpper()}\"  To \"TCMPL_APP_CONFIG\";";

            return start + list + details + xl_list + end;
        }

        //v_job_key_id   := dbms_random.string('X', 8);
        private string ListOraInParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "p_generic_search Varchar2 Default Null, \n \n";
            try
            {
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColDefauldVal != null)
                    {
                        if (item.ColDefauldVal.ToUpper() == "SYSDATE")
                        {
                            continue;
                        }
                    }
                    if (item.ColKeyName != "PK")
                    {
                        RetVal += $"P_{item.ColName}    {item.ColType}    Default Null,  \n";
                    }
                }
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string ListGenerat(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "\n Select  \n";
            string generic_searchVal = "\n ( \n";
            try
            {
                //RetVal = $" Insert Into {tableName}  \n";
                //RetVal += $"(\n";
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    RetVal += $"a.{item.ColName}      As {item.ColName}   ,           -- {item.ColType} \n";
                }
                //RetVal += @"(
                /* Select
                    Case
                        When Count(business_line) > 0 Then
                            1
                        Else
                            0
                    End As delete_allowed
                From
                    jobmaster
                Where
                    business_line = a.code
            )                                                As delete_allowed, */

                //";

                RetVal += $"\n Row_Number() Over (Order By a.{listOraDbObjects[1].ColName}) row_number,\r\n                        Count(*) Over ()                                 total_row";
                RetVal += $" From\r\n                        {tableName} a\r\n                    Where\n";
                RetVal = RetVal.Trim(',');

                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColType.ToUpper() == "VARCHAR2".ToUpper() || item.ColType.ToUpper() == "CHAR".ToUpper())
                    {
                        if (item.ColKeyName != null)
                        {
                            if (item.ColKeyName.ToUpper() != "PK")
                            {
                                RetVal += $"a.{item.ColName} = nvl(Trim(p_{item.ColName}), a.{item.ColName}) \n And ";
                                generic_searchVal += $" upper(a.{item.ColName}) Like '%' || upper(Trim(p_generic_search)) || '%' Or\n";
                            }
                        }
                        else
                        {
                            RetVal += $"a.{item.ColName} = nvl(Trim(p_{item.ColName}), a.{item.ColName})  \n And  ";
                            generic_searchVal += $" \n upper(a.{item.ColName}) Like '%' || upper(Trim(p_generic_search)) || '%' Or";
                        }
                    }
                }

                //RetVal = RetVal.Replace("And", "And\n");

                generic_searchVal = generic_searchVal.TrimEnd('r');
                generic_searchVal = generic_searchVal.TrimEnd('O');

                generic_searchVal += "\n ) \n";

                RetVal += generic_searchVal;
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string DetailsGenerat(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "";
            string whereString = "";
            whereString += $"\n Where \n";
            try
            {
                RetVal = $" Select  ";

                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColKeyName != null)
                    {
                        if (item.ColKeyName.ToUpper() == "PK")
                        {
                            continue;
                        }
                    }
                    RetVal += $"{item.ColName},";
                }
                RetVal = RetVal.Trim(',');
                RetVal += $"  Into \n ";

                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColKeyName != null)
                    {
                        if (item.ColKeyName.ToUpper() == "PK")
                        {
                            continue;
                        }
                    }
                    RetVal += $"P_{item.ColName},";
                }
                RetVal = RetVal.Trim(',');

                RetVal += $" \n  from {tableName}  \n  ";

                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColKeyName != null)
                    {
                        if (item.ColKeyName.ToUpper() == "PK")
                        {
                            whereString += $" {item.ColName} = P_{item.ColName}  \n";
                        }
                    }

                    if (item.ColKeyName != null)
                    {
                        if (item.ColKeyName.ToUpper() == "CK")
                        {
                            whereString += $" And {item.ColName} = P_{item.ColName}  \n";
                        }
                    }
                }
                RetVal = RetVal.Trim(',');
                RetVal = RetVal.Replace(",", ",\n");

                whereString += $" ; \n";

                RetVal += whereString;
                //RetVal += $" {listOraDbObjects[0].ColName} = p_{listOraDbObjects[0].ColName} ; \n";
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string XLListGenerat(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "\n Select  \n";
            string generic_searchVal = "\n ( \n";
            try
            {
                //RetVal = $" Insert Into {tableName}  \n";
                //RetVal += $"(\n";
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    RetVal += $"a.{item.ColName}      As {item.ColName}   ,";
                }
                //RetVal += @"(
                /* Select
                    Case
                        When Count(business_line) > 0 Then
                            1
                        Else
                            0
                    End As delete_allowed
                From
                    jobmaster
                Where
                    business_line = a.code
            )                                                As delete_allowed, */

                //";

                // RetVal += $"\n Row_Number() Over (Order By a.{listOraDbObjects[1].ColName})
                // row_number,\r\n Count(*) Over () total_row";
                RetVal = RetVal.Trim(',');
                RetVal = RetVal.Replace(",", ",\n");
                RetVal += $" From\r\n                        {tableName} a\r\n                    Where\n";
                RetVal = RetVal.Trim(',');

                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColType.ToUpper() == "VARCHAR2".ToUpper() || item.ColType.ToUpper() == "CHAR".ToUpper())
                    {
                        if (item.ColKeyName != null)
                        {
                            if (item.ColKeyName.ToUpper() != "PK")
                            {
                                RetVal += $"a.{item.ColName} = nvl(Trim(p_{item.ColName}), a.{item.ColName}) \n And ";
                                generic_searchVal += $" upper(a.{item.ColName}) Like '%' || upper(Trim(p_generic_search)) || '%' Or\n";
                            }
                        }
                        else
                        {
                            RetVal += $"a.{item.ColName} = nvl(Trim(p_{item.ColName}), a.{item.ColName})  \n And  ";
                            generic_searchVal += $" \n upper(a.{item.ColName}) Like '%' || upper(Trim(p_generic_search)) || '%' Or";
                        }
                    }
                }

                //RetVal = RetVal.Replace("And", "And\n");

                generic_searchVal = generic_searchVal.TrimEnd('r');
                generic_searchVal = generic_searchVal.TrimEnd('O');

                generic_searchVal += "\n ); \n";

                RetVal += generic_searchVal;
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string DetailsOraInOutParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "\n\n";
            try
            {
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColKeyName == "PK")
                    {
                        RetVal += $"P_{item.ColName}        {item.ColType}   ,  \n\n";
                    }
                    //else if (item.ColKeyName == "CK")
                    //{
                    //    RetVal += $"P_{item.ColName}        {item.ColType}   ,  \n\n";
                    //}
                    else
                    {
                        RetVal += $"P_{item.ColName}    Out     {item.ColType} ,  \n";
                    }
                }
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }

        private string XLListOraInParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "p_generic_search Varchar2 Default Null, \n";
            try
            {
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColKeyName != "PK")
                    {
                        RetVal += $"P_{item.ColName}    {item.ColType}    Default Null,";
                    }
                }
                RetVal = RetVal.Trim(',');
                RetVal = RetVal.Replace(",", ",\n");
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
                return RetVal;
            }
            return RetVal;
        }
    }
}