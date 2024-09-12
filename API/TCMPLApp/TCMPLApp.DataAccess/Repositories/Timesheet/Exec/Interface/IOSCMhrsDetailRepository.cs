using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.Timesheet;
using TCMPLApp.Domain.Models.Timesheet.View;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public interface IOSCMhrsDetailRepository
    {        
        public Task<OSCMhrsDetail> OSCMhrsDetailAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);       

    }
}
