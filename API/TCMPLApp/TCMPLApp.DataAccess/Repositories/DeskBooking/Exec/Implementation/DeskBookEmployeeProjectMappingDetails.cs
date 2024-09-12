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
    public class DeskBookEmployeeProjectMappingDetails : ExecTcmPLRepository<ParameterSpTcmPL, DeskBookEmployeeProjectMappingOutPut>, IDeskBookEmployeeProjectMappingDetails
    {
        public DeskBookEmployeeProjectMappingDetails(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DeskBookEmployeeProjectMappingOutPut> DeskBookEmployeeProjectMappingDetailsAsync(BaseSpTcmPL baseSpTcmPL,ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_emp_proj_map_qry.sp_db_emp_emp_proj_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
