using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWP;

namespace TCMPLApp.DataAccess.Repositories.SWP
{
    public class SWPEmployeeProjectMappingDataTableListRepository : ViewTcmPLRepository<EmployeeProjectMappingDataTableList>, ISWPEmployeeProjectMappingDataTableListRepository
    {
        public SWPEmployeeProjectMappingDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<EmployeeProjectMappingDataTableList>> EmployeeProjectMappingDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
             CommandText = "selfservice.IOT_SWP_EMP_PROJ_MAP_QRY.fn_emp_proj_map_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

       
    }
}