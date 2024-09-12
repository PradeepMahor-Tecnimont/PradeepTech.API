using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPSmartWorkSpaceDataTableListRepository
    {
        public Task<IEnumerable<SmartWorkSpaceDataTableList>> SmartWorkSpaceDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<SmartWorkSpaceDataTableList>> SmartWorkSpaceAllDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        

        public Task<IEnumerable<SmartWorkSpaceDataTableList>> SmartWorkSpaceEmpDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}