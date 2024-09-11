namespace WinFormsCodeGenerator.CustomClass
{
    public class Package
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
            titleNameInMsg = char.ToUpper(vTitleNameInMsg[0]) + vTitleNameInMsg[1..];

            start = "Create Or Replace Package \"" + schemaName.Trim().ToUpper() + "\".\"" + packageName.Trim().ToUpper() + "\" As \n";

            add = $@"
                    Procedure sp_add_{tableName}(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {AddGeneratOraInParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    );

                ";

            update = $@"
                    Procedure sp_update_{tableName}(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {UpdateGeneratOraInParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    );

            ";

            delete = $@"
                    Procedure sp_delete_{tableName}(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {DeleteGeneratOraInParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    );

                "
                ;

            end = $@"End {packageName.Trim().ToLower()};

                  ";

            return start + add + update + delete + end;
        }

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

    public class PackageQry
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
            titleNameInMsg = char.ToUpper(vTitleNameInMsg[0]) + vTitleNameInMsg[1..];

            start = "Create Or Replace Package \"" + schemaName.Trim().ToUpper() + "\".\"" + packageName.Trim().ToUpper() + "\" As \n";

            list = $@"
                    Function fn_{tableName}_list(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {ListOraInParams(listOraDbObjects)}

                        p_row_number     Number,
                        p_page_length    Number

                    ) Return Sys_Refcursor;

                ";

            details = $@"
                    Procedure sp_{tableName}_details(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {DetailsOraInOutParams(listOraDbObjects)}

                        p_message_type Out Varchar2,
                        p_message_text Out Varchar2
                    );

            ";

            xl_list = $@"
                    Function fn_{tableName}_xl_list(
                        p_person_id        Varchar2,
                        p_meta_id          Varchar2,

                        {XLListOraInParams(listOraDbObjects)}

                    ) Return Sys_Refcursor;

                "
                ;

            end = $@"End {packageName.Trim().ToLower()};

                  ";

            return start + list + details + xl_list + end;
        }

        private string ListOraInParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "p_generic_search Varchar2 Default Null, \n";
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

        private string DetailsOraInOutParams(List<OraDbObjects> listOraDbObjects)
        {
            string RetVal = "\n\n";
            try
            {
                foreach (OraDbObjects item in listOraDbObjects)
                {
                    if (item.ColDefauldVal != null)
                    {
                        if (item.ColDefauldVal.ToUpper() != "SYSDATE")
                        {
                            RetVal += $"P_{item.ColName}    {item.ColType}    Default Null,  \n";
                        }
                    }
                    if (item.ColKeyName == "PK")
                    {
                        RetVal += $"P_{item.ColName}        {item.ColType}   ,  \n\n";
                    }
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