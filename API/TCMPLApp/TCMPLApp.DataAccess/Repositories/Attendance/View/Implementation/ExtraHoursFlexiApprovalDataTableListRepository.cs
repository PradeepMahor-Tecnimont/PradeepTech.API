using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public class ExtraHoursFlexiApprovalDataTableListRepository : ViewTcmPLRepository<ExtraHoursFlexiClaimApprovalDataTableList>, IExtraHoursFlexiApprovalDataTableListRepository
    {
        public ExtraHoursFlexiApprovalDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHours_qry.fn_pending_lead_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHours_qry.fn_pending_hod_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiHoDOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHours_qry.fn_pending_onbehalf_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_ExtraHours_qry.fn_pending_hr_approval";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}