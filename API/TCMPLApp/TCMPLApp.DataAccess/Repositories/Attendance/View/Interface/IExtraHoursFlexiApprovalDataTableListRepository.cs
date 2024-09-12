using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IExtraHoursFlexiApprovalDataTableListRepository
    {
        public Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiLeadApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiHoDApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiHRApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<ExtraHoursFlexiClaimApprovalDataTableList>> ExtraHoursFlexiHoDOnBehalfApprovalDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}