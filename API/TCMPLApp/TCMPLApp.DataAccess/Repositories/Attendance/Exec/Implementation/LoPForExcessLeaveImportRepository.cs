using DocumentFormat.OpenXml.Spreadsheet;
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
    public class LoPForExcessLeaveImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, LoPForExcessLeaveOutPut>, ILoPForExcessLeaveImportRepository
    {
        public LoPForExcessLeaveImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<LoPForExcessLeaveOutPut> ImportLopForExcessLeaveAsync(BaseSpTcmPL baseSpTcmPL,ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_ss_absent_excess_leave_lop_excel.sp_import_lop";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;

        }
    }
}
