using Dapper;
using Microsoft.EntityFrameworkCore;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;


namespace TCMPLApp.DataAccess.Base
{
    public class ExecRepository : IExecRepository
    {

        private readonly ExecDBContext _execDBContext;

        public ExecRepository(ExecDBContext execDBContext)
        {
            _execDBContext = execDBContext;
        }

        public async Task<Domain.Models.ProcedureResult> ExecuteProc(string sql, object paramList = null, object paramListOut = null)
        {
            try
            {
                DynamicParameters dynamicParameters = new();

                if (paramList != null)
                {
                    var popList = paramList.GetType().GetProperties();
                    foreach (var prop in popList)
                    {
                        dynamicParameters.Add(prop.Name, prop.GetValue(paramList));
                    }
                }


                //if (paramList != null)
                //    dynamicParameters = new DynamicParameters(paramList);
                //else
                //    dynamicParameters = new DynamicParameters();

                if (paramListOut != null)
                {
                    DynamicParameters outDynamicParameters = new DynamicParameters(paramListOut);
                    foreach (var paramName in outDynamicParameters.ParameterNames)
                    {
                        var value = outDynamicParameters.Get<dynamic>(paramName);
                        dynamicParameters.Add(paramName, null, DbType.String, ParameterDirection.Output, 1000);
                    }
                }
                dynamicParameters.Add(name: "Param_Success", "", dbType: DbType.String, direction: ParameterDirection.Output, size: 10);
                dynamicParameters.Add(name: "Param_Message", "", dbType: DbType.String, direction: ParameterDirection.Output, size: 1000);
                var conn = _execDBContext.Database.GetDbConnection();
                {
                    //conn.Open();
                    await conn.ExecuteAsync(sql, dynamicParameters, commandType: CommandType.StoredProcedure);
                }
                return new Domain.Models.ProcedureResult { Status = dynamicParameters.Get<string>("Param_Success"), Message = dynamicParameters.Get<string>("Param_Message") };
            }
            catch (Exception e)
            {
                return new Domain.Models.ProcedureResult { Message = e.Message, Status = "KO" };
            }
        }

        public async Task<T> QueryFirstOrDefaultAsync<T>(string query, object parameters = null)
        {
            var conn = _execDBContext.Database.GetDbConnection();
            Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
            return await conn.QueryFirstOrDefaultAsync<T>(query, parameters);
        }

        public async Task<IEnumerable<T>> QueryAsync<T>(string query, object parameters = null)
        {
            var conn = _execDBContext.Database.GetDbConnection();
            Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
            return await conn.QueryAsync<T>(query, parameters);
        }


        public IEnumerable<T> Query<T>(string query, object parameters = null)
        {
            var conn = _execDBContext.Database.GetDbConnection();
            Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
            return conn.Query<T>(query, parameters);
        }


        //public dynamic QueryForDataTable(string query, object parameters = null)
        //{
        //    DataTable oDT = new DataTable();
        //    try
        //    {
        //        using (var conn = _dataContext.Database.GetDbConnection())
        //        {
        //            OracleDataAdapter oraAdp = new OracleDataAdapter("", (OracleConnection)conn);
        //            oraAdp.SelectCommand.CommandText = query;
        //            oraAdp.Fill(oDT);
        //            return oDT;
        //        }
        //    }
        //    catch (Exception)
        //    {
        //        //Handle the exception
        //        return new DataTable();
        //    }
        //}

