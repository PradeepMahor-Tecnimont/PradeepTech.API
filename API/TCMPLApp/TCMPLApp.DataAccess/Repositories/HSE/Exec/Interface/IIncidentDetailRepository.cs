using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories.HSE
{
    public interface IIncidentDetailRepository
    {
        public Task<IncidentDetailOut> IncidentDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
