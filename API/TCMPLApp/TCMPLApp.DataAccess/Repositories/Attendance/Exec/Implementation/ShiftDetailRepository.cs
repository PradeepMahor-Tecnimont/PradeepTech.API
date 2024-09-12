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

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class ShiftDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, ShiftDetails>, IShiftDetailRepository
    {
        public ShiftDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<ShiftDetails> ShiftDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_shift_master.sp_shift_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
