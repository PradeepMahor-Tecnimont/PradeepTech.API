using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;


namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPSmartWorkSpaceExcelDataTableListRepository
    {
        public Task<IEnumerable<SmartWorkSpaceExcelDataTableList>> SmartWorkSpacePlanningExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);


        public Task<IEnumerable<SmartWorkSpaceExcelDataTableList>> SmartWorkSpaceCurrentExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);


        public Task<IEnumerable<SmartWorkSpaceExcelDataTableList>> SmartWorkSpaceAllExcelDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

    }
}
