using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.Attendance
{
    public interface IAttendanceActionsExecutor
    {
        public Task<DBProcMessageOutput> LeaveApprovalRollbackLead(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> LeaveApprovalRollbackHoD(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> LeaveApprovalRollbackHR(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);


        public Task<DBProcMessageOutput> LeaveRejectionRollbackLead(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> LeaveRejectionRollbackHoD(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> LeaveRejectionRollbackHR(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> ExtraHoursRejectionRollbackHR(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> OndutyApprovalRollback(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
    }
}
