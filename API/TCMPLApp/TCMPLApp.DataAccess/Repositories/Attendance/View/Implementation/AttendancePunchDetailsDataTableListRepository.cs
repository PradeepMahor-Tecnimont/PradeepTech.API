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
    public class AttendancePunchDetailsDataTableListRepository : ViewTcmPLRepository<PunchDetailsDataTableList>, IAttendancePunchDetailsDataTableListRepository
    {
        public AttendancePunchDetailsDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<PunchDetailsDataTableList>> AttendancePunchDetailsDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "select * from table(selfservice.iot_punch_details.fn_punch_details_4_self(:p_person_id,:p_meta_id,:p_empno,:p_yyyymm,:p_for_ot)) order by punch_date";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL,false);
        }

        

    }
}