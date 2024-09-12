using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IHRVoluntaryParentPolicyDataTableListRepository
    {
        public Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> HRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> ExcelHRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> ExcelNotLockedHRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> ExcelNotFiledHRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}