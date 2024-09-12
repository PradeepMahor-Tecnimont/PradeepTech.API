using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvConsumablesImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, ConsumablesOutPut>, IInvConsumablesImportRepository
    {

        public InvConsumablesImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context,  logger)
        {
            
        }

        public async Task<ConsumablesOutPut> ImportConsumablesAsync(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_consumables.sp_import";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            //var tags = new string[] {
            //    $"USER/{ baseSpTcmPL.UIUserId }"
            //};
            //await _redisContext.Cache.InvalidateKeysByTagAsync(tags);

            return response;

        }


    }
}
