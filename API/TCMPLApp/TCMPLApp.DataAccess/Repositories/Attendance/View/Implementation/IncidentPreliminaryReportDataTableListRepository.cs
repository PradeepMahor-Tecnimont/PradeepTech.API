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
    public class IncidentPreliminaryReportDataTableListRepository : ViewTcmPLRepository<IncidentPreliminaryReportDataTableList>, IIncidentPreliminaryReportDataTableListRepository
    {
        public IncidentPreliminaryReportDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<IncidentPreliminaryReportDataTableList>> IncidentPreliminaryReportDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_guest_meet_qry.fn_incident_preliminary_report";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}