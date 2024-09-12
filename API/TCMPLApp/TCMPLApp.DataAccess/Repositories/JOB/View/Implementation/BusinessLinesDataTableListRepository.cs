﻿using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.JOB;

namespace TCMPLApp.DataAccess.Repositories.JOB
{
    public class BusinessLinesDataTableListRepository : ViewTcmPLRepository<BusinessLinesDataTableList>, IBusinessLinesDataTableListRepository
    {
        public BusinessLinesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
            
        }
        public async Task<IEnumerable<BusinessLinesDataTableList>> BusinessLinesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.pkg_job_masters_qry.fn_business_line_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<BusinessLinesDataTableList>> BusinessLinesDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_area_categories_qry.fn_xl_download_area_categories";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
