using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;


namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPDMSDeskAllocationSWPDataTableListRepository
    {
        public Task<IEnumerable<DeskAllocationSWPDataTableList>> DeskAllocationSWPList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
