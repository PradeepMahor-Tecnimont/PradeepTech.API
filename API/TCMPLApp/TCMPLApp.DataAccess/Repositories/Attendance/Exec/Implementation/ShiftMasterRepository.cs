using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.DeskBooking;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class ShiftMasterRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IShiftMasterRepository
    {
        public ShiftMasterRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> ShiftCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_shift_master.sp_add_shift";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }

        public async Task<DBProcMessageOutput> ShiftDetailsEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_shift_master.sp_shift_details_update";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> ShiftConfigDetailsEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_shift_master.sp_shift_config_details_update";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> ShiftDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_shift_master.sp_delete_shift";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
        public async Task<DBProcMessageOutput> ShiftLunchConfigDetailsEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_shift_master.sp_shift_lunch_details_update";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
        public async Task<DBProcMessageOutput> ShiftHalfDayConfigDetailsEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_shift_master.sp_shift_half_day_details_update";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);
            return response;
        }
    }
}
