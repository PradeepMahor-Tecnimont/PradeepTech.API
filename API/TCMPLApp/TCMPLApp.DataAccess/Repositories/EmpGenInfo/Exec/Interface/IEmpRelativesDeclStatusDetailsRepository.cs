using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public interface IEmpRelativesDeclStatusDetailsRepository
    {
        public Task<EmpRelativesDeclStatusDetailOut> EmpRelativesDeclStatusDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
