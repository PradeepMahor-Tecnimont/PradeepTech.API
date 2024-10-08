﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.RapReporting
{
    public interface IExptJobsDataTableListRepository
    {
        public Task<IEnumerable<ExptJobsDataTableList>> ExptJobsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}
