﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.CoreSettings;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.CoreSettings
{
    public interface IModulesDataTableListRepository
    {
        public Task<IEnumerable<ModulesDataTableList>> ModulesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}