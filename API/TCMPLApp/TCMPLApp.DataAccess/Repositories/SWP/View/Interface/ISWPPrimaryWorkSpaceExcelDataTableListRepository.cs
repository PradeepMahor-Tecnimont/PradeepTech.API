using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPPrimaryWorkSpaceExcelDataTableListRepository
    {
        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpacePlanningExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);


        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpaceCurrentExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