        public async Task<T> ExecuteProcAsync<T>(T t)
        {
            string commandName = string.Empty;
            var type = t.GetType();
            var properties = type.GetProperties();
            List<string> listOutParamNames = null;

            DynamicParameters dynamicParams = null;

            foreach (var procParam in properties)
            {
                if (procParam.Name == "CommandText")
                {
                    commandName = (string)procParam.GetValue(t);
                    continue;
                }
                dynamicParams ??= new DynamicParameters();

                var paramName = this.PascalCaseToSnakeCase(procParam.Name);
                if (paramName.StartsWith("out_"))
                {
                    paramName = paramName.Substring(4);
                    listOutParamNames ??= new List<string>();
                    listOutParamNames.Add(paramName);

                    if (paramName == "return_value")
                    {
                        if (procParam.PropertyType.Name == "String")
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.ReturnValue, size: 1000);
                        else
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.ReturnValue);
                    }
                    else
                    {
                        if (procParam.PropertyType.Name == "String")
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.Output, size: 1000);
                        else
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    }
                    //else if (procParam.PropertyType.Name == "DateTime")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    //else if (procParam.PropertyType.Name == "Int32")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    //else if (procParam.PropertyType.Name == "Decimal")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);


                }
                else if (procParam.PropertyType.Name == "Byte[]")
                    dynamicParams.Add(name: paramName, value: procParam.GetValue(t), dbType: DbType.Binary);
                else
                    dynamicParams.Add(name: paramName, value: procParam.GetValue(t));
            }

            var conn = _execDBContext.Database.GetDbConnection();

            await conn.ExecuteAsync(commandName, dynamicParams, commandType: CommandType.StoredProcedure);



            var outT = (T)Activator.CreateInstance(typeof(T));

            if (listOutParamNames == null)
                return outT;
            else
            {
                foreach (var outParamName in listOutParamNames)
                {
                    var val = dynamicParams.Get<dynamic>(outParamName);
                    string propertyName = SnakeCaseToPascalCase("out_" + outParamName);
                    var property = (outT.GetType()).GetProperty(propertyName);
                    property.SetValue(outT, val, null);

                }
                return outT;
            }

        }


        public T ExecuteProc<T>(T t)
        {
            string commandName = string.Empty;
            var type = t.GetType();
            var properties = type.GetProperties();
            List<string> listOutParamNames = null;

            DynamicParameters dynamicParams = null;

            foreach (var procParam in properties)
            {
                if (procParam.Name == "CommandText")
                {
                    commandName = (string)procParam.GetValue(t);
                    continue;
                }
                dynamicParams ??= new DynamicParameters();

                var paramName = this.PascalCaseToSnakeCase(procParam.Name);
                if (paramName.StartsWith("out_"))
                {
                    paramName = paramName.Substring(4);
                    listOutParamNames ??= new List<string>();
                    listOutParamNames.Add(paramName);

                    if (paramName == "return_value")
                    {
                        if (procParam.PropertyType.Name == "String")
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.ReturnValue, size: 1000);
                        else
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.ReturnValue);
                    }
                    else
                    {
                        if (procParam.PropertyType.Name == "String")
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.Output, size: 1000);
                        else
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    }
                    //else if (procParam.PropertyType.Name == "DateTime")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    //else if (procParam.PropertyType.Name == "Int32")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    //else if (procParam.PropertyType.Name == "Decimal")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);


                }
                else
                    dynamicParams.Add(name: PascalCaseToSnakeCase(procParam.Name), procParam.GetValue(t));
            }

            var conn = _execDBContext.Database.GetDbConnection();

            conn.Execute(commandName, dynamicParams, commandType: CommandType.StoredProcedure);



            var outT = (T)Activator.CreateInstance(typeof(T));

            if (listOutParamNames == null)
                return outT;
            else
            {
                foreach (var outParamName in listOutParamNames)
                {
                    var val = dynamicParams.Get<dynamic>(outParamName);
                    string propertyName = SnakeCaseToPascalCase("out_" + outParamName);
                    var property = (outT.GetType()).GetProperty(propertyName);
                    property.SetValue(outT, val, null);

                }
                return outT;
            }

        }


        public async Task<T> ExecuteProcUsingODPNetAsync<T>(T t)
        {
            string commandName = string.Empty;
            var type = t.GetType();
            var properties = type.GetProperties();
            List<string> listOutParamNames = null;



            var cmd = new OracleCommand();



            foreach (var procParam in properties)
            {
                if (procParam.Name == "CommandText")
                {
                    commandName = (string)procParam.GetValue(t);
                    cmd.CommandText = commandName;
                    continue;
                }


                var paramName = this.PascalCaseToSnakeCase(procParam.Name);
                if (paramName.StartsWith("out_"))
                {
                    paramName = paramName.Substring(4);
                    listOutParamNames ??= new List<string>();
                    listOutParamNames.Add(paramName);

                    if (procParam.PropertyType.Name == "String")
                        cmd.Parameters.Add(paramName, OracleDbType.Varchar2, 4000).Direction = ParameterDirection.Output;
                    else if (procParam.PropertyType.Name == "DateTime")
                        cmd.Parameters.Add(paramName, OracleDbType.Date, ParameterDirection.Output);
                    else if (procParam.PropertyType.Name == "Int32")
                        cmd.Parameters.Add(paramName, OracleDbType.Int32, ParameterDirection.Output);
                    else if (procParam.PropertyType.Name == "Decimal")
                        cmd.Parameters.Add(paramName, OracleDbType.Decimal, ParameterDirection.Output);
                }
                else
                {
                    if (procParam.PropertyType.Name.StartsWith("Byte"))
                        cmd.Parameters.Add(paramName, OracleDbType.Blob).Value = procParam.GetValue(t);
                    else
                        cmd.Parameters.Add(paramName, procParam.GetValue(t));
                }
            }

            var conn = _execDBContext.Database.GetDbConnection();
            {
                //conn.Open();
                cmd.Connection = (OracleConnection)conn;

                if (cmd.Connection.State != ConnectionState.Open)
                    cmd.Connection.Open();

                cmd.CommandText = commandName;
                cmd.CommandType = CommandType.StoredProcedure;
                var i = await cmd.ExecuteNonQueryAsync();
                //await conn.ExecuteAsync(commandName, dynamicParams, commandType: CommandType.StoredProcedure);
            }

            //var outT = default(T);

            T outT = (T)Activator.CreateInstance(typeof(T));

            if (listOutParamNames == null)
                return outT;
            else
            {
                foreach (var outParamName in listOutParamNames)
                {
                    string propertyName = SnakeCaseToPascalCase("out_" + outParamName);
                    var property = (outT.GetType()).GetProperty(propertyName);
                    if (cmd.Parameters[outParamName].OracleDbType == OracleDbType.Varchar2)
                        property.SetValue(outT, cmd.Parameters[outParamName].Value.ToString(), null);
                    else if (cmd.Parameters[outParamName].OracleDbType == OracleDbType.Int32)
                        property.SetValue(outT, Int32.Parse(cmd.Parameters[outParamName].Value.ToString()), null);
                    else if (cmd.Parameters[outParamName].OracleDbType == OracleDbType.Decimal)
                        property.SetValue(outT, Decimal.Parse(cmd.Parameters[outParamName].Value.ToString()), null);
                    else if (cmd.Parameters[outParamName].OracleDbType == OracleDbType.Date)
                        property.SetValue(outT, DateTime.Parse(cmd.Parameters[outParamName].Value.ToString()), null);
                }
                return outT;
            }
        }


        private string PascalCaseToSnakeCase(string StringToCovert)
        {
            return string.Concat(StringToCovert.Select((x, i) => i > 0 && char.IsUpper(x) ? "_" + x.ToString() : x.ToString())).ToLower();
        }

        private string SnakeCaseToPascalCase(string StringToConvert)
        {
            TextInfo myTI = new CultureInfo("en-US", false).TextInfo;

            return myTI.ToTitleCase(StringToConvert.ToLower().Replace("_", " ")).Replace(" ", "");
        }

        private DynamicParameters NormalizeParameters<T>(T t)
        {
            string commandName = string.Empty;
            var type = t.GetType();
            var properties = type.GetProperties();
            List<string> listOutParamNames = null;

            DynamicParameters dynamicParams = null;

            foreach (var procParam in properties)
            {
                if (procParam.Name == "CommandText")
                {
                    commandName = (string)procParam.GetValue(t);
                    continue;
                }
                dynamicParams ??= new DynamicParameters();

                var paramName = this.PascalCaseToSnakeCase(procParam.Name);
                if (paramName.StartsWith("out_"))
                {
                    paramName = paramName.Substring(4);
                    listOutParamNames ??= new List<string>();
                    listOutParamNames.Add(paramName);

                    if (paramName == "return_value")
                    {
                        if (procParam.PropertyType.Name == "String")
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.ReturnValue, size: 1000);
                        else
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.ReturnValue);
                    }
                    else
                    {
                        if (procParam.PropertyType.Name == "String")
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.Output, size: 1000);
                        else
                            dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    }
                    //else if (procParam.PropertyType.Name == "DateTime")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    //else if (procParam.PropertyType.Name == "Int32")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);
                    //else if (procParam.PropertyType.Name == "Decimal")
                    //    dynamicParams.Add(name: paramName, direction: ParameterDirection.Output);


                }
                else
                    dynamicParams.Add(name: PascalCaseToSnakeCase(procParam.Name), procParam.GetValue(t));
            }
            return dynamicParams;
        }

        public void Dispose()
        {
            _execDBContext.Dispose();
            GC.SuppressFinalize(this);
        }

    }
}

