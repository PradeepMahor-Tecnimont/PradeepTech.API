using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using TCMPLAPP.SendMail.WinService.Models;

namespace TCMPLAPP.SendMail.WinService.Context
{

    public class ExecTcmPLRepository<Tin, Tout> : IExecTcmPLRepository<Tin, Tout> where Tin : class, new() where Tout : class, new()
    {
        public string CommandText { get; set; }
        public string[] CacheKeySuffix { get; set; }
        public bool IsCachedByUser { get; set; } = true;
        public int AbsoluteExpirationRelativeToNowMinute { get; set; } = 60;

        //private readonly ExecTcmPLContext _context;
        private readonly ILogger<ExecTcmPLContext> _logger;
        private readonly IServiceScopeFactory _scopeFactory;

        public ExecTcmPLRepository(ILogger<ExecTcmPLContext> logger, IServiceScopeFactory scopeFactory)
        {
            //_context = context;
            _logger = logger;
            _scopeFactory = scopeFactory;
            CommandText = "";
            CacheKeySuffix = Array.Empty<string>();
        }

        public virtual async Task<Tout> ExecAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput)
        {
            var tOutput = new Tout();
            using (var scope = _scopeFactory.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<ViewTcmPLContext>();

                var conn = _context.Database.GetDbConnection();
                await conn.OpenAsync();

                using (var command = conn.CreateCommand())
                {
                    command.CommandText = CommandText;
                    command.CommandType = CommandType.StoredProcedure;
                    ((OracleCommand)command).BindByName = true;
                    if (_context.Database.GetCommandTimeout() != null)
                        command.CommandTimeout = _context.Database.GetCommandTimeout().GetValueOrDefault();

                    if (baseSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
                    if (tInput != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, false).ToArray());
                    //if (tOutput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameterOutput<Tout>().ToArray());


                    int rowCount = await command.ExecuteNonQueryAsync();

                    tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);

                    command.Dispose();
                }
                conn.Close();
            }
            return tOutput;
        }

        public virtual async Task<Tout> ExecCacheAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput, string[] tags)
        {
            var tOutput = new Tout();
            string sql = "";
            using (var scope = _scopeFactory.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<ViewTcmPLContext>();

                var conn = _context.Database.GetDbConnection();

                using (var command = conn.CreateCommand())
                {
                    command.CommandText = CommandText;
                    command.CommandType = CommandType.StoredProcedure;
                    if (_context.Database.GetCommandTimeout() != null)
                        command.CommandTimeout = _context.Database.GetCommandTimeout().GetValueOrDefault();

                    if (baseSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
                    if (tInput != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, false).ToArray());

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
            }
            return tOutput;
        }


        public virtual async Task<Tout> ExecBulkAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput)
        {
            var tOutput = new Tout();
            using (var scope = _scopeFactory.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<ViewTcmPLContext>();

                var conn = _context.Database.GetDbConnection();
                await conn.OpenAsync();

                using (var command = conn.CreateCommand())
                {
                    command.CommandText = CommandText;
                    command.CommandType = CommandType.StoredProcedure;
                    ((OracleCommand)command).BindByName = true;
                    if (_context.Database.GetCommandTimeout() != null)
                        command.CommandTimeout = _context.Database.GetCommandTimeout().GetValueOrDefault();

                    if (baseSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
                    if (tInput != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, false).ToArray());
                    //if (tOutput != null)
                    command.Parameters.AddRange(HelperTcmPL.FillOracleParameterOutput<Tout>().ToArray());


                    int rowCount = await command.ExecuteNonQueryAsync();

                    tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);

                    command.Dispose();
                }
                conn.Close();
            }
            return tOutput;
        }

        public virtual async Task<Tout> StorageValuedFunctionAsync(BaseSpTcmPL baseSpTcmPL, Tin tInput)
        {
            var tOutput = new Tout();
            using (var scope = _scopeFactory.CreateScope())
            {
                var _context = scope.ServiceProvider.GetRequiredService<ViewTcmPLContext>();

                var conn = _context.Database.GetDbConnection();
                await conn.OpenAsync();

                using (var command = conn.CreateCommand())
                {
                    command.CommandText = CommandText;
                    command.CommandType = CommandType.StoredProcedure;
                    if (_context.Database.GetCommandTimeout() != null)
                        command.CommandTimeout = _context.Database.GetCommandTimeout().GetValueOrDefault();

                    if (baseSpTcmPL != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(baseSpTcmPL).ToArray());
                    if (tInput != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameter(tInput, false).ToArray());
                    if (tOutput != null)
                        command.Parameters.AddRange(HelperTcmPL.FillOracleParameterReturnValue<Tout>().ToArray());

                    int rowCount = await command.ExecuteNonQueryAsync();

                    tOutput = HelperTcmPL.ConvertDbParameterToObject<Tout>(command.Parameters);

                    command.Dispose();
                }
                conn.Close();
            }
            return tOutput;
        }

        public void Dispose()
        {
            //_context.Dispose();
            GC.SuppressFinalize(this);
        }

    }

}
