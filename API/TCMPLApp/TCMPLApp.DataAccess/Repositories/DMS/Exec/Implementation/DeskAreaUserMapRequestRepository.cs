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
    public class DeskAreaUserMapRequestRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDeskAreaUserMapRequestRepository
    {
        public DeskAreaUserMapRequestRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> SetDeskAreaUserMapAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_area_type_User_mapping.sp_set_area_type_user_mapping";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        public async Task<DBProcMessageOutput> DeskAreaUserMapDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_area_type_User_mapping.sp_delete_area_type_user_mapping";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}