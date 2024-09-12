using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.HSE;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class LoPLastSalaryMonthDetailsRepository : ExecTcmPLRepository<ParameterSpTcmPL, LoPLastSalaryMonthDetailsOut>, ILoPLastSalaryMonthDetailsRepository
    {
        public LoPLastSalaryMonthDetailsRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<LoPLastSalaryMonthDetailsOut> LoPLastSalaryMonthDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.pkg_ss_absent_excess_leave_lop_qry.sp_get_last_salary_month";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
