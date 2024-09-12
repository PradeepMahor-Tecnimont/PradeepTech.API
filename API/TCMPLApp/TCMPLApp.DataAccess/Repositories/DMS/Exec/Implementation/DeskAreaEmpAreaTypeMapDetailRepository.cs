using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DeskAreaEmpAreaTypeMapDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, DeskAreaEmpAreaTypeMapDetails>, IDeskAreaEmpAreaTypeMapDetailRepository
    {
        public DeskAreaEmpAreaTypeMapDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DeskAreaEmpAreaTypeMapDetails> DeskAreaEmpAreaTypeMapDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "DMS.pkg_dm_area_type_emp_area_mapping.sp_dm_area_type_emp_area_mapping_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}