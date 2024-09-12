using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.Logbook;

namespace TCMPLApp.DataAccess.Repositories.Logbook
{
    public interface ILogbookDataTableListRepository
    {
        public Task<IEnumerable<LogbookDataTableList>> LogbookDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
