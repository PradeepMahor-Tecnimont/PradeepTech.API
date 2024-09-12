using FastMember;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Globalization;
using System.Linq;
using System.Reflection;



namespace TCMPLApp.DataAccess.Models
{
    public static class HelperTcmPL
    {
        private static readonly Dictionary<Type, OracleDbType> typeMap;

        static HelperTcmPL()
        {
            typeMap = new Dictionary<Type, OracleDbType>
            {
                [typeof(string)] = OracleDbType.Varchar2,
                [typeof(char[])] = OracleDbType.Varchar2,
                [typeof(byte)] = OracleDbType.Byte,
                [typeof(short)] = OracleDbType.Int16,
                [typeof(int)] = OracleDbType.Int32,
                [typeof(long)] = OracleDbType.Long,
                [typeof(byte[])] = OracleDbType.Blob,
                [typeof(bool)] = OracleDbType.Boolean,
                [typeof(DateTime)] = OracleDbType.Date,
                [typeof(decimal)] = OracleDbType.Decimal,
                [typeof(float)] = OracleDbType.Double,
                [typeof(double)] = OracleDbType.Double,
                [typeof(TimeSpan)] = OracleDbType.TimeStamp,
                [typeof(Guid)] = OracleDbType.Raw,
                [typeof(object)] = OracleDbType.RefCursor
            };
        }

        /// <summary>
        /// Maps a DbDataReader record to an object. Ignoring case.
        /// </summary>    
        public static T ConvertDbDataReaderToObject<T>(this DbDataReader rd) where T : class, new()
        {
            Type type = typeof(T);
            var accessor = TypeAccessor.Create(type);
            var members = accessor.GetMembers();
            var t = new T();

            for (int i = 0; i < rd.FieldCount; i++)
            {
                string name = rd.GetName(i);
                if (!rd.IsDBNull(i))
                {
                    string fieldName = SnakeCaseToPascalCase(rd.GetName(i));

                    if (members.Any(m => string.Equals(m.Name, fieldName, StringComparison.OrdinalIgnoreCase)))
                    {
                        var obj = accessor[t, fieldName];
                        if (obj != null && (accessor[t, fieldName].GetType().Name.ToLower() == "decimal"))
                            accessor[t, fieldName] = Convert.ToDecimal(rd.GetValue(i));
                        else if (obj != null && (accessor[t, fieldName].GetType().Name.ToLower() == "int32"))
                            accessor[t, fieldName] = Convert.ToInt32(rd.GetValue(i));
                        else if (obj != null && (accessor[t, fieldName].GetType().Name.ToLower() == "int16"))
                            accessor[t, fieldName] = Convert.ToInt16(rd.GetValue(i));
                        else
                            accessor[t, fieldName] = rd.GetValue(i);
                    }
                }
            }

            return t;
        }

