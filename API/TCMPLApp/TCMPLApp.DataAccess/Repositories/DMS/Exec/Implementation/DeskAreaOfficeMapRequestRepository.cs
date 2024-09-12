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
    public class DeskAreaOfficeMapRequestRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDeskAreaOfficeMapRequestRepository
    {
        public DeskAreaOfficeMapRequestRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<DBProcMessageOutput> DeskAreaOfficeMapCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_desk_area_office_map.sp_add_dm_desk_area_office_map";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> DeskAreaOfficeMapDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_desk_area_office_map.sp_delete_dm_desk_area_office_map";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}
