using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class DeskBookEmployeeProjectMappingDataTableListRepository : ViewTcmPLRepository<DeskBookEmployeeProjectMappingDataTableList>, IDeskBookEmployeeProjectMappingDataTableListRepository
    {
        public DeskBookEmployeeProjectMappingDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskBookEmployeeProjectMappingDataTableList>> DeskBookEmployeeProjectMappingDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_emp_proj_map_qry.fn_emp_proj_map_list";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