        /// <summary>
        /// Maps the output records to an object. Ignoring case.
        /// </summary>    
        public static T ConvertDbParameterToObject<T>(this DbParameterCollection pars) where T : class, new()
        {
            Type type = typeof(T);
            var accessor = TypeAccessor.Create(type);
            var members = accessor.GetMembers();
            var t = new T();

            foreach (DbParameter par in pars)
            {
                if (par.Direction == ParameterDirection.Output || par.Direction == ParameterDirection.ReturnValue)
                {
                    //string fieldName = par.ParameterName.Replace("@", "");

                    string fieldName = SnakeCaseToPascalCase(par.ParameterName);


                    if (members.Any(m => string.Equals(m.Name, fieldName, StringComparison.OrdinalIgnoreCase)))
                    {


                        if (((OracleParameter)par).OracleDbType == OracleDbType.RefCursor && ((Oracle.ManagedDataAccess.Types.OracleRefCursor)par.Value).IsNull == false)
                        {
                            using (var cursorReader = ((Oracle.ManagedDataAccess.Types.OracleRefCursor)par.Value).GetDataReader())
                            {
                                if (cursorReader.HasRows)
                                {
                                    //while (cursorReader.Read())
                                    //{
                                    var prop = typeof(T).GetProperties().First(p => p.Name == fieldName).PropertyType;

                                    //var fType = (accessor[t, fieldName]).GetType();

                                    var isEnumerable = typeof(IEnumerable).IsAssignableFrom(prop);

                                    var typeOfRefCursor = prop.GetGenericArguments().First();



                                    //var obj = Activator.CreateInstance(typeOfEnumerable);


                                    Type helperType = typeof(HelperTcmPL);
                                    MethodInfo mi = helperType.GetMethod("ConvertDbDataReaderToObject");

                                    MethodInfo miConstructed = mi.MakeGenericMethod(typeOfRefCursor);



                                    if (isEnumerable)
                                    {
                                        var itemsType = typeof(List<>).MakeGenericType(typeOfRefCursor);

                                        var items = (IList)Activator.CreateInstance(itemsType);

                                        while (cursorReader.Read())
                                        {
                                            object[] args = { cursorReader };

                                            var item = miConstructed.Invoke(null, args);
                                            items.Add(item);
                                        }
                                        accessor[t, fieldName] = items;
                                    }
                                    else
                                    {
                                        object[] args = { cursorReader };

                                        var item = miConstructed.Invoke(null, args);
                                        accessor[t, fieldName] = item;
                                    }


                                    //var typeOfEnumerable1 = prop.GetInterfaces().Where(i => i.IsGenericType)
                                    //                        .Single(i => i.GetGenericTypeDefinition() == typeof(IEnumerable<>))
                                    //                        .GetGenericArguments().First();



                                    //var fType = (PropertyInfo)members.First(m => m.Name == fieldName);

                                    //var prop = t.GetType().GetProperty(fieldName);

                                    //Type helperType = typeof(HelperTcmPL);
                                    //MethodInfo mi = helperType.GetMethod("ConvertDbDataReaderToObject");

                                    //MethodInfo miConstructed = mi.MakeGenericMethod(typeOfEnumerable);

                                    //object[] args = { cursorReader };

                                    //obj = miConstructed.Invoke(null, args);

                                    //accessor[t, fieldName] = HelperTcmPL.ConvertDbDataReaderToObject<prop> (cursorReader);

                                    //var item = HelperTcmPL.ConvertDbDataReaderToObject<T>(cursorReader);

                                    //accessor[t, fieldName] = item;
                                    //}
                                }
                            }
                        }
                        else if (!ParameterValueIsNull(par))
                        {
                            if (par.DbType == DbType.String)
                            {
                                if (((OracleParameter)par).CollectionType == OracleCollectionType.PLSQLAssociativeArray)
                                    accessor[t, fieldName] = (string[])par.Value;
                                else
                                    accessor[t, fieldName] = par.Value.ToString();
                            }
                            else if (par.DbType == DbType.Decimal)
                            {
                                accessor[t, fieldName] = ((Oracle.ManagedDataAccess.Types.OracleDecimal)par.Value).Value;
                            }
                            else if (par.DbType == DbType.Int32)
                            {
                                accessor[t, fieldName] = Convert.ToInt32(((Oracle.ManagedDataAccess.Types.OracleDecimal)par.Value).Value);
                            }
                            else if (par.DbType == DbType.Date)
                            {
                                accessor[t, fieldName] = ((Oracle.ManagedDataAccess.Types.OracleDate)par.Value).Value;
                            }
                            else
                                accessor[t, fieldName] = par.Value;
                        }
                    }
                }
            }

            return t;
        }

