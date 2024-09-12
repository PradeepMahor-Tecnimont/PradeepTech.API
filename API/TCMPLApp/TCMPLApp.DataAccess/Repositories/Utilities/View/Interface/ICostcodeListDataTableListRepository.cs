using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Utilities;

namespace TCMPLApp.DataAccess.Repositories.Utilities
{
    public interface ICostcodeListDataTableListRepository
    {
        public Task<IEnumerable<CostcodeListDataTableList>> CostcodeListDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);


    }
}