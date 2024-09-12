using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IEmpPensionFundDetailsDataTableListRepository
    {
        public Task<IEnumerable<EmpPensionFundDetailsDataTableList>> EmpPensionFundDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<EmpPensionFundDetailsDataTableList>> HREmpPensionFundDetailsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}