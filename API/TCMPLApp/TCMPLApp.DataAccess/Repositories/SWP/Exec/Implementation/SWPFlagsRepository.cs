using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPFlagsRepository : ExecTcmPLRepository<ParameterSpTcmPL, SWPFlagsOutPut>, ISWPFlagsRepository
    {
        public SWPFlagsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }

        public async Task<SWPFlagsOutPut> SWPAllFlags(
            BaseSpTcmPL baseSpTcmPL,
            ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_swp_flags.get_all_flags";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

    }
}
