using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public interface ISWPPrimaryWorkSpaceDataTableListRepository
    {
        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpaceDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpace4AdminDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpacePlanning4AdminDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> PrimaryWorkSpacePlanningDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> GetPrimaryWorkSpaceCurrentDownload(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<PrimaryWorkSpaceDataTableList>> GetPrimaryWorkSpacePlanningDownload(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}