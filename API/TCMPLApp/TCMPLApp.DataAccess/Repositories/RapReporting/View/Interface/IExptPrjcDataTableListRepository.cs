using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public interface IExptPrjcDataTableListRepository
    {
        public Task<IEnumerable<ExptPrjcDataTableList>> ExptPrjcDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<ExptPrjcDataTableList>> ExptPrjcAllDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