        /// <summary>
        /// Fill OracleParameters based on a list of items.
        /// </summary>    
        public static List<OracleParameter> FillOracleParameter<T>(T t, OracleConnection oraConn, bool AddAllProperty = true) where T : class, new()
        {
            var pars = new List<OracleParameter>();

            PropertyInfo[] properties = typeof(T).GetProperties();

            foreach (PropertyInfo property in properties)
            {
                if (AddAllProperty == false)
                {
                    if (property.PropertyType.IsArray)
                    {
                        if (property.GetValue(t, null) != null)
                        {
                            var par = new OracleParameter();
                            par.ParameterName = PascalCaseToSnakeCase(property.Name);
                            if (property.PropertyType == typeof(string[]))
                            {
                                par.CollectionType = OracleCollectionType.PLSQLAssociativeArray;
                                var strArray = ((string[])property.GetValue(t, null));
                                if (strArray.Length == 0)
                                {
                                    par.Value = new string[1] { null };
                                    par.Size = 0;
                                }
                                else
                                {
                                    par.Value = property.GetValue(t, null);
                                    par.Size = strArray.Length;
                                    par.ArrayBindSize = strArray.Select(s => s.Length).ToArray();
                                }
                            }
                            else if (property.PropertyType == typeof(byte[]))
                            {

                                var oraBlob = new OracleBlob(oraConn);
                                byte[] bytes = (byte[])property.GetValue(t, null);
                                oraBlob.Write(bytes, 0, bytes.Length);



                                par.OracleDbType = OracleDbType.Blob;
                                par.Value = oraBlob;

                            }
                            else
                            {
                                par.CollectionType = OracleCollectionType.PLSQLAssociativeArray;
                                par.Value = property.GetValue(t, null);
                            }

                            pars.Add(par);
                        }
                    }
                    else if (property.GetValue(t, null) != null && !string.IsNullOrEmpty(property.GetValue(t, null).ToString()))
                    {
                        pars.Add(new OracleParameter
                        {
                            ParameterName = PascalCaseToSnakeCase(property.Name),
                            Value = property.GetValue(t, null)
                        });
                    }
                }
                else
                {
                    if (property.Name != "UIUserId")
                    {
                        pars.Add(
                        new OracleParameter
                        {
                            ParameterName = PascalCaseToSnakeCase(property.Name),
                            Value = property.GetValue(t, null)
                        });
                    }
                }
            }

            return pars;
        }

        /// <summary>
        /// Fill OracleParameters output based on a class.
        /// </summary>    
        public static List<OracleParameter> FillOracleParameterOutput<T>() where T : class, new()
        {
            var pars = new List<OracleParameter>();

            PropertyInfo[] properties = typeof(T).GetProperties();

            foreach (PropertyInfo property in properties)
            {

                if (property.PropertyType.IsArray && property.PropertyType == typeof(string[]))
                {
                    var par = new OracleParameter();
                    par.ParameterName = PascalCaseToSnakeCase(property.Name);
                    par.CollectionType = OracleCollectionType.PLSQLAssociativeArray;
                    par.Direction = ParameterDirection.Output;
                    par.Size = 1000;
                    par.ArrayBindSize = Enumerable.Range(0, 1000).Select(_ => 1000).ToArray();
                    par.Value = null;
                    pars.Add(par);
                }
                else if (property.PropertyType != typeof(string) && typeof(IEnumerable).IsAssignableFrom(property.PropertyType))
                {
                    var OracleParameter = new OracleParameter
                    {
                        ParameterName = PascalCaseToSnakeCase(property.Name),
                        Direction = ParameterDirection.Output,
                        OracleDbType = OracleDbType.RefCursor
                    };
                    pars.Add(OracleParameter);
                }
                else
                {

                    var OracleParameter = new OracleParameter
                    {
                        ParameterName = PascalCaseToSnakeCase(property.Name),
                        Direction = ParameterDirection.Output,

                        OracleDbType = GetDbType(property.PropertyType)
                    };

                    if (property.PropertyType == typeof(string))
                        OracleParameter.Size = 4000;

                    if (property.PropertyType == typeof(object))
                        OracleParameter.Size = -1;
                    pars.Add(OracleParameter);
                }
            }

            return pars;
        }

        /// <summary>
        /// Fill OracleParameters output based on a class.
        /// </summary>    
        public static List<OracleParameter> FillOracleParameterReturnValue<T>() where T : class, new()
        {
            var pars = new List<OracleParameter>();

            PropertyInfo[] properties = typeof(T).GetProperties();

            foreach (PropertyInfo property in properties)
            {
                var OracleParameter = new OracleParameter
                {
                    ParameterName = PascalCaseToSnakeCase(property.Name),
                    Direction = ParameterDirection.ReturnValue,
                    OracleDbType = GetDbType(property.PropertyType)
                };

                if (property.PropertyType == typeof(string))
                    OracleParameter.Size = 4000;

                pars.Add(OracleParameter);
            }

            return pars;
        }

        /// <summary>
        /// Return the SQL statement of a stored procedure
        /// </summary>    
        public static string CommandAsSql(DbCommand sc)
        {
            string sql = sc.CommandText;

            sql = sql.Replace("\r\n", "").Replace("\r", "").Replace("\n", "");
            sql = System.Text.RegularExpressions.Regex.Replace(sql, @"\s+", " ");

            foreach (OracleParameter sp in sc.Parameters)
            {
                string spName = sp.ParameterName;
                string spValue = ParameterValueForSql(sp);
                sql = sql + " " + spName + " = " + spValue + ",";
            }

            sql = sql.Trim().TrimEnd(',');
            sql = sql.Replace("= NULL", "IS NULL");
            sql = sql.Replace("!= NULL", "IS NOT NULL");
            return sql;
        }

