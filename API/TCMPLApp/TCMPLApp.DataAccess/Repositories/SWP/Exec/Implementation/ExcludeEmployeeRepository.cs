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

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class ExcludeEmployeeRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IExcludeEmployeeRepository
    {
        public ExcludeEmployeeRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> CreateExcludeEmployeeAsync(
                    BaseSpTcmPL baseSpTcmPL,
                    ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_exclude_emp.sp_add_swp_exclude_emp";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> UpdateExcludeEmployeeAsync(
                    BaseSpTcmPL baseSpTcmPL,
                    ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_exclude_emp.sp_update_swp_exclude_emp";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> DeleteExcludeEmployeeAsync(
                    BaseSpTcmPL baseSpTcmPL,
                    ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_exclude_emp.sp_delete_swp_exclude_emp";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}