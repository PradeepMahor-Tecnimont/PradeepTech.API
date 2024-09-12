using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.DataAccess.Base
{

    public class ViewTcmPLRepository<T> : IViewTcmPLRepository<T> where T : class, new()
    {
        public string CommandText { get; set; }
        public string[] CacheKeySuffix { get; set; }
        public bool IsCachedByUser { get; set; } = true;
        public int AbsoluteExpirationRelativeToNowMinute { get; set; } = 60;

        private readonly ViewTcmPLContext _context;
         private readonly ILogger<ViewTcmPLContext> _logger;

        public ViewTcmPLRepository(ViewTcmPLContext context,  ILogger<ViewTcmPLContext> logger)
        {
            _context = context;
             _logger = logger;
        }

        public virtual async Task<T> GetAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            var item = new T();
            
            var conn = _context.Database.GetDbConnection();            
            await conn.OpenAsync();

            using (var command = conn.CreateCommand())
            {
                command.Connection = (OracleConnection)conn;
                ((OracleCommand)command).BindByName = true;
                command.CommandText = CommandText;
                command.CommandType = CommandType.StoredProcedure;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (parameterSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, (OracleConnection)conn, false).ToArray());

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

            var conn = _context.Database.GetDbConnection();
            await conn.OpenAsync();

            using (var command = conn.CreateCommand())
            {
                command.CommandText = CommandText;
                command.CommandType = isStoreProc ? CommandType.StoredProcedure : CommandType.Text;
                ((OracleCommand)command).BindByName = true;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (parameterSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, (OracleConnection)conn, false).ToArray());

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
            //var dt = new DataTable();
            DataSet ds = new();

            var conn = _context.Database.GetDbConnection();
            await conn.OpenAsync();



            using (var command = conn.CreateCommand())
            {
                command.CommandText = CommandText;
                ((OracleCommand)command).BindByName = true;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (parameterSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(parameterSpTcmPL, (OracleConnection)conn, false).ToArray());

                OracleParameter returnSysRefCursor = new OracleParameter();

                if (isStoreProc)
                {
                    returnSysRefCursor.OracleDbType = OracleDbType.RefCursor;
                    returnSysRefCursor.Direction = ParameterDirection.ReturnValue;
                    command.Parameters.Add(returnSysRefCursor);
                    command.CommandType= CommandType.StoredProcedure;
                }

                int rowCount = await command.ExecuteNonQueryAsync();

                OracleDataAdapter oracleDataAdapter = new OracleDataAdapter((OracleCommand)command);
                oracleDataAdapter.Fill(ds);


                foreach (OracleParameter oraParam in command.Parameters)
                {
                    if (oraParam.OracleDbType == OracleDbType.RefCursor)
                        oraParam.Dispose();
                }

                oracleDataAdapter.Dispose();
                command.Dispose();


            }
            conn.Close();

            return ds.Tables[0]; ;
        }

        public void Dispose()
        {
            _context.Dispose();
            GC.SuppressFinalize(this);
        }

    }

}
