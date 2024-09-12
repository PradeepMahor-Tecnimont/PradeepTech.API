using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Data.Common;
//using Microsoft.AspNetCore.Http;

namespace TCMPLApp.DataAccess.Base
{

    public class ExecTcmPLRepository<Tin, Tout> : IExecTcmPLRepository<Tin, Tout> where Tin : class, new() where Tout : class, new()
    {
        public string CommandText { get; set; }
        public string[] CacheKeySuffix { get; set; }
        public bool IsCachedByUser { get; set; } = true;
        public int AbsoluteExpirationRelativeToNowMinute { get; set; } = 60;

        private readonly ExecTcmPLContext _context;
        private readonly ILogger<ExecTcmPLContext> _logger;

        public ExecTcmPLRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger)
        {
            _context = context;
            _logger = logger;
        }

        public virtual async Task<Tout> ExecAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput)
        {
            Exception exception = null;
            var tOutput = new Tout();

            var conn = _context.Database.GetDbConnection();
            //if (conn.State == ConnectionState.Open) { conn.Close(); }
            await conn.OpenAsync();

            using (var command = conn.CreateCommand())
            {
                command.CommandText = CommandText;
                command.CommandType = CommandType.StoredProcedure;
                ((OracleCommand)command).BindByName = true;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (tInput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, (OracleConnection)conn, false).ToArray());
                //if (tOutput != null)
                command.Parameters.AddRange(HelperTcmPL.FillOracleParameterOutput<Tout>().ToArray());

                try
                {
                    int rowCount = await command.ExecuteNonQueryAsync();
                    if (command.Parameters.Contains("P_MESSAGE_TEXT") && HelperTcmPL.EnvIsProduction)
                    {
                        command.Parameters["P_MESSAGE_TEXT"].Value = (Oracle.ManagedDataAccess.Types.OracleString)HandleDBMessage(command);
                    }

                    tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);
                }
                catch (Exception ex)
                {
                    exception = ex;
                }
                finally
                {
                    foreach (OracleParameter oraParam in command.Parameters)
                    {
                        if (oraParam.OracleDbType == OracleDbType.RefCursor)
                            oraParam.Dispose();
                    }

                    command.Dispose();
                }
            }
            conn.Close();
            HandleDBcontextException(exception);
            return tOutput;
        }

        public virtual async Task<Tout> ExecCacheAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput, string[] tags)
        {
            var tOutput = new Tout();
            string sql = "";
            //bool cacheInError = false;

            var conn = _context.Database.GetDbConnection();

            using (var command = conn.CreateCommand())
            {
                command.CommandText = CommandText;
                command.CommandType = CommandType.StoredProcedure;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (tInput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, (OracleConnection)conn, false).ToArray());

                if (_context.DisableCache == false)
                    sql = HelperTcmPL.CommandAsSql(command);

                if (tOutput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameterOutput<Tout>().ToArray());

                if (_context.DisableCache == false)
                {
                    //if (IsCachedByUser == false)
                    //    sql = sql.Replace("@UIUserId = " + baseSpTcmPL.UIUserId.ToString() + ", ", "");

                    sql += CacheKeySuffix == null ? "" : " " + string.Join("|", CacheKeySuffix);

                }

                await conn.OpenAsync();
                int rowCount = await command.ExecuteNonQueryAsync();

                tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);

                command.Dispose();


                //cacheInError = false;

            }
            conn.Close();

            return tOutput;
        }


        public virtual async Task<Tout> ExecBulkAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput)
        {
            Exception exception = null;

            var tOutput = new Tout();

            var conn = _context.Database.GetDbConnection();
            await conn.OpenAsync();

            using (var command = conn.CreateCommand())
            {
                command.CommandText = CommandText;
                command.CommandType = CommandType.StoredProcedure;
                ((OracleCommand)command).BindByName = true;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (tInput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, (OracleConnection)conn, false).ToArray());
                //if (tOutput != null)
                command.Parameters.AddRange(HelperTcmPL.FillOracleParameterOutput<Tout>().ToArray());


                try
                {
                    int rowCount = await command.ExecuteNonQueryAsync();
                    if (command.Parameters.Contains("P_MESSAGE_TEXT") && HelperTcmPL.EnvIsProduction)
                    {
                        command.Parameters["P_MESSAGE_TEXT"].Value = (Oracle.ManagedDataAccess.Types.OracleString)HandleDBMessage(command);
                    }

                    tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);
                }
                catch (Exception ex)
                {
                    exception = ex;
                }
                finally
                {
                    foreach (OracleParameter oraParam in command.Parameters)
                    {
                        if (oraParam.OracleDbType == OracleDbType.RefCursor)
                            oraParam.Dispose();
                    }

                    command.Dispose();
                }

                //int rowCount = await command.ExecuteNonQueryAsync();

                //tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);

                //command.Dispose();
            }
            conn.Close();
            HandleDBcontextException(exception);
            return tOutput;
        }

        public virtual async Task<Tout> StorageValuedFunctionAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput)
        {
            var tOutput = new Tout();

            var conn = _context.Database.GetDbConnection();
            await conn.OpenAsync();

            using (var command = conn.CreateCommand())
            {
                command.CommandText = CommandText;
                command.CommandType = CommandType.StoredProcedure;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (tInput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, (OracleConnection)conn, false).ToArray());
                if (tOutput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameterReturnValue<Tout>().ToArray());

                int rowCount = await command.ExecuteNonQueryAsync();

                tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);

                command.Dispose();
            }
            conn.Close();

            return tOutput;
        }

        public virtual async Task<Tout> StorageValuedFunctionCacheAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput, string[] tags)
        {
            var tOutput = new Tout();
            string sql = "";
            //bool cacheInError = false;

            var conn = _context.Database.GetDbConnection();

            using (var command = conn.CreateCommand())
            {
                command.CommandText = CommandText;
                command.CommandType = CommandType.StoredProcedure;
                if (_context.Database.GetCommandTimeout() != null)
                    command.CommandTimeout = _context.Database.GetCommandTimeout().Value;

                if (baseSpTcmPL != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL, (OracleConnection)conn).ToArray());
                if (tInput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, (OracleConnection)conn, false).ToArray());

                if (_context.DisableCache == false)
                    sql = HelperTcmPL.CommandAsSql(command);

                if (tOutput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameterReturnValue<Tout>().ToArray());

                if (_context.DisableCache == false)
                {
                    //if (IsCachedByUser == false)
                    //    sql = sql.Replace("@UIUserId = " + baseSpTcmPL.UIUserId.ToString() + ", ", "");

                    sql += CacheKeySuffix == null ? "" : " " + string.Join("|", CacheKeySuffix);


                }

                await conn.OpenAsync();
                int rowCount = await command.ExecuteNonQueryAsync();

                tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);

                command.Dispose();


            }
            conn.Close();

            return tOutput;
        }

        public void Dispose()
        {
            _context.Dispose();
            GC.SuppressFinalize(this);
        }

        private void HandleDBcontextException(Exception exception)
        {
            if (exception != null)
            {
                throw exception;
            }
        }
        private string HandleDBMessage(DbCommand dbCommand )
        {
            if(dbCommand.Parameters["P_MESSAGE_TEXT"].Value?.ToString().ToUpper().Contains("ORA-") ?? false)
            {
                _logger.LogError("DBCommand - " + dbCommand.CommandText);
                _logger.LogError("MetaId - " + dbCommand.Parameters["P_META_ID"].Value?.ToString());
                _logger.LogError("DBMessage - " + dbCommand.Parameters["P_MESSAGE_TEXT"].Value?.ToString());
                return "Internal DB error occured.";
            }
            else
                return dbCommand.Parameters["P_MESSAGE_TEXT"].Value?.ToString();
        }
    }

}
