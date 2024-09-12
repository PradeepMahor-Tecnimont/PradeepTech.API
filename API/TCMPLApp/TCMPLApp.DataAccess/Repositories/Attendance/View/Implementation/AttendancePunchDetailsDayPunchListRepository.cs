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
    public class AttendancePunchDetailsDayPunchListRepository : ViewTcmPLRepository<PunchDetailsDayPunchList>, IAttendancePunchDetailsDayPunchListRepository
    {
        public AttendancePunchDetailsDayPunchListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<PunchDetailsDayPunchList>> DayPunchList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = @"Select
                                *
                            From
                                Table(selfservice.iot_punch_details.fn_day_punch_list(
                                        p_person_id => :p_person_id,
                                        p_meta_id   => :p_meta_id,
                                        p_empno     => :p_empno,
                                        p_date      => :p_date)
                                )";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL,false);
        }

        //public async Task<IEnumerable<PunchDetailsDataTableList>> AttendanceOnDutyHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        //{
        //    CommandText = "selfservice.iot_onduty_qry.fn_onduty_hod_approval";

        //    return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        //}

        //public async Task<IEnumerable<PunchDetailsDataTableList>> AttendanceOnDutyHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        //{
        //    CommandText = "selfservice.iot_onduty_qry.fn_onduty_hr_approval";

        //    return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        //}
    }
}