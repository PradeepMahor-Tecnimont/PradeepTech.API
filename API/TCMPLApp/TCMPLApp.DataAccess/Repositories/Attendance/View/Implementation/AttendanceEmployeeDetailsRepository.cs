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
    public class AttendanceEmployeeDetailsRepository : ViewTcmPLRepository<EmployeeDetails>, IAttendanceEmployeeDetailsRepository
    {
        public AttendanceEmployeeDetailsRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<EmployeeDetails> AttendanceEmployeeDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_emplmast.fn_employee_details";

            return await GetAsync(baseSpTcmPL, parameterSpTcmPL);
        }


    }







}
