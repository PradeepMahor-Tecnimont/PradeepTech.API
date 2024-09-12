using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Context
{

    public class ViewTcmPLRepository<T> : IViewTcmPLRepository<T> where T : class, new()
    {
        public string CommandText { get; set; }
        public bool IsCachedByUser { get; set; } = true;
        public int AbsoluteExpirationRelativeToNowMinute { get; set; } = 60;

        //private readonly ViewTcmPLContext _context;
        private readonly ILogger<ViewTcmPLContext> _logger;
        private readonly IServiceScopeFactory _scopeFactory;
        //public ViewTcmPLRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger)
        public ViewTcmPLRepository(ILogger<ViewTcmPLContext> logger,IServiceScopeFactory scopeFactory)
        {
            //_context = context;
            _logger = logger;
            _scopeFactory = scopeFactory;
            CommandText = "";
        }

        public virtual async Task<T> GetAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            var item = new T();
            using (var scope = _scopeFactory.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<ViewTcmPLContext>();

                var conn = _context.Database.GetDbConnection();
                await conn.OpenAsync();

                using (var command = conn.CreateCommand())
                {
                    command.Connection = (OracleConnection)conn;
                    ((OracleCommand)command).BindByName = true;
                    command.CommandText = CommandText;
                    command.CommandType = CommandType.StoredProcedure;
                    if (_context.Database.GetCommandTimeout() != null)
                        command.CommandTimeout = _context.Database.GetCommandTimeout().GetValueOrDefault();

                    if (baseSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
                    if (parameterSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, false).ToArray());

                    OracleParameter returnSysRefCursor = new OracleParameter();
                    returnSysRefCursor.OracleDbType = OracleDbType.RefCursor;
                    returnSysRefCursor.Direction = ParameterDirection.ReturnValue;
                    command.Parameters.Add(returnSysRefCursor);

                    using (DbDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (reader.HasRows)
                        {
                            while (await reader.ReadAsync())
                            {
                                item = HelperTcmPL.ConvertDbDataReaderToObject<T>(reader);
                            }
                        }
                    }
                    returnSysRefCursor.Dispose();
                    //reader.Close();
                    //reader.Dispose();
                    command.Dispose();
                }
                conn.Close();
            }
            return item;
        }

        //public virtual async Task<T> GetCacheAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL, string[] tags)
        //{
        //    var item = new T();
        //    string sql = "";
        //    bool cacheInError = false;

        //    var conn = _context.Database.GetDbConnection();

        //    using (var command = conn.CreateCommand())
        //    {
        //        command.CommandText = CommandText;
        //        command.CommandType = CommandType.StoredProcedure;
        //        if (_context.Database.GetCommandTimeout() != null)
        //            command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

        //        if (baseSpTcmPL != null)
        //            command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
        //        if (parameterSpTcmPL != null)
        //            command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, false).ToArray());

        //        if (_context.DisableCache == false)
        //        {
        //            sql = HelperTcmPL.CommandAsSql(command);

        //            if (IsCachedByUser == false)
        //                sql = sql.Replace("@UIUserId = " + baseSpTcmPL.UIUserId.ToString() + ", ", "");


        //        }

        //        await conn.OpenAsync();
        //        DbDataReader reader = await command.ExecuteReaderAsync();

        //        if (reader.HasRows)
        //        {
        //            while (await reader.ReadAsync())
        //            {
        //                item = HelperTcmPL.ConvertDbDataReaderToObject<T>(reader);
        //            }
        //        }

        //        reader.Dispose();
        //        command.Dispose();



        //    }
        //    conn.Close();

        //    return item;
        //}

        public virtual async Task<IEnumerable<T>> GetAllAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL, bool isStoreProc = true)
        {
            var items = new List<T>();
            using (var scope = _scopeFactory.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<ViewTcmPLContext>();

                var conn = _context.Database.GetDbConnection();
                await conn.OpenAsync();

                using (var command = conn.CreateCommand())
                {
                    command.CommandText = CommandText;
                    command.CommandType = isStoreProc ? CommandType.StoredProcedure : CommandType.Text;
                    ((OracleCommand)command).BindByName = true;
                    if (_context.Database.GetCommandTimeout() != null)
                        command.CommandTimeout = _context.Database.GetCommandTimeout() ?? 0;

                    if (baseSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
                    if (parameterSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, false).ToArray());

                    OracleParameter returnSysRefCursor = new OracleParameter();

                    if (isStoreProc)
                    {
                        returnSysRefCursor.OracleDbType = OracleDbType.RefCursor;
                        returnSysRefCursor.Direction = ParameterDirection.ReturnValue;
                        command.Parameters.Add(returnSysRefCursor);
                    }

                    using (DbDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (reader.HasRows)
                        {
                            while (await reader.ReadAsync())
                            {
                                var item = HelperTcmPL.ConvertDbDataReaderToObject<T>(reader);
                                items.Add(item);
                            }
                        }
                    }
                    returnSysRefCursor.Dispose();
                    //reader.Close();
                    //reader.Dispose();
                    command.Dispose();
                }
                conn.Close();
            }
            return items;
        }

        //public virtual async Task<IEnumerable<T>> GetAllCacheAsync(BaseSpTcmPL baseSpTcmPL , ParameterSpTcmPL parameterSpTcmPL, string[] tags)
        //{
        //    var items = new List<T>();
        //    string sql = "";
        //    bool cacheInError = false;

        //    var conn = _context.Database.GetDbConnection();

        //    using (var command = conn.CreateCommand())
        //    {
        //        command.CommandText = CommandText;
        //        command.CommandType = CommandType.StoredProcedure;
        //        if (_context.Database.GetCommandTimeout() != null)
        //            command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

        //        if (baseSpTcmPL != null)
        //            command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
        //        if (parameterSpTcmPL != null)
        //            command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, false).ToArray());

        //        if (_context.DisableCache == false)
        //        {
        //            sql = HelperTcmPL.CommandAsSql(command);

        //            //??? Need to change
        //            if (IsCachedByUser == false)
        //                sql = sql.Replace("@UIUserId = " + baseSpTcmPL.UIUserId.ToString() + ", ", "");

        //            sql += CacheKeySuffix == null ? "" : " " + string.Join("|", CacheKeySuffix);


        //        }

        //        await conn.OpenAsync();
        //        DbDataReader reader = await command.ExecuteReaderAsync();

        //        if (reader.HasRows)
        //        {
        //            while (await reader.ReadAsync())
        //            {
        //                var item = HelperTcmPL.ConvertDbDataReaderToObject<T>(reader);
        //                items.Add(item);
        //            }
        //        }
        //        reader.Dispose();
        //        command.Dispose();



        //    }
        //    conn.Close();

        //    return items;
        //}

        public virtual async Task<DataTable> GetDataTableAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL, bool isStoreProc = true)
        {
            var dt = new DataTable();
            using (var scope = _scopeFactory.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<ViewTcmPLContext>();

                var conn = _context.Database.GetDbConnection();
                await conn.OpenAsync();



                using (var command = conn.CreateCommand())
                {
                    command.CommandText = CommandText;
                    ((OracleCommand)command).BindByName = true;
                    if (_context.Database.GetCommandTimeout() != null)
                        command.CommandTimeout = _context.Database.GetCommandTimeout() ?? 0;

                    if (baseSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
                    if (parameterSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, false).ToArray());

                    OracleParameter returnSysRefCursor = new OracleParameter();

                    if (isStoreProc)
                    {
                        returnSysRefCursor.OracleDbType = OracleDbType.RefCursor;
                        returnSysRefCursor.Direction = ParameterDirection.ReturnValue;
                        command.Parameters.Add(returnSysRefCursor);
                    }

                    DbDataReader reader = await command.ExecuteReaderAsync();

                    if (reader.FieldCount > 0)
                    {
                        dt.Load(reader);
                    }
                    reader.Dispose();

                    command.Dispose();
                }
                conn.Close();
            }
            return dt;
        }

        public void Dispose()
        {
            //_context.Dispose();
            GC.SuppressFinalize(this);
        }

    }

}
