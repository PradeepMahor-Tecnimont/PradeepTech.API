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
    public class AttendancePrintLogDataTableListRepository : ViewTcmPLRepository<PrintLogDetailedListDataTableList>, IAttendancePrintLogDataTableListRepository
    {
        public AttendancePrintLogDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<PrintLogDetailedListDataTableList>> Get7DaySummary(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            //CommandText = "Select * From Table(selfservice.iot_print_log_qry.fn_past_7days_4_self(:p_person_id,:p_meta_id)) order by d_date desc";

            //return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL, false);

            CommandText = "selfservice.iot_print_log_qry.fn_past_7days_4_self";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);

        }

        public async Task<IEnumerable<PrintLogDetailedListDataTableList>> PrintLogDetailedList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            if(string.IsNullOrEmpty(parameterSpTcmPL.PEmpno))
                CommandText = "selfservice.iot_print_log_qry.fn_detailed_list_self";
            else
                CommandText = "selfservice.iot_print_log_qry.fn_detailed_list_other";


            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}