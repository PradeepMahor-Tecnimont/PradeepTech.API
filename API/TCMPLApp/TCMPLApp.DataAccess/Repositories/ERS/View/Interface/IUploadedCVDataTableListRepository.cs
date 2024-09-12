using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.ERS;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories.ERS
{
    public interface IUploadedCVDataTableListRepository
    {
        public Task<IEnumerable<UploadedCVDataTableList>> UploadedCVDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        
    }
}
