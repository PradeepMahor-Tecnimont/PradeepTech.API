﻿using DocumentFormat.OpenXml.Spreadsheet;
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
    public class DeskAreaProjectMapDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, DeskAreaProjectMapDetails>, IDeskAreaProjectMapDetailRepository
    {
        public DeskAreaProjectMapDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DeskAreaProjectMapDetails> DeskAreaProjectMapDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "DMS.pkg_dm_area_type_project_mapping_qry.sp_dm_area_type_project_mapping_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}
