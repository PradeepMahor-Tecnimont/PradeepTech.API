using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public interface IDeskAreaProjectMapRepository
    {
        public Task<DBProcMessageOutput> DeskAreaprojectMapCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> DeskAreaprojectMapEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<DBProcMessageOutput> DeskAreaprojectMapDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
