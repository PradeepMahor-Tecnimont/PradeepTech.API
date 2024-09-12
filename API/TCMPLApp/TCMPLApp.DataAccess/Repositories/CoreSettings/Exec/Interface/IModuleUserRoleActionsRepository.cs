﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public interface IModuleUserRoleActionsRepository
    {
        public Task<DBProcMessageOutput> ModuleUserRoleActionsCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
