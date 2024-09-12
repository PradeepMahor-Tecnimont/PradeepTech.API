using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvAddOnContainerRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IInvAddOnContainerRepository
    {
        public InvAddOnContainerRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> InvAddOnContainerCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_addon_container.sp_update_addon_container";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> InvAddOnContainerDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_addon_container.sp_delete_addon_container";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
