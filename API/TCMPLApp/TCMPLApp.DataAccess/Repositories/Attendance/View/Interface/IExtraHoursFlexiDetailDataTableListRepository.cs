using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IExtraHoursFlexiDetailDataTableListRepository
    {
        public Task<IEnumerable<ExtraHoursFlexiClaimDetailDataTable>> ExtraHoursFlexiClaimDetailDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}