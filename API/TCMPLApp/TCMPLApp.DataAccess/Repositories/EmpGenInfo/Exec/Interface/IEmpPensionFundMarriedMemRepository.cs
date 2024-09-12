using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IEmpPensionFundMarriedMemRepository
    {
        public Task<DBProcMessageOutput> EmpPensionFundMarriedMemCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> EmpPensionFundMarriedMemEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> EmpPensionFundMarriedMemDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> HREmpPensionFundMarriedMemCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> HREmpPensionFundMarriedMemEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<DBProcMessageOutput> HREmpPensionFundMarriedMemDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}