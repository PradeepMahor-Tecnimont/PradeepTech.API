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
    public class DeskAreaDepartmentMapRequestRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IDeskAreaDepartmentMapRequestRepository
    {
        public DeskAreaDepartmentMapRequestRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }
        public async Task<DBProcMessageOutput> DeskAreaDepartmentMapCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_area_type_dept_mapping.sp_add_dm_area_type_dept_mapping";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> DeskAreaDepartmentMapEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_area_type_dept_mapping.sp_update_dm_area_type_dept_mapping";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> DeskAreaDepartmentMapDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_area_type_dept_mapping.sp_delete_dm_area_type_dept_mapping";
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}
