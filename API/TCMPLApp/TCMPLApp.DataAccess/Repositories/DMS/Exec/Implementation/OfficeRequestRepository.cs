using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.DigiForm;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class OfficeRequestRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IOfficeRequestRepository
    {
        public OfficeRequestRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<DBProcMessageOutput> OfficesCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_offices.sp_add_dm_offices";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> OfficesEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_offices.sp_update_dm_offices";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> OfficesDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_offices.sp_delete_dm_offices";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}