        private static string ParameterValueForSql(OracleParameter sp)
        {
            string retval;

            switch (sp.OracleDbType)
            {
                case OracleDbType.Varchar2:
                //case OracleDbType.NChar:
                //case OracleDbType.NText:
                case OracleDbType.NVarchar2:
                //case OracleDbType.Text:
                //case OracleDbType.Time:
                //case OracleDbType.VarChar:
                //case OracleDbType.Xml:
                case OracleDbType.Date:
                    //case OracleDbType.DateTime:
                    //case OracleDbType.DateTime2:
                    //case OracleDbType.DateTimeOffset:
                    if (sp.Value == DBNull.Value)
                    {
                        retval = "NULL";
                    }
                    else
                    {
                        retval = "'" + sp.Value.ToString().Replace("'", "''") + "'";
                    }
                    break;

                //case OracleDbType.Bit:
                //    if (sp.Value == DBNull.Value)
                //    {
                //        retval = "NULL";
                //    }
                //    else
                //    {
                //        retval = ((bool)sp.Value == false) ? "0" : "1";
                //    }
                //    break;

                default:
                    if (sp.Value == DBNull.Value)
                    {
                        retval = "NULL";
                    }
                    else
                    {
                        retval = sp.Value.ToString().Replace("'", "''");
                    }
                    break;
            }

            return retval;
        }

        private static OracleDbType GetDbType(Type propertyType)
        {
            // Allow nullable types to be handled
            propertyType = Nullable.GetUnderlyingType(propertyType) ?? propertyType;

            if (typeMap.ContainsKey(propertyType))
            {
                return typeMap[propertyType];
            }

            throw new ArgumentException($"{propertyType.FullName} is not a supported .NET class");
        }

        private static string PascalCaseToSnakeCase(string StringToCovert)
        {
            return string.Concat(StringToCovert.Select((x, i) => i > 0 && char.IsUpper(x) ? "_" + x.ToString() : x.ToString())).ToLower();
        }

        private static string SnakeCaseToPascalCase(string StringToConvert)
        {
            TextInfo myTI = new CultureInfo("en-US", false).TextInfo;

            return myTI.ToTitleCase(StringToConvert.ToLower().Replace("_", " ")).Replace(" ", "");
        }

        private static bool ParameterValueIsNull(DbParameter par)
        {
            if (par.DbType == DbType.String)
            {

                if (((OracleParameter)par).CollectionType == OracleCollectionType.PLSQLAssociativeArray)
                    return ((string[])par.Value).Length == 0;
                else
                    return ((Oracle.ManagedDataAccess.Types.OracleString)par.Value).IsNull == true;
            }
            else if (par.DbType == DbType.Decimal)
                return ((Oracle.ManagedDataAccess.Types.OracleDecimal)par.Value).IsNull == true;
            //else if (par.DbType == DbType.DateTime)
            //    return ((Oracle.ManagedDataAccess.Types.OracleDate)par.Value).IsNull == true;
            else if (par.DbType == DbType.Date)
                return ((Oracle.ManagedDataAccess.Types.OracleDate)par.Value).IsNull == true;
            else
                return true;

        }

        private static bool _isDevelopment = false;
        private static bool _isStaging = false;
        private static bool _isProduction = false;

        public static bool EnvIsDevelopment { get { return _isDevelopment; } }

        public static bool EnvIsStaging { get { return _isStaging; } }

        public static bool EnvIsProduction { get { return _isProduction; } }

        private static bool _isEnvInitialised = false;

        public static void InitializeEnv(EnvOptions envOptions)
        {
            if (_isEnvInitialised)
                return;
            _isEnvInitialised = true;
            if (envOptions == EnvOptions.Production)
                _isProduction = true;
            else if (envOptions == EnvOptions.Development)
                _isDevelopment = true;
            else if (envOptions == EnvOptions.Staging)
                _isStaging = true;

        }
        public enum EnvOptions
        {
            Development,
            Staging,
            Production
        }
    }
}
