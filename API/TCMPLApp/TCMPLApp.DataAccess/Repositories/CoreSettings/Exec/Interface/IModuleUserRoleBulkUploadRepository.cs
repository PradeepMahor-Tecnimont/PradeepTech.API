﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.CoreSettings;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public interface IModuleUserRoleBulkUploadRepository
    {
        public Task<ModuleUserRoleOutPut> ModuleUserRoleJSonAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
